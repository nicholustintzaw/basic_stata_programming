/*
Project Name		: 	Basic STATA Literacy Course
						Stata for Data Processing and Data Management

Purpose				:	Day 8 Lecture

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
global				do								/Users/banyaraung/Dropbox/Basic_Stata_Course/stud_lab/test_do
}

else {
global				do								X:\Dropbox\Basic_Stata_Course\stud_lab\test_do
}

do "${do}/00_stata_basic_course_stud_master_dir_file.do"

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

**---------------------------------------------------------------------------------------**
** RESHAPE DATASET IN STATA **
**---------------------------------------------------------------------------------------**

// reference: https://stats.idre.ucla.edu/stata/modules

**--------------------------**
** RESHAPE WIDE TO LONG **
**--------------------------**

/*
The general syntax of reshape long can be expressed as…

reshape long stem-of-wide-vars, i(wide-id-var)  j(var-for-suffix)

where
stem-of-wide-vars  is the stem of the wide variables, e.g., faminc
wide-id-var        is the variable that uniquely identifies wide 
                   observations, e.g., famid
var-for-suffix     is the variable that will contain the suffix of 
                   the wide variables, e.g., year 
*/

clear
use https://stats.idre.ucla.edu/stat/stata/modules/faminc, clear 

help reshape
list

/*
Lets reshape this data into a long format. The critical questions are:
Q: What is the stem of the variable going from wide to long.
A: The stem is faminc
Q: What variable uniquely identifies an observation when it is in the wide form.
A: famid uniquely identify the wide observations.
Q: What do we want to call the variable which contains the suffix of faminc, i.e., 96 and 97.
A: Lets call the suffix year.
*/

reshape long faminc, i(famid) j(year)  
list

reshape wide faminc, i(famid) j(year)  
list

clear


use https://stats.idre.ucla.edu/stat/stata/modules/kidshtwt, clear 

list *

/*
Lets reshape this data into a long format. The critical questions are:
Q: What is the stem of the variable going from wide to long.
A: The stem is ht wt
Q: What variable uniquely identifies an observation when it is in the wide form.
A: famid and birth together uniquely identify the wide observations.
Q: What do we want to call the variable which contains the suffix of ht & wt, i.e., 1 and 2.
A: Lets call the suffix age.
*/

reshape long ht wt, i(famid birth) j(age)  
list *

clear

use https://stats.idre.ucla.edu/stat/stata/modules/dadmomw, clear 
list 

/*
Lets reshape this data into a long format. The critical questions are:
Q: What is the stem of the variable going from wide to long.
A: The stem is incd incm named namem
Q: What variable uniquely identifies an observation when it is in the wide form.
A: famid uniquely identify the wide observations.
Q: What do we want to call the variable which contains the suffix of inc name, i.e., d and m.
A: Lets call the suffix dadmom.
*/


reshape long name inc , i(famid) j(dadmom) string
list

clear


**--------------------------**
** RESHAPE LONG TO WIDE **
**--------------------------**

/*
The general syntax of reshape wide can be expressed as:

reshape wide long-var(s),  i( wide-id-var ) j( var-with-suffix ) 

where
long-var(s)      is the name of the long variable(s) to be made wide e.g. age
wide-id-var      is the variable that uniquely identifies wide 
                 observations, e.g. famid
var-with-suffix  is the variable from the long file that contains 
                 the suffix for the wide variables, e.g. birth
*/


use https://stats.idre.ucla.edu/stat/stata/modules/kids, clear 
list 

reshape wide kidname age wt sex, i(famid) j(birth)
br

/*
wide tells reshape that we want to go from long to wide
birth tells Stata that the variable to be converted from long to wide is kidname age wt sex
i(famid) tells reshape that famid uniquely identifies observations in the wide form
j(birth) tells reshape that the suffix of age (1 2 3) should be taken from the variable birth
*/

**------------------------------------**
** EXAMPLE WITH REAL WORLD DATASET **
**------------------------------------**

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

gen attendance = 1

drop submission_time timestamp date
reshape wide attendance, i(username) j(submission_date)

