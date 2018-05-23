/*====================================================================
project:       Folder structure of Global Team for Statistical Development
Author:        Andres Castaneda 
----------------------------------------------------------------------
Creation Date:    13 Apr 2018 - 12:58:37
====================================================================*/

/*====================================================================
0: Program set up
====================================================================*/


program define dirstr

syntax,              /// 
[                    ///
PROJects(string)      ///
NATure(string)       ///
VINTage(string)      ///
MAINdir(string)      ///
rootname(string)     ///
FORMATtime(string)   ///
ADOs(string)         ///
UPIs(string)         ///
]


*--------------- Conditions and initial parameter

if ("`projects'" == "" & "`ados'" == "" & "`upis'" == "") {
	noi disp as err "you must specify either project() or ados()"
	error
}

if ("`project'" != "" & "`nature'" == "") {
	noi disp as err "you must specify nature() if you want to create a new project"
	error
}

if !inlist("`nature'", "corporate", "continuous", "request", "") {
	noi disp as err "nature() must be {it:corporate|continuous|request}"
	error 
}

if ("`nature'" == "corporate" & "`vintage'" == "") {
	noi disp as err "you must specify vintage() if nature(corporate)"
	error 
}

if      ("`nature'" == "corporate")  {
	local suf "_corp" 
	local pre "03"
}

else if ("`nature'" == "continuous") {
	local suf "_cont" 
	local pre "04"
}
else { 
	local suf "_requ" 
	local pre "05"
}


if ("`vintage'" == "") {
	if ("`formattime'" == "")         local formattime "%tdDDmonCCYY"
	else if ("`formattime'" == "DMY") local formattime "%tdDDmonCCYY"
	else if ("`formattime'" == "MDY") local formattime "%tdmon-DD-CCYY"
	else if ("`formattime'" == "MY")  local formattime "%tdmonCCYY"
	else if ("`formattime'" == "Y")   local formattime "%tdCCYY"
	else confirm date format `formattime'
	
	local vintage: disp `formattime' date("`c(current_date)'", "DMY")
}

if ("`rootname'" == "") local rootname "GTSD"


if ("`maindir'" == "") {
	local maindir "\\wbgfscifs01\\`rootname'"
} 


if ("`upis'" == "") local upis "`c(username)'"
local upis = lower("`upis'")


* 0. Root level
cap mkdir "`maindir'"

   

*****************************************
* 1. First level
*****************************************
cap mkdir "`maindir'\_aux"
cap mkdir "`maindir'\_admin"
cap mkdir "`maindir'\01.personal"
cap mkdir "`maindir'\02.core_team"
cap mkdir "`maindir'\03.projects_corp"
cap mkdir "`maindir'\04.projects_cont"
cap mkdir "`maindir'\05.projects_requ"
cap mkdir "`maindir'\06.share"

*****************************************
* 2. Second level and third level
*****************************************
cap mkdir "`maindir'\01.personal\_handover"

* -------------personal
foreach upi of local upis {
	if !regexm("`upi'", "^wb") {
		noi disp as err "Each upi must start with wb " in y "(e.g., `c(username)')"
		}
	cap mkdir "`maindir'\01.personal\\`upi'"
}


* ------------- core_team
cap mkdir "`maindir'\02.core_team\_admin"
cap mkdir "`maindir'\02.core_team\01.programs"

local adofolder "`maindir'\02.core_team\01.programs\01.ado"
cap mkdir "`adofolder'"
cap mkdir "`adofolder'\_aux"

if ("`ados'" != "") {
	foreach ado of local ados {
		cap mkdir "`adofolder'\\`ado'"
		cap mkdir "`adofolder'\\`ado'\_vintage"
		dirstr_pkg `ado', dir("`adofolder'")
	} 
}


cap mkdir "`maindir'\02.core_team\01.programs\02.dofile"
cap mkdir "`maindir'\02.core_team\01.programs\03.R"
cap mkdir "`maindir'\02.core_team\01.programs\04.Python"
cap mkdir "`maindir'\02.core_team\01.programs\05.VB"
cap mkdir "`maindir'\02.core_team\01.programs\_vintage"

cap mkdir "`maindir'\02.core_team\02.data"
cap mkdir "`maindir'\02.core_team\02.data\_vintage"

cap mkdir "`maindir'\02.core_team\03.dashboard"
cap mkdir "`maindir'\02.core_team\03.dashboard\_vintage"

cap mkdir "`maindir'\02.core_team\04.writeups"
cap mkdir "`maindir'\02.core_team\04.writeups\_vintage"

cap mkdir "`maindir'\02.core_team\05.PPT"
cap mkdir "`maindir'\02.core_team\05.PPT\_vintage"



****************************
* ---- Projects
****************************

