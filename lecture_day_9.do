/*
Project Name		: 	Basic STATA Literacy Course
						Stata for Data Processing and Data Management

Purpose				:	Day 9 Lecture

Author				:	Nicholus

Date				: 	07 13 2018

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
** EXPORT DATA FROM STATA **
**---------------------------------------------------------------------------------------**

clear
use "${test_master_dta}/assignment_2/child_nutrition_childlevel_data_nicholus.dta", clear

// export summary statistic table
eststo clear 
estpost summarize child_sex_num child_age_mnth child_muac child_muac child_normal child_mam child_sam
esttab using "${test_answer_raw}/lecture_day_9/child_kpi_nicholus.csv", ///
cells("mean(fmt(a2)) sd(fmt(a2)) min max count") noobs nomtitle ///
addnotes(this is just a note) nonumber title(Section 2.2: Expenditures (Last 3 seasons)) replace label

// export logistic regression results
logit child_normal child_sex_num child_age_mnth, or
est store OR
outreg2 using "${test_answer_raw}/lecture_day_9/OR_result.xls" , ///
stats(coef ci) eform alpha(0.001, 0.01, 0.05) 

// export ttest result
orth_out child_age_day child_muac using "${test_answer_raw}/lecture_day_9/ttest_result.xls", ///
by(child_sex_num) replace sheet(ttest) pcompare count se stars

clear


*----------------------------------------------------------------------------------
** OTHER RESOURCE **
*----------------------------------------------------------------------------------

// https://libguides.library.nd.edu/stata/bnn



