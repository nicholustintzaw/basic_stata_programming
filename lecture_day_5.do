/*
Project Name		: 	Basic STATA Literacy Course
						Stata for Data Processing and Data Management

Purpose				:	Day 5 Lecture

Author				:	Nicholus

Date				: 	07 01 2018

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


global				test_master_raw					/Volumes/Secomba/nicholustintzaw/Boxcryptor/Dropbox/Basic_Stata_Course/stud_lab/test_assignment
global				test_answer_dta					/Volumes/Secomba/nicholustintzaw/Boxcryptor/Dropbox/Basic_Stata_Course/stud_lab/test_dta
global				test_answer_raw					/Volumes/Secomba/nicholustintzaw/Boxcryptor/Dropbox/Basic_Stata_Course/stud_lab/test_assignment

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

**---------------------------------------------------------------------------------------**
** COMBINGING DATASET **
**---------------------------------------------------------------------------------------**

** (A): ONE TO ONE MERGING **

// Format Attendance Sing-up sheet data
import delimited using "${test_answer_raw}/coding_challenge_1/Stataliteracy - attendance sheet.csv", varnames(1) clear

bysort username: gen num_attendance_day = _N
 
bysort username: keep if _n == 1
drop timestamp
list username num_attendance_day


tempfile attendance
save `attendance', replace

clear

// Format TA Sing-up sheet data

import delimited using "${test_answer_raw}/coding_challenge_1/Extra TA times request from.csv", varnames(1) clear

bysort username: gen num_ta_day = _N
 
bysort username: keep if _n == 1
drop timestamp
list username num_ta_day

merge 1:1 username using `attendance', keepusing(num_attendance_day)

order username num_attendance_day num_ta_day
drop requestextrata

clear


** (B) APPENDING DATASET AND ONE OT MONEY MERGING
// REFERENCE: https://stats.idre.ucla.edu/stata/modules/combining-data/

// Dad dataset
input famid str4 dad_name inc
2 "Art" 22000
1 "Bill" 30000
3 "Paul" 25000
end

sort famid 
list

tempfile dads
save `dads', replace
clear

// Mom dataset
input famid str4 mom_name inc
1 "Bess" 15000
3 "Pat" 50000
2 "Amy" 18000
end

sort famid 
list

tempfile moms
save `moms', replace
clear

// Child dataset
input famid str4 kidname birth age wt str1 sex
1 "Beth" 1 9 60 "f"
2 "Andy" 1 8 40 "m"
3 "Pete" 1 6 20 "f"
1 "Bob" 2 6 80 "m"
1 "Barb" 3 3 50 "m"
2 "Al" 2 6 20 "f"
2 "Ann" 3 2 60 "m"
3 "Pam" 2 4 40 "f"
3 "Phil" 3 2 20 "m"
end

sort famid 
list 

tempfile children
save `children', replace 
clear

** (B.1) ONE TO ONE MERGING
use `dads', clear
merge 1:1 famid using `moms'
list 
tempfile dads_moms
drop _merge
save `dads_moms', replace
clear

** (B.2) ONE TO MONEY MERGING
use `dads_moms', clear
merge 1:m famid using `children'
drop _merge
list 
clear

** (B.3) MONEY TO ONE MERGING
use `children', clear
merge m:1 famid using `dads_moms'
drop _merge
list
tempfile children_complete_1
save `children_complete_1', replace
clear



input famid str5 dad_name inc str4 mom_name str5 kidname birth age wt str1 sex
6 "David" 39000 "Mary" "John" 3 3 50 "m"
7 "Jame" 22900 "Joe" "Lilly" 3 2 60 "f" 
end

sort famid 
list 

tempfile children_complete_2
save `children_complete_2', replace 
clear

** (B.4) APPEND DATASETS

use `children_complete_1', clear

append using `children_complete_2', gen(file_source)
list