//reshape wide submission_date, i(username) j(attendance)

reshape long attendance, i(username) j(submission_date)

clear


// use more complex dataset  dataset 
clear
use "${test_master_dta}/assignment_2/child_nutrition_childlevel_data_nicholus.dta", clear

count if mom_name == ".m"
drop mom_name // include missing value and not appropriate to use in example. in real life, should include this var in assing family id

drop child_srnum

bysort geo_region camp_id dad_name: gen child_tot_family = _N
tab child_tot_family, m

bysort geo_region camp_id dad_name: gen child_srnum = _n
tab child_srnum, m

bysort geo_region camp_id (dad_name): gen family_sir = _n
bysort geo_region camp_id dad_name: replace family_sir = family_sir[1] if _n > 1
tab family_sir,m

order family_sir child_srnum, after(dad_name)

foreach var of varlist child_srnum family_sir {
	tostring `var', replace
	gen `var'_mod = `var'
	replace `var'_mod = "00" + `var' if length(`var') == 1
	replace `var'_mod = "0" + `var' if length(`var') == 2
	tab `var'_mod,m
	order `var'_mod, after(`var')
	drop `var'
	rename `var'_mod `var'
}

tostring camp_id, replace
gen family_id = geo_region + camp_id + family_sir
tab family_id, m


order family_id, after(family_sir)
destring family_id, replace
format family_id %11.0f
sort family_id

order 			child_id date_screen geo_region camp_name camp_id ///
				dad_name family_sir child_tot_family child_name child_sex child_sex_num ///
				child_dob child_age_day child_age_mnth child_muac child_normal ///
				child_mam child_sam family_id child_srnum
				
reshape wide 	child_id /*date_screen geo_region camp_name camp_id*/ ///
				/*dad_name family_sir child_tot_family*/ child_name child_sex child_sex_num ///
				child_dob child_age_day child_age_mnth child_muac child_normal ///
				child_mam child_sam, i(family_id) j(child_srnum) string


order date_screen geo_region camp_name camp_id dad_name family_sir child_tot_family

export excel "${test_answer_raw}/lecture_day_8/child_level_data_wide_nicholus.xlsx", firstrow(variable) replace


reshape long 	child_id /*date_screen geo_region camp_name camp_id*/ ///
				/*dad_name family_sir child_tot_family*/ child_name child_sex child_sex_num ///
				child_dob child_age_day child_age_mnth child_muac child_normal ///
				child_mam child_sam, i(family_id) j(child_srnum) string


**---------------------------------------------------------------------------------------**
** EXPORT DATA FROM STATA **
**---------------------------------------------------------------------------------------**

clear
use "${test_master_dta}/assignment_2/child_nutrition_childlevel_data_nicholus.dta", clear


tab child_normal, matcell(cellcounts)
mat list cellcounts
local normal_no = cellcounts[1,1]
local normal_yes = cellcounts[2,1]
local normal_tot = `normal_no' + `normal_yes'

putexcel set "${test_answer_raw}/lecture_day_8/child_kpi_nicholus.xlsx", sheet("monitoring_kpi")replace
putexcel A1 = ("Key Performance Indicators") 
putexcel A2 = ("Description") 		B2 = ("Total No. of Children")	C2 = ("No")				D2 = ("Yes")				
putexcel A3	= ("Normal Children") 	B3 = ("`normal_tot'")			C3 = ("`normal_no'")	D3 = ("`normal_yes'")		

foreach var of varlist child_sam child_mam {
	
	tab `var', matcell(cellcounts)
	local `var'_no 		= 	cellcounts[1,1]
	local `var'_yes 	= 	cellcounts[2,1]
	local `var'_tot		= 	``var'_yes' + ``var'_no'
}

putexcel A4	= ("SAM Children") 	B4 = ("`child_sam_tot'")			C4 = ("`child_sam_no'")	D4 = ("`child_sam_yes'")		
putexcel A5	= ("MAM Children") 	B5 = ("`child_mam_tot'")			C5 = ("`child_mam_no'")	D5 = ("`child_mam_yes'")	


	