* Continuous Nature
if ("`projects'" != "") {
	local pf = 0  // prefix
	foreach project of local projects {
		
		local projfolder ""
		
		local projdirs: dir "`maindir'\\`pre'.projects`suf'" dirs "*"
		local founddir ""
		
		if (`"`projdirs'"' != "") {
			local pd = 0     // directory-found flag
			local seqs "0"   // sequence starts in zero
			
			foreach projdir of local projdirs {
				
				if (regexm(`"`projdir'"', "([0-9]+)\.([ a-zA-Z0-9_\-]+)")) {
					local seq   = regexs(1)
					local pname = regexs(2)
					local seqs "`seqs' `seq'"
				}
				else continue  // this should never happen
				
				if (lower("`pname'") == lower("`project'")) {
					local pd = 1
					local founddir   "`projdir'"
					local projfolder "`maindir'\\`pre'.projects`suf'\\`founddir'"
					continue, break 
				}
			}
			
			if (`pd' == 0) {
				local seqs = trim("`seqs'")
				local seqs: subinstr local seqs " " ", ", all
				local mseq = max(`seqs') + 1
				if (length("`mseq'") == 1) local pf "0`mseq'"
			}
		}
		else {   // in case no folder exists 
			local ++pf
			if (length("`pf'") == 1) local pf "0`pf'"
		}
		
		if ("`projfolder'" == "") {
			local founddir "`pf'.`project'"
			local projfolder "`maindir'\\`pre'.projects`suf'\\`founddir'"
		}
		
		cap mkdir "`projfolder'"   // create project folder 
		
		*-------- Corporate nature
		if (inlist("`nature'", "corporate", "request")) {
			local vintfolder "`projfolder'\\`founddir'_`vintage'"
			cap mkdir "`vintfolder'"
			
			local qafolder "`vintfolder'\\`founddir'_`vintage'_QA"
			
			cap mkdir "`qafolder'"
			
			cap mkdir "`qafolder'\_old"
			cap mkdir "`qafolder'\_temp"
			cap mkdir "`qafolder'\_aux"
			cap mkdir "`qafolder'\01.programs"
			cap mkdir "`qafolder'\01.programs\01.ado"
			cap mkdir "`qafolder'\01.programs\02.dofile"
			cap mkdir "`qafolder'\01.programs\03.R"
			cap mkdir "`qafolder'\01.programs\04.Python"
			cap mkdir "`qafolder'\01.programs\05.VB"	
			cap mkdir "`qafolder'\02.input"	
			cap mkdir "`qafolder'\03.output"
			cap mkdir "`qafolder'\03.output\01.data"
			cap mkdir "`qafolder'\03.output\02.dashboard"
			cap mkdir "`qafolder'\03.output\03.presentations"
			cap mkdir "`qafolder'\03.output\04.writeups"	
			cap mkdir "`qafolder'\04.references"
			cap mkdir "`qafolder'\05.tools"	
			
			cap mkdir "`vintfolder'\\`founddir'_`vintage'_Production"	
		}  // end of Corporate or request projects
		
		*-------- Continuous nature
		if ("`nature'" == "continuous") {	
			cap mkdir "`projfolder'\\`founddir'_QA"
			cap mkdir "`projfolder'\\`founddir'_QA\_old"
			cap mkdir "`projfolder'\\`founddir'_QA\_temp"
			cap mkdir "`projfolder'\\`founddir'_QA\_aux"
			
			cap mkdir "`projfolder'\\`founddir'_QA\01.programs"
			cap mkdir "`projfolder'\\`founddir'_QA\01.programs\01.ado"
			cap mkdir "`projfolder'\\`founddir'_QA\01.programs\02.dofile"
			cap mkdir "`projfolder'\\`founddir'_QA\01.programs\03.R"
			cap mkdir "`projfolder'\\`founddir'_QA\01.programs\04.Python"
			cap mkdir "`projfolder'\\`founddir'_QA\01.programs\05.VB"
			
			cap mkdir "`projfolder'\\`founddir'_QA\02.input"
			
			cap mkdir "`projfolder'\\`founddir'_QA\03.output"
			cap mkdir "`projfolder'\\`founddir'_QA\03.output\01.data"
			cap mkdir "`projfolder'\\`founddir'_QA\03.output\02.dashboard"
			cap mkdir "`projfolder'\\`founddir'_QA\03.output\03.PPT"
			cap mkdir "`projfolder'\\`founddir'_QA\03.output\04.writeups"
			
			cap mkdir "`projfolder'\\`founddir'_QA\04.references"
			cap mkdir "`projfolder'\\`founddir'_QA\05.tools"
			
			cap mkdir "`projfolder'\\`founddir'_Production"
			
			cap mkdir "`projfolder'\\`founddir'_Production\\`founddir'_`vintage'"	
			
		} // end of continuous projects. 
	} // end projects loop
} // end projects != ""





end 




exit
/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

adopath ++ "z:\wb384996\Andres\temporal\GTSD\02.core_team\01.programs\01.ado\dirstr\"


dirstr, project(projections) nature(request) format(MY)
dirstr, project(PEB) nature(corporate) vintage(AM18)
dirstr, project(MPO) nature(corporate) vintage(AM18)
dirstr, project(PEB MPO) nature(corporate) vintage(AM18)

dirstr, project(datalibweb) nature(continuous)
dirstr, project(PRIMUS) nature(continuous)
dirstr, ados(datalibweb groupfunction lineup peb qcheck indicators)
dirstr, ados(lineup peb)
dirstr, ados(gtsd)
dirstr, ados(dirstr)
dirstr, upis(wb255520 wb327173 wb252482 wb378870 wb175777 wb384996 wb236343 wb502818)

"z:\wb384996\Andres\temporal" "GTSD_1"
