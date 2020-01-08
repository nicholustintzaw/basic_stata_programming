/*
Project Name		: 	Basic STATA Literacy Course
						Stata for Data Processing and Data Management

Purpose				:	Day 2 lecture

Author				:	Nicholus

Date				: 	06 16 2018

Modified by			:

*/


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
** Settings for stata ** 
pause on						// allow pause function - but rarely use for me
clear all						// clear all existing memory data
clear mata						// mata clear clears Mata’s memory
set more off					// turn off more function
set scrollbufsize 100000		// make result window allow more scroll up


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

// note: in every cd commend, you need to change your PC's directory

** (1) Directories and folders **

// set dir. to Stata basic course dropbox sync folder
cd "/Users/nicholustintzaw/Dropbox/Basic_Stata_Course"
dir // list contents of directory or folder

cd "/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/stud_lab/test_answer/pre_test"
dir // now only show the excel files saved in pretest answer folder

p // display the current dir.

mkdir "/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/test_folder" //create a directory “Data” in the folder "C:\Users\SRA-MCCT\Dropbox\Basic_Stata_Course"


** (2) Open Stata data format dataset (.dta)

pwd // check your current directory 

cd "/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/stud_lab/test_dta/pre_test"
help use // check the command description 

use pre_test_answer_set_zinnweaung // open one dataset
clear

// Or

use "pre_test_answer_set_zinnweaung.dta", clear // use this or above commend to open .dta fromat dataset

clear


use http://www.stata-press.com/data/r15/auto // open dta from web

clear

** (3) Read data from CSV files (csv: Comma-separated values)

help insheet // check what insheet commend mean?

cd "/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/raw"
insheet using "Stataliteracy - attendance sheet.csv", clear

clear
insheet using "Stataliteracy - attendance sheet.csv", names clear

clear

help import delimited // check this command function description

import delimited using "Stataliteracy - attendance sheet.csv", clear

clear
import delimited using "Stataliteracy - attendance sheet.csv", varnames(1) clear

br // brow dataset


** (3) Read data from Excel files
clear

cd "/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/stud_lab/test_answer/pre_test"

import excel using "pre_test_answer_set_zinnweaung.xlsx", sheet("master") cellrange(A3:R956) firstrow clear
// check the variable name and variable label

clear

import excel using "pre_test_answer_set_zinnweaung.xlsx", sheet("master") cellrange(A3:R956) firstrow clear
// opps not open, let's try with below one

import excel using "pre_test_answer_set_zinnweaung.xlsx", sheet("Data base_Test") ///
cellrange(A3:R956) case(lower) firstrow clear
// yeah! it's working now. Why?

// and again, check variable name and variable lavel. What are the different between with previous excel sheet

clear

// check this one again!
cd "C:\Users\Admin\Dropbox\Basic_Stata_Course\raw\stud_profile"
import excel using "course_one_class_confirmation.xlsx", firstrow clear

clear


export excel using "C:\Users\xhute\Desktop\Stata\cencus.xlsx", firstrow (variables) replace
export excel using "C:\Users\xhute\Desktop\Stata\cencus.csv", firstrow (variables) replace

export delimited using "C:\Users\xhute\Desktop\Stata\cencus.csv", replace

/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

** ARE YOU HAPPY SO FAR CHANGING DIRECTORY EVERY TIME?

// in above examples, we use cd everytime we open/read data from different directory
// and it creat extra one coding line and not very effcient when you works whti data
// from more than one or two directory. So, is there any way to work SMARTER in stata?
// Of course, yes! You can apply local or global (Macros) function to solve it.
// below are some examples about it!

** (1) Let start with local first!
// assign directory using local function

local		pretest_raw		/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/stud_lab/test_answer/pre_test
local		pretest_dta		/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/stud_lab/test_dta/pre_test
//local		profile_raw		C:\Users\Admin\Dropbox\Basic_Stata_Course\raw\stud_profile


// open stata .dta file
use "`pretest_dta'/pre_test_answer_set_zinnweaung.dta", clear

clear

// read csv file
import delimited using "`profile_raw'/Stataliteracy - attendance sheet.csv", varnames(1) clear

clear

// read excel file
import excel using "`pretest_raw'/pre_test_answer_set_zinnweaung.xlsx", sheet("Data base_Test") cellrange(A3:R956) firstrow clear

clear

** (2) try with global path now!
// note: change your PC's directory below
global		pretest_raw		/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/stud_lab/test_answer/pre_test
global		pretest_dta		/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/stud_lab/test_dta/pre_test
//global		profile_raw		C:\Users\Admin\Dropbox\Basic_Stata_Course\raw\stud_profile


// open stata .dta file
use "${pretest_dta}/pre_test_answer_set_zinnweaung.dta", clear

clear

// read csv file
import delimited using "${profile_raw}/Stataliteracy - attendance sheet.csv", varnames(1) clear

clear

// read excel file
import excel using "${pretest_raw}/pre_test_answer_set_zinnweaung.xlsx", sheet("Data base_Test") cellrange(A3:R956) firstrow clear

clear


/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

** Save as stata dataset .dta format

// read excel file
import excel using "${pretest_raw}/pre_test_answer_set_zinnweaung.xlsx", sheet("Data base_Test") cellrange(A3:R956) firstrow clear

// save as .dta format
help save

save "${pretest_dta}/pre_test_answer_set_zinnweaung.dta" // check what worong with code

save "${pretest_dta}/pre_test_answer_set_zinnweaung.dta", replace

clear


// how about empty dataset?

save "${pretest_dta}/empty.dta", replace // not working, right?

// try below code
save "${pretest_dta}/empty.dta", emptyok // not working, right?

clear

