/*==================================================
project:       Create templates for dirstr pkgs
Author:        Andres Castaneda 
Dependencies:  The World Bank
----------------------------------------------------
Creation Date:    26 Nov 2018 - 11:18:09
Modification Date:   
Do-file version:    01
References:          
Output:             pkg and toc files
==================================================*/

/*==================================================
                        0: Program set up
==================================================*/
program define dirstr_pkg_template, rclass
syntax anything(name=file), [replace dir(string) update pkg(string) ]
version 15.0

qui {
/*==================================================
              1: pkg
==================================================*/

if ("`file'" == "pkg") {
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

/*==================================================
              2: Stata.toc
==================================================*/
if ("`file'" == "toc") {
	tempfile fout
	tempname f
	local date: disp %td date("`c(current_date)'", "DMY")
	local datetime: disp %tcDDmonthCCYY-HHMMSS clock("`c(current_date)'`c(current_time)'", "DMYhms")
	local datetime = trim("`datetime'")
	
	file open `f' using `fout', write append
	file write `f' `"*! v 2           < `date' >"' _n 
	file write `f' `"v 3"' _n 
	file write `f' `""' _n 
	file write `f' `"d Global Team of Statistical Development (GTSD) - Stats Toolkit"' _n 
	file write `f' `"d The objective of this toolkit is to facilitate and improve the quality of data management"' _n 
	file write `f' `"d and increase efficiency on the use of microdata at the Global level in the World Bank."' _n 
	file write `f' `"d "' _n 
	file write `f' `"d The GTSD has worked to improve the quality, frequency, and accessibility of surveys "' _n 
	file write `f' `"d and statistics, and to enhance the measurement of living conditions in the whole World. "' _n 
	file write `f' `"d "' _n 
	file write `f' `"d The GTSD builds on the integration of regional statistics work known as Data For Goals"' _n 
	file write `f' `"d (D4G) and it was created to continue, expand, and mainstream the work accomplished by"' _n 
	file write `f' `"d this program."' _n 
	file write `f' `"h"' _n 
	file write `f' `"*next"' _n  // never delete this line
	file write `f' `"h"' _n 
	file write `f' `"d "' _n 
	file write `f' `"e"' _n 
	
	file close _all
	
	copy `fout' "`dir'/stata.toc", `replace'
	noi disp in y "/stata.toc created successfully."
}

/*==================================================
           3:  Help file
==================================================*/

if ("`file'" == "sthlp") {
	tempfile fout
	tempname f
	local date: disp %tdDD_Mon_CCYY date("`c(current_date)'", "DMY")
	local datetime: disp %tcDDmonthCCYY-HHMMSS clock("`c(current_date)'`c(current_time)'", "DMYhms")
	local datetime = trim("`datetime'")
	
	file open `f' using `fout', write append
	file write `f' `"{smcl}"' _n 
	file write `f' `"{* *! version 1.0 `date'}{...}"' _n 
	file write `f' `"{vieweralsosee "" "--"}{...}"' _n 
	file write `f' `"{vieweralsosee "Install gtsd" "ssc install gtsd"}{...}"' _n 
	file write `f' `"{vieweralsosee "Help gtsd (if installed)" "help gtsd"}{...}"' _n 
	file write `f' `"{vieweralsosee "Install dirstr" "ssc install dirstr"}{...}"' _n 
	file write `f' `"{vieweralsosee "Help dirstr (if installed)" "help dirstr"}{...}"' _n 
	file write `f' `"{vieweralsosee "Install datalibweb" "ssc install datalibweb"}{...}"' _n 
	file write `f' `"{vieweralsosee "Help datalibweb (if installed)" "help datalibweb"}{...}"' _n 
	file write `f' `"{vieweralsosee "Install primus" "ssc install primus"}{...}"' _n 
	file write `f' `"{vieweralsosee "Help primus (if installed)" "help primus"}{...}"' _n 
	file write `f' `"{viewerjumpto "Syntax" "`pkg'##syntax"}{...}"' _n 
	file write `f' `"{viewerjumpto "Description" "`pkg'##description"}{...}"' _n 
	file write `f' `"{viewerjumpto "Options" "`pkg'##options"}{...}"' _n 
	file write `f' `"{viewerjumpto "Remarks" "`pkg'##remarks"}{...}"' _n 
	file write `f' `"{viewerjumpto "Examples" "`pkg'##examples"}{...}"' _n 
	file write `f' `"{title:Title}"' _n 
	file write `f' `"{phang}"' _n 
	file write `f' "{bf:`pkg'} {hline 2} <insert title here>" _n 
	file write `f' `""' _n 
	file write `f' `"{marker syntax}{...}"' _n 
	file write `f' `"{title:Syntax}"' _n 
	file write `f' `"{p 8 17 2}"' _n 
	file write `f' `"{cmdab:`pkg'}"' _n 
	file write `f' `"anything"' _n 
	file write `f' `"[{cmd:,}"' _n 
	file write `f' "{it:options}]" _n 
	file write `f' `""' _n 
	file write `f' `"{synoptset 20 tabbed}{...}"' _n 
	file write `f' `"{synopthdr}"' _n 
	file write `f' `"{synoptline}"' _n 
	file write `f' `"{syntab:Main}"' _n 
	file write `f' `"{synopt:{opt option1(string)}} .{p_end}"' _n 
	file write `f' `"{synopt:{opt option2(numlist)}} .{p_end}"' _n 
	file write `f' `"{synopt:{opt option3(varname)}} .{p_end}"' _n 
	file write `f' `"{synopt:{opt te:st}} .{p_end}"' _n 
	file write `f' `"{synoptline}"' _n 
	file write `f' `"{p2colreset}{...}"' _n 
	file write `f' `"{p 4 6 2}"' _n 
	file write `f' `""' _n 
	file write `f' `"{marker description}{...}"' _n 
	file write `f' `"{title:Description}"' _n 
	file write `f' `"{pstd}"' _n 
	file write `f' "{cmd:`pkg'} does ... <insert description>" _n 
	file write `f' `""' _n 
	file write `f' `"{marker options}{...}"' _n 
	file write `f' `"{title:Options}"' _n 
	file write `f' `"{dlgtab:Main}"' _n 
	file write `f' `"{phang}"' _n 
	file write `f' `"{opt option1(string)}"' _n 
	file write `f' `""' _n 
	file write `f' `"{phang}"' _n 
	file write `f' `"{opt option2(numlist)}"' _n 
	file write `f' `""' _n 
	file write `f' `"{phang}"' _n 
	file write `f' `"{opt option3(varname)}"' _n 
	file write `f' `""' _n 
	file write `f' `"{phang}"' _n 
	file write `f' `"{opt te:st}"' _n 
	file write `f' `""' _n 
	file write `f' `""' _n 
	file write `f' `"{marker examples}{...}"' _n 
	file write `f' `"{title:Examples}"' _n 
	file write `f' `""' _n 
	file write `f' "{phang} <insert example command>" _n 
	file write `f' `""' _n 
	file write `f' `"{title:Author}"' _n 
	file write `f' `"{p}"' _n 
	file write `f' `""' _n 
	file write `f' `"<insert name>, <insert institution>."' _n 
	file write `f' `""' _n 
	file write `f' `"Email {browse "mailto:firstname.givenname@domain":firstname.givenname@domain}"' _n 
	file write `f' `""' _n 
	file write `f' `"{title:See Also}"' _n 
	file write `f' `""' _n 
	file write `f' `"NOTE: this part of the help file is old style! delete if you don't like"' _n 
	file write `f' `""' _n 
	file write `f' `"Related commands:"' _n 
	file write `f' `""' _n 
	file write `f' "{help command1} (if installed)" _n 
	file write `f' "{help command2} (if installed)   {stata ssc install command2} (to install this command)" _n 
	file write `f' `""' _n 

	file close _all
	
	copy `fout' "`dir'/`pkg'/`pkg'.sthlp", `replace'
	noi disp in y "/`pkg'/`pkg'.sthlp created successfully."


}
} // end of qui


end
exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:


