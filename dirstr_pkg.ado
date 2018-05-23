/*====================================================================
project:       create pkg file for ado file 
Author:        Andres Castaneda 
----------------------------------------------------------------------
Creation Date:    22may2018
====================================================================*/

/*====================================================================
0: Program set up
====================================================================*/


program define dirstr_pkg
syntax anything(name=pkg), [replace dir(string) ]

qui {
	
	/*====================================================================
	1: create pkg file
	====================================================================*/
  	
	confirm new file "`dir'/`pkg'.pkg"
	
	tempfile fout
	tempname f
	local date: disp %td date("`c(current_date)'", "DMY")
	local datetime: disp %tcDDmonthCCYY-HHMMSS clock("`c(current_date)'`c(current_time)'", "DMYhms")
	local datetime = trim("`datetime'")
	
	file open `f' using `fout', write append
	file write `f' `"v 3"' _n
	file write `f' `""' _n
	file write `f' `"d HERE GOES THE SHORT DESCRIPTION"' _n
	file write `f' `"d "' _n
	file write `f' `"d {p 4 4 2} {cmd:`pkg'} <replace with long description>.{p_end}"' _n
	file write `f' `"d"' _n
	file write `f' `"d {p 4 4 2} {ul:Contributing authors:} <Include your name and collaborators> {p_end}"' _n
	file write `f' `"d"' _n
	file write `f' `"d Distribution-Date: `date'"' _n
	file write `f' `"  "' _n
	file write `f' `"f `pkg'/`pkg'.ado       "' _n
	file write `f' `"f `pkg'/`pkg'.sthlp       "' _n
	file write `f' `"e"' _n
	
	file close _all
	
	
	copy `fout' "`dir'/`pkg'.pkg", `replace'
	noi disp in y "/`pkg'.pkg created successfully."
	
	/*====================================================================
	2: Update stata.toc file
	====================================================================*/
	
	tempfile file1 file2 
	tempname in out
	
	
	copy "`dir'/stata.toc" "`dir'/_aux/stata_`datetime'.toc", replace 
	copy "`dir'/stata.toc" `file1', replace 
	
	file open `in' using `file1', read
	file open `out' using `file2', write append	
	
	file read `in' line
	file write `out' `"*! v 2           <`date'>"' _n // first line
	
	
	file read `in' line
	while r(eof)==0  {	// write file
		if regexm(`"`line'"', "^\*next") {
			file write `out' `"p `pkg'	(Ado)		<description of `pkg'>"' _n
		}
		file write `out' `"`line'"' _n
		file read `in' line
	} 	// end loop of write file
	file close _all
	
	copy `file2' "`dir'/stata.toc", replace
	
	noi disp in y "/stata.toc successfully updated"
	
	
	/*====================================================================
	3: create help file template
	====================================================================*/
	
	filefilter "`dir'/_aux/sthlp_template.sthlp" "`dir'/`pkg'/`pkg'.sthlp", ///
	from("sthlp_template") to("`pkg'") `replace'
	

}

end

exit 
