/*
Project Name		: 	Basic STATA Literacy Course
						Stata for Data Processing and Data Management

Purpose				:	Day 7 Lecture

Author				:	Nicholus

Date				: 	07 08 2018

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
** Student # Assignment ** 

global		stud		99 // put your student sir # here

/*
participant name code
Myatn Thiri Khaing			1
Nant Thazin Min				2
Zin Nwe Win					3
Banyar AUNG					4
Su Sandar					5
Sai Nay Min Shein			6
Myat Wint Than				7
Saw Ghay Moo				8
Kyaw Swa Mya				9
Htet Ko Ko Aung				10
Sun Tun						11
Thein Zaw Oo				12
Than Zaw Oo    				13
Nicholus					99
*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

** Before reading this pre-reading dofile, you need to do following things

// (1) - save this dofile into "lecture_day_4" folder with "stud_do" inside shared dropbox folder and add your name in your own dofile.
// (2) - change directory path based on your PC folder arrangement in master dir dofile in test_do file "00_stata_basic_course_stud_master_dir_file.do"
// (3) - change your student sir number in local stud assignment

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

// change your dir to where master dir dofile exist

// Define your path here //
if "`c(os)'" == "MacOSX" {
global				do								/Users/nicholustintzaw/Dropbox/Basic_Stata_Course/stud_lab/test_do
}

else {
global				do								X:\Dropbox\Basic_Stata_Course\stud_lab\test_do
}

do "${do}/00_stata_basic_course_stud_master_dir_file.do"

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

**---------------------------------------------------------------------------------------**
** DATA CLEANING IN STATA **
**---------------------------------------------------------------------------------------**

clear
import delimited using "${test_master_raw}/coding_challenge_1/Stataliteracy - attendance sheet.csv", varnames(1) clear


// date time format
split timestamp, p(" GMT+6:30")

gen double submission_time = clock(timestamp1, "YMDhms")
format submission_time %tc
order submission_time timestamp*
sort submission_time

gen submission_date = dofc(submission_time)
format submission_date %td
drop timestamp1

lab var submission_date "Submission date"


** IDENTIFY MISSING VALUE IN DATASET **
count if mi(submission_time)
count if mi(timestamp)
count if mi(username)
count if mi(date)
count if mi(submission_date)

replace submission_time = . if username == "thazin.ntzm@gmail.com"
replace timestamp = ".m" if username == "thazin.ntzm@gmail.com"
replace date = ".m" if username == "thazin.ntzm@gmail.com"
replace submission_date = . if username == "thazin.ntzm@gmail.com"
replace submission_date = .m if username == "ghaymoo@hotmail.com"

// recheck 
count if mi(submission_time)
count if mi(timestamp)
count if mi(username)
count if mi(date)
count if mi(submission_date)

** LOOPING INTRO **
** HOW IT CAN SAVE US IN DEALING WITH HUGE DATASET **

// missing practices with looping

foreach var of varlist _all {
	count if mi(`var')
}
// see, how it save your time and coding work
// but are you still able to recognize which missing count value represent for which var?
// don't worry, just use below one.

foreach var of varlist _all {
	di "number of missing obs in variable : `var'"
	count if mi(`var')
}

clear

// COMBINATION OF LOOP FUNCTION AND MACROS data

// use another dataset for more practical work

import excel using "${test_master_raw}/assignment_2/assignment_2_question_set.xlsx", sheet("Data base_Test") firstrow clear

// make some data modification to see missing value in numeric var
bysort CampName: replace Sr = . if _n == _N
bysort Region: replace DOB = . if _n == _N
bysort CampName: replace DateofScreening = . if _n == _N

ds, has(type numeric)
foreach var in `r(varlist)' {
	di "number of missing obs in variable : `var'"
	count if mi(`var')
}


ds, has(type string)
foreach var in `r(varlist)' {
	di "number of missing obs in variable : `var'"
	count if mi(`var')
}

** DUPLICATES FUNCTION **
** IDENTIFICATION OF DUPLICATE OBS **

// use different dataset 
clear
use "${test_master_dta}/assignment_2/child_nutrition_childlevel_data_nicholus.dta", clear

help duplicates

duplicates report child_id // summary report on dup by selected var
duplicates list child_id // list duplicated obs by selected var

duplicates report camp_id
duplicates list camp_id

duplicates tag child_id, gen(id_dup) // generate new var to identify duplicated obs
tab id_dup, m

duplicates tag mom_name dad_name child_name, gen(person_dup)
tab person_dup, m

duplicates tag mom_name dad_name, gen(parent_dup)
tab parent_dup, m 


** IDENTIFICATION OF FLAG VALUE **
sum child_age_mnth, d
gen child_age_mnth_z = (child_age_mnth-`r(mean)')/`r(sd)'
gen child_age_mnth_flag = (child_age_mnth_z < -2)
tab child_age_mnth_flag, m

// applciation of looping function and scalars data

preserve
foreach var of varlist child_age_day child_muac {

	di "identification of flag value : `var'"
	sum `var', d
	gen `var'_z = (`var'-`r(mean)')/`r(sd)'
	gen `var'_flag = (`var'_z < -2)
	drop `var'_z
	tab `var'_flag, m

}
restore
// see what are the differences between above and below commands' results

foreach var of varlist child_age_day child_muac {

	di "identification of flag value : `var'"
	quietly sum `var', d
	gen `var'_z = (`var'-`r(mean)')/`r(sd)'
	gen `var'_flag = (`var'_z < -2)
	drop `var'_z
	tab `var'_flag, m

}


** REPLACE WITH CORRECTED VALUE FOR RESPECTIV VAR **

count if mi(child_muac) // count # of missing obs in MUAC var
br child_id child_muac if mi(child_muac)


preserve
count if mi(child_muac)
replace child_muac = 13 if child_id == "10015002951"
count if mi(child_muac)
restore

help readreplace
// use readreplace function to replace all missing value		

readreplace using "${test_master_raw}/assignment_2/lecture_day_7_correction_file.xlsx", ///
	    id("child_id") ///
		variable("variable") ///
		value("newvalue") ///
		excel ///
		import(firstrow) 
		

count if mi(child_muac) // noticed any changes?


br child_id child_sex if child_id == "20015008008" | child_id == "20015008028"




