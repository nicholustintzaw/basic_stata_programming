/*
Project Name		: 	Basic STATA Literacy Course
						Stata for Data Processing and Data Management

Purpose				:	Day 3 lecture

Author				:	Nicholus

Date				: 	06 16 2018

Modified by			:

*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

// log open
cd "/Volumes/Secomba/nicholustintzaw/Boxcryptor/Dropbox/Basic_Stata_Course/stud_lab/test_do"
log using "lecture_day_3/nicholus_day_3_log", replace text


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
** Settings for stata ** 
pause on						// allow pause function - but rarely use for me
clear all						// clear all existing memory data
clear mata						// mata clear clears Mata’s memory
set more off					// turn off more function
set scrollbufsize 100000		// make result window allow more scroll up


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

** Before reading this pre-reading dofile, you need to do following things

// (1) - save this dofile into "assignment_1" folder with "stud_do" inside shared dropbox folder and add your name in your own dofile.
// (2) - change directory path based on your PC folder arrangement


// set your directory here

global				test_master_raw					/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/stud_lab/test_assignment
global				test_answer_dta					/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/stud_lab/test_dta
global				do								/Volumes/Secomba/nicholustintzaw/Boxcryptor/Dropbox/Basic_Stata_Course/stud_lab/test_do

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

** (I): EXAMINING THE DATA **

help dta_examples

sysuse census


** (1) LIST **

list state region pop

list _all

list *

// Subsetting the data (if and in qualifiers)

list state region pop in 10/15

//list state region pop in -1/2

list state region pop if state == "Georgia"

/*
byte 	: integer between -127 and 100 e.g. dummy variable
int 	: integer between -32,767 and 32,740 e.g. year variable
long 	: integer between -2,147,483,647 and 2,147,483,620 e.g. population data 
float 	: real number with about 8 digits of accuracy e.g. production output data 
double 	: real number with about 16 digits of accuracy
*/



** (2) BROWS / EDIT **

brows

brows state region pop
brows state region pop in 10/15
brows state region pop if state == "Georgia"


// The difference with edit is that this allows you to manually change the dataset.
edit

edit state region pop
edit state region pop in 10/15
edit state region pop if state == "Georgia"


** (3) ASSERT **
// With large datasets, it often is impossible to check every single observation using list or browse. 
// Stata has a number of additional commands to examine data which are described in the following. 
// A first useful command is assert which verifies whether a certain statement is true or false. 
// For example, you might want to check whether all population (pop) values are positive as they should be:
// If the statement is true, assert does not yield any output on the screen. If it is false, number of contradictions.

assert pop>0
//assert pop<0


** (4) DESCRIBE **

help describe

describe
describe, short
describe, simple
describe, varlist

describe using "${test_answer_dta}/assignment_1/assignment_1_lynnthetsumon.dta"
describe using "${test_answer_dta}/assignment_1/assignment_1_lynnthetsumon.dta", short
describe using "${test_answer_dta}/assignment_1/assignment_1_lynnthetsumon.dta", varl



describe using "${test_answer_dta}/assignment_1/dataset1_khinthawdarshein.dta"
describe using "${test_answer_dta}/assignment_1/dataset1_khinthawdarshein.dta", short
describe using "${test_answer_dta}/assignment_1/dataset1_khinthawdarshein.dta", varl


** (5) CODEBOOK **

help codebook

codebook 
codebook state region pop

** (6) TABBULATE AND SUMMARIZE **

// tabulate
tab state
tab state, missing

tab state region
//tab state region pop

tab1 state region pop
tab1 state region pop, m

clear
use https://stats.idre.ucla.edu/stat/data/hsbdemo, clear

describe, varlist
codebook 

// 3 ways tab
//tab prog ses female, contents(freq)
table prog ses female, contents(freq)

tab1 prog ses female

// 4 ways tab
tab1 prog ses female honors

table prog ses female, by(honors) contents(freq)

// summarize
clear
sysuse census

help summarize

sum
sum pop, detail


** (II): SAVING THE DATA **

clear
use https://stats.idre.ucla.edu/stat/data/hsbdemo, clear

cd "/Volumes/Secomba/nicholustintzaw/Boxcryptor/Dropbox/Basic_Stata_Course/stud_lab/test_dta"
save "hsbdemo.dta", replace


// preserve & restore the dataset

preserve
clear
sysuse auto
describe, short
restore

clear

** (III) KEEPING TRACK OF THINGS ** 
// Do-files and log-files

help log

// let remove uncommand for log file from very bigining of dofile **


log close

// log test 

log using "${do}/lecture_day_3/nicholus_day_3_log.log", append

di"test"

log close

