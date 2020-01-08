/*
Project Name		: 	Basic STATA Literacy Course
						Stata for Data Processing and Data Management

Purpose				:	Day 3 pre-reading

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

** Before reading this pre-reading dofile, you need to do following things

// (1) - save this dofile into "assignment_1" folder with "stud_do" inside shared dropbox folder and add your name in your own dofile.
// (2) - change directory path based on your PC folder arrangement


// set your directory here

global				pretest_question_raw			/Volumes/Secomba/nicholustintzaw/Boxcryptor/Dropbox/Basic_Stata_Course/stud_lab/test_assignment
global				pretest_answer_dta				/Volumes/Secomba/nicholustintzaw/Boxcryptor/Dropbox/Basic_Stata_Course/stud_lab/test_dta

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
/*
** digest the following commend

help generate
help rename
help replace
help label
help recode
help egen // if not find it pls install egenmore by following command

ssc install egenmore, replace

help order
help sort

help distinct // if not find it use below command to install this function

ssc install distinct

help codebook
help describe
*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

** Assignment - 1 **
clear
** Step (1) : open excel data file named "dataset1" from "assignment_1 filder

** Step (2) : rename variable in proper short name (apply small leter only)

** Step (3) : assign numeric value to the "gender" and "nut allergey" variables
// gender - male = 1 , femlae = 0
// nut allergy - yes = 1, no = 0 

** Step (4) save as stata dataset in "assignment_1" folder within "test_dta" folder


import delimited using "${pretest_question_raw}/assignment_1/dataset1.csv", varname (1) clear

clear

import excel using "${pretest_question_raw}/assignment_1/dataset1.xls", sheet("dataset1") cellrange(a1:h11) firstrow case (l) clear
