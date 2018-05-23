{smcl}
{* *! version 1.0 22 May 2018}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "Install datalibweb" "dirstr install datalibweb"}{...}
{vieweralsosee "Help datalibweb (if installed)" "help datalibweb"}{...}
{viewerjumpto "Syntax" "dirstr##syntax"}{...}
{viewerjumpto "Description" "dirstr##description"}{...}
{viewerjumpto "Options" "dirstr##options"}{...}
{viewerjumpto "Remarks" "dirstr##remarks"}{...}
{viewerjumpto "Examples" "dirstr##examples"}{...}
{title:Title}
{phang}
{bf:dirstr} {hline 2} Create directories in GTSD folder structure. {p_end}
{phang}
{bf:Note}:{err: help file in progress}

{marker syntax}{...}
{title:Syntax}
{p 8 17 2}
{cmdab:dirstr}
{it:[instruction]}
[{cmd:,}
{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}
{synopt:{opt proj:ects(string)}} Name of the project folder to create. Requires {it:nature()}{p_end}
{synopt:{opt nat:ure(string)}} Nature of the project ({it:corporate|continuous|request}). No default. Required with {it:project()} .{p_end}
{synopt:{opt vint:age(string)}} Vintage format. See below for explanation{p_end}
{synopt:{opt format:time(string)}} Used instead of {it:vintage}. default {it:%tdDDmonCCYY}{p_end}
{synopt:{opt ado:s(string)}} Name of the ado-file folder to be included. Creates pkg and modifies stata.toc{p_end}
{synopt:{opt upi:s(string)}} UPI of core team member. Default user's own UPI. {p_end}

{syntab:Advanced}
{synopt:{opt main:dir(string)}} Change main directory. Seldom used  or Used for testing{p_end}
{synopt:{opt rootname(string)}} Name of master folder. Seldom used  or Used for testing. Default is GTSD{p_end}
{synoptline}
{p2colreset}{...}
{p 4 6 2}

{marker description}{...}
{title:description}
{pstd}
{cmd:dirstr} create directories in folder structure of the Global Team for Statistical Development.
The folder structure is composed of six main folders within the 
{browse "\\wbgfscifs01\GTSD": master directory} of the team:{p_end}

{p 10 2}.\01.personal{p_end}
{p 10 2}.\02.core_team{p_end}
{p 10 2}.\03.projects_corp{p_end}
{p 10 2}.\04.projects_cont{p_end}
{p 10 2}.\05.projects_requ{p_end}
{p 10 2}.\06.share{p_end}
 
{pstd}
Folder {bf:.\01.personal} contains personal folders for each of the members of the
{ul:core team}. it must be named with the prefix "wb" and the corresponding UPI number
of each member of the team. {it: see option upi() for more details}

{pstd}
Folder {bf:.\02.core_team} contains all the files that are shared among the members of the team
and, more importantly, that are used for different projects. That is, the information
of one file within this folder might be used for more than one project. In this folder
you may find dta files, presentation, do-files, and the ado-files that the {it:beta}
version of the ado-files used and created by the team. 

{pstd}
THere are three different folder for projects, depending on the nature of the project. 
Each project-nature folder ({bf:.\0X.projects_nnnn}) contains one directory for each 
project that belongs to such nature. The folder strucutre of the each project directory
will vary depending on the nature the project belongs to.{it: see more details below}

{pstd}
The last folder ({bf:.\04.share}) has not been defined yet. 


{marker options}{...}
{title:Options}
{dlgtab:Main}
{phang}
{opt proj:ects(string)} Refers to the name of the project. It is recommended not
using spaces in the name. {cmd:dirstr} assigns automatically the corresponding number
to the name of the project. Regardless of the nature of the project, each project folder
will contain the structure shown below. The nature of the project will determine at which
level such tree structure is placed and how the vintage control is assigned. Let's assume
that the project name is {it:test} and the corresponding number is 02. Thus, the 
sub-folder structure would be, 

{p 12 4}02.test_QA{p_end}
{p 16 4}_aux{p_end}
{p 16 4}_old{p_end}
{p 16 4}_temp{p_end}
{p 16 4}01.programs{p_end}
{p 20 4}...{it:typs of scripts, do, R, ado...}{p_end}
{p 16 4}02.input{p_end}
{p 16 4}03.output{p_end}
{p 20 4}01.data{p_end}
{p 20 4}02.dashboard{p_end}
{p 20 4}03.PPT{p_end}
{p 20 4}04.writeups{p_end}
{p 16 4}04.references{p_end}
{p 16 4}05.tools{p_end}
{p 12 4}02.test_Production{p_end}
{p 16 4}02.test_22may2018 (...{it:only for continuous}){p_end}

{phang2}
The suffix _QA stands for 'Quality Assurance.' Thus, this folder plays the role of 
the working folder of the project. In it, the users will develop the tools and test them. 
Once the project has reached a point in which its products are released, the relevant information
is copied into the _production folder. This folder contains everything that has been 
released, produced, or published within the scope of the project. Thus, it is required
to use vintages conventions for naming folders within the _production folder. 

{phang}
{opt nat:ure(string)} refers to the nature of the project defined above. Three options
are available: {it:corporate}, {it:request} or {it:continuous}.

{phang2}
{bf:corporate} refers to projects whose product is part of a corporate mandate and  
 have a well-defined frequency (e.g., PEB or MPO). For that reason, option {it:vintage}
 is mandatory with this nature. The {it:corporate} nature includes and additional layer
 of sub-folders right after the folder of the project. This additional layer of 
 sub-folders corresponds to the different vintages of the project and within them
 the sub-folder structure mentioned above will be placed. 

{phang2}
{bf:request} refers to projects that were suddenly requested by the management team or
that are part of a collaboration. These projects do not have a well-defined frequency of
recurrence, so the vintage control is managed by date formating. In essence, these projects
hold the same structure as the corporate projects and only differ from them on the name
of the vintage sub-folders. By default {cmd:dirstr} uses the date format  %tdDDmonCCYY
to create the name of the folder. However, the user can specify any format she wants, 
as long as it is a valid Windows file name, or use one of the predefined date formats. 
{it: see formattime() below}.

{phang2}
 {bf:continuous} refers to on-going projects that demand constant revision and release
 of new versions. Continuous projects don't have a layer of vintage sub-folder 
 in contrast to corporate or request projects. Instead, the vintage control of continuous
 projects is held on the {it:_production} sub-folder of the folder structure above.
 As in the case of request project, the continuous projects use date formating for vintage
 control. {it: see formattime() below}.
 
{phang}
{opt vint:age(string)} is used mandatory for the naming convention of {it:corporate} 
projects, or as an option for {it:request} and {it:continuous} projects. In short, whatever
the user places in {it:vintage()}, will be considered part of the name of vintage control. 
It is recommended to keep the same convention throughout the same project, but it is not 
necessary to be the same across projects. For instance, if the vintage convention for the
corporate product PEB is {it:'AM18'}, where {it:AM} refers to Annual Meetings and {it:18}
to 2018, the folder structure will look like this, 

{p 12 4}02.PEB{p_end}
{p 16 4}02.PEB_AM18{p_end}
{p 18 4}02.PEB_AM18_QA{p_end}
{p 22 4}01.programs{p_end}
{p 22 4}02.input{p_end}
{p 22 4}03.output{p_end}
{p 22 4}04.references{p_end}
{p 22 4}05.tools{p_end}
{p 18 4}02.PEB_AM18_Production{p_end}
{p 16 4}02.PEB_SM18{p_end}
{p 18 4}...{p_end}

{phang}
{opt format:time(string)} date/time format to be used in vintage naming convention.
Instead of {it:vintage()}, {it:formattime} receives any format accepted in Windows as
part of a valid file name. By default the {it:formattime} takes the value %tdDDmonCCYY. However, the user may take advantage of the following shortcuts

		Shortcut{col 35}equivalent date format
		{hline 45}
		{cmd:DMY}{col 35}%tdDDmonCCYY
		{cmd:MDY}{col 35}%tdmon-DD-CCYY
		{cmd:MY }{col 35}%tdmonCCYY
		{cmd:Y  }{col 35}%tdCCYY
		{hline 45}
		
{phang}
{opt ado:s(string)} Creates a folder for the ado-file to be shared. The folder is placed 
in ".\02.core_team\01.programs\01.ado", which the folder of the GTSD user site. when a new
ado-file folder is created, {cmd:dirstr} modifies the stata.toc file, which works as a 
front end to interact with the user, by including an additional line to download the corresponding
files to the ado-file to be created. This new line in stata.toc is generic and has to be 
modified by the user to make it clearer to the rest of the team. Also, {cmd:dirstr} creates
an yyy.pkg file, where yyy refers to the name of the ado-file to be created. Again, this 
yyy.pkg file is generic and has to be modified by the user, but all the important sections are
depicted to fill in. The most important part of the .pkg file is the bottom of the file in which 
the user specifies the files attached to the main command filename. see 
{it:{help usersite:user site}} to understand how it works. 

{phang}
{opt upi:s(string)} used for adding personal sub-folders to the personal folder. Use the 
"wb" prefix in each upi number (e.g., wb222333)

{phang}
{opt main:dir(string)} refers to a directory path in which the folder structure is
going to be placed. use for testing purposes.

{phang}
{opt rootname(string)} Name of the master folder that will contain the folder strucutre. 
Default is GTSD. 


{marker examples}{...}
{title:Examples}

{dlgtab:download latest version of dirstr}

{phang2}
{stata gtsd install dirstr, replace):gtsd install dirstr, replace}

