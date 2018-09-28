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
syntax anything(name=pkg), [replace dir(string) update]

qui {
	
	/*====================================================================
	1: create pkg file
	====================================================================*/
	cap confirm file "`dir'/`pkg'.pkg"
	if (_rc) {
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
	}
	else {
		noi disp in y "/`pkg'.pkg already exists"
	}
	
	 
	*=======================================================
	*--------------- Update Package -------------------------
	*=======================================================
	
	if ("`update'" == "update") {
		* local dir "\\wbgfscifs01\GTSD\02.core_team\01.programs\01.ado"
		* local pkg "indicators"
		
		local date: disp %td date("`c(current_date)'", "DMY")
		local ados: dir "`dir'/`pkg'" files "*.ado"
		local help: dir "`dir'/`pkg'" files "*.sthlp"
		local files = `"`ados' `help'"' 
		foreach file of local files {
			disp "`file'"
		}
		
		* Within the subfolders
		local subfs: dir "`dir'/`pkg'" dirs "*"
		foreach subf of local subfs {
			local ados: dir "`dir'/`pkg'/`subf'" files "*.ado"
			local help: dir "`dir'/`pkg'/`subf'" files "*.sthlp"
			
			foreach ado of local ados {
				local files = `"`files' `subf'/`ado'"' 
			}
			
			foreach h of local help {
				local files = `"`files' `subf'/`h'"' 
			}
		}  // end of subfolders loop
		
		tempfile file1 file2 
		tempname in out
		
		copy "`dir'/`pkg'.pkg" "`dir'/_aux/`pkg'_`datetime'.pkg", replace 
		copy "`dir'/`pkg'.pkg" `file1', replace 
		
		file open `in' using `file1', read
		file open `out' using `file2', write append	
		
		local newend = 0
		file read `in' line
		while (r(eof)==0 & `newend' != 1)  {	// write file
			if regexm(`"`line'"', "^d Distribution") {
				file write `out' `"d Distribution-Date: `date'"' _n
				file read `in' line
			}
			else if regexm(`"`line'"', "^f ") {
				foreach file of local files {
					file write `out' `"f `pkg'/`file'"' _n
				}
				file write `out' `"e"' _n
				local newend = 1
			}
			else {
				file write `out' `"`line'"' _n
				file read `in' line
			}
		} 	// end loop of write file
		file close _all
		
		copy `file2' "`dir'/`pkg'.pkg", replace
		noi disp in y "/`pkg'.pkg successfully updated"
		exit
	}
	
	/*====================================================================
	2: Update stata.toc file
	====================================================================*/
	tempfile toca
	filefilter "`dir'/stata.toc" `toca', from("p `pkg'") to("ZZZZ")
	local occurrences = r(occurrences)
	if (`occurrences' == 0) {
		
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
	}
	else {	
		noi disp in y "/stata.toc already includes a p `pkg' line"
	}
	
	
	/*====================================================================
	3: create help file template
	====================================================================*/
	
	cap confirm file "`dir'/`pkg'/`pkg'.sthlp" 
	if (_rc) {
		filefilter "`dir'/_aux/sthlp_template.sthlp" "`dir'/`pkg'/`pkg'.sthlp", ///
		from("sthlp_template") to("`pkg'") `replace'
	}
	
	
}

end

exit 

/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

local pkg test
local path "//wbgfscifs01/gtsd/01.personal/wb384996/`pkg'"

shell git init "`path'"                       /* 
*/ & git clone --bare -l "`path'" "`path'.git"     


*/ & git remote rm shared /*
*/ & git remote add shared "`path'.git" & pause
*/ & git commit -m 'initial commit' "`path'/readme.txt" /*
*/ & copy NUL "`path'/readme.txt" /*
*/ & git add . "`path'" & pause /*


