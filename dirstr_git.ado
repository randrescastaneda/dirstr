/*====================================================================
project:       Crete git bare repository
Author:        Andres Castaneda 
----------------------------------------------------------------------
Creation Date:    29may2018
====================================================================*/

/*====================================================================
0: Program set up
====================================================================*/

program define dirstr_git
syntax anything(name=pkg), [replace dir(string) pause ]


local dir:   subinstr local dir "\" "/", all
local path   "`dir'/`pkg'"
local path2: subinstr local dir "/" "\", all

if ("`pause'" == "pause") local pause "& pause"

mata: st_local("direx", strofreal(direxists("`path'.git")))

if ("`direx'" != "1"){
	shell git init "`path'"                       /* 
	*/ & git clone --bare -l "`path'" "`path'.git" /* 
	*/ & attrib +s +h "`path2'.git" `pause'
}

mata: st_local("direx", strofreal(direxists("`path'.git")))
if ("`direx'" != "1"){
	noi disp in err "folder `pkg'.git not created. use {cmd:pause} option to check for " ///
	_n "problem in the cmd window."
}
else {
	noi disp in y "folder `pkg'.git created successfully but not shown because it is " ///
	_n `"super hidden. you may type {cmd:shell attrib -s -h "`path'.git"} "'  ///
	_n "to unhide it"
}

end 

exit 

/* End of do-file */

><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

local pkg test
local path "//wbgfscifs01/gtsd/01.personal/wb384996/`pkg'"



*/ & git remote rm shared /*
*/ & git remote add shared "`path'.git" & pause
*/ & git commit -m 'initial commit' "`path'/readme.txt" /*
*/ & copy NUL "`path'/readme.txt" /*
*/ & git add . "`path'" & pause /*