{dlgtab:Create one corporate project}

{phang2}
{stata dirstr, project(PEB) nature(corporate) vintage(AM18): dirstr, project(PEB) nature(corporate) vintage(AM18)}{p_end}

{phang2}
{stata dirstr, project(MPO) nature(corporate) vintage(AM18): dirstr, project(MPO) nature(corporate) vintage(AM18)}{p_end}

{phang}
Notice that corporate projects require option vintage()

{dlgtab:Create two continuous projects}

{phang2}
{stata dirstr, project(datalibweb PRIMUS) nature(continuous):dirstr, project(datalibweb PRIMUS) nature(continuous)}

{phang}
When nature is continuous, there is no need to specify vintage type. By default, {cmd:distr}
will use %tdDDmonCCYY date formating. 

{dlgtab:Create one Request Project}

{phang2}
{stata dirstr, project(projections) nature(request) format(MY):dirstr, project(projections) nature(request) format(MY)}

{phang}
In this case, the vintage formating of the projections folder follows the date format 
'MY', which corresponds to %tdmonCCYY

{dlgtab:Create ado-files foders}

{phang2}
{stata dirstr, ados(datalibweb):dirstr, ados(datalibweb)} // one ado-file

{phang2}
{stata dirstr, ados(groupfunction lineup peb qcheck indicators):dirstr, ados(groupfunction lineup peb qcheck indicators)} // several ado-file at the same time

{phang}
This will create a folder and a .pkg file for each ado-file and it will modify the 
stata.toc file by including a link for the ado-file. The user, however, must add the 
descriptions of the ado-file to both the .pkg file and the stata.toc file. 

{dlgtab:Create personal folders}

{phang2}
.dirstr, upis(wb777777 wb789543) // NOT Run 

{phang}
Creates personal folders for wb777777 and wb789543. Do not run the code above, for the 
UPI numbers above are fake. 

{dlgtab:test dirstr}

{phang2}
.dirstr, project(projections) nature(request) format(MY) ///{p_end}
{phang3}
maindir("z:\wb384996\Andres\temporal") rootname("GTSD_1")

{phang}
created folder structure in the directory path specified above within the folder GTSD_1.


{title:Acknowledgements}

    {p 4 4 2}This program was developed by the {browse "" : Global Team for Statistical Development}, 
		from the Poverty Global Practice in the World Bank.{p_end} 
    {p 4 4 2}Comments and suggestions are most welcomed.{p_end} 
	
{title:Authors}

    {p 4 4 2}Frodo Baggins{p_end}

{title:Also see other Stata program from the Global Team from Statistical Development}

{psee}
Online:  {help dataliweb} (if installed)
{p_end}

