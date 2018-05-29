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
syntax anything(name=pkg), [replace dir(string) ]

local dir: subinstr local dir "\" "/", all
local path "`dir'/`pkg'"


mata: st_local("direx", strofreal(direxists("`path'.git")))

if ("`direx'" != "1"){
	shell git init "`path'"                       /* 
	*/ & git clone --bare -l "`path'" "`path'.git"
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


