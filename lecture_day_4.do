/*
Project Name		: 	Basic STATA Literacy Course
						Stata for Data Processing and Data Management

Purpose				:	Day 4 Lecture

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
// change your dir

global				test_master_raw					C:\Users\TNang\Dropbox\Basic_Stata_Course\stud_lab\test_assignment\pre_test
global				test_answer_dta					C:\Users\TNang\Dropbox\Basic_Stata_Course\stud_lab\test_dta\pre_test


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

** Before reading this pre-reading dofile, you need to do following things

// (1) - save this dofile into "lecture_day_4" folder with "stud_do" inside shared dropbox folder and add your name in your own dofile.
// (2) - change directory path based on your PC folder arrangement in master dir dofile in test_do file "00_stata_basic_course_stud_master_dir_file.do"
// (3) - change your student sir number in local stud assignment

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

** (1) Use pre-test excel raw data and transform stata dataset **

// (A. 1) import excel file
import excel using "${test_master_raw}/pre_test_question_set.xlsx", sheet("Data base_Test") firstrow cellrange(A3:R956) clear
&&&
// (A. 2) rename the variable 
rename Sr 								child_srnum
rename DateofScreening					date_screen
rename Region 							geo_region
rename CampName							camp_name
rename CampID 							camp_id
rename MotherName						mom_name
rename FatherName 						dad_name
rename ChildName						child_name
rename Sex								child_sex
rename DOB								child_dob
rename ChildIDmustbeuniqueRegion 		child_id
rename AgeDays							child_age_day	
rename AgeMonth							child_age_mnth
rename MUAC								child_muac
rename ReasonofAbsent					child_abs_reason
rename R								child_sam
rename Y								child_mam
rename G								child_normal


// (A. 3) generate unique id
// assing camp id
tostring camp_id, replace

replace camp_id = "5001" if camp_name == "A"
replace camp_id = "5002" if camp_name == "B"
replace camp_id = "5003" if camp_name == "C"
replace camp_id = "5004" if camp_name == "D"
replace camp_id = "5005" if camp_name == "E"
replace camp_id = "5006" if camp_name == "F"
replace camp_id = "5007" if camp_name == "G"
replace camp_id = "5008" if camp_name == "H"
replace camp_id = "5009" if camp_name == "I"

// modify child serial number
tostring child_srnum, replace

gen child_srnum_mod = child_srnum
replace child_srnum_mod = "00" + child_srnum if length(child_srnum) == 1
replace child_srnum_mod = "0" + child_srnum if length(child_srnum) == 2
order child_srnum_mod, after(child_srnum)

// assign unique id - normal
tostring geo_region camp_id child_id, replace

replace child_id = geo_region + camp_id + child_srnum_mod
isid child_id

destring /*child_id*/ child_srnum, replace

/*
// assign unique id - good practices
gen child_id_good = ""
replace child_id_good = geo_region + camp_id + child_srnum_mod
lab var child_id_good "Child ID - good practice"
isid child_id_good

order child_id_good, after(child_id)
destring camp_id, replace

order child_id child_id_good, after(camp_id)
*/
// (A. 4) Child Age Calculation

// format date variables
format date_screen child_dob %td

drop child_age_day child_age_mnth

gen child_age_day = (date_screen - child_dob)

gen double child_age_mnth = round(child_age_day/30.4,0.1)


lab var child_age_day "Child age in Days"
lab var child_age_mnth "Child age in Months"


// Recode chil age var as group var
recode child_age_mnth	(0/5.99 = 1 "0-5")(6/8.99 = 2 "6-8")(9/11.99 = 3 "9-11")(12/17.99 = 4 "12-17") ///
						(18/23.99 = 5 "18-23")(24/35.99 = 6 "24-35")(36/47.99 = 7 "36-47") ///
						(48/59.99 = 8 "48-59")(nonmiss = 999), gen(child_age_grp) 

lab var child_age_grp "Child Age months in group"
order child_age*, after(child_dob)

// (A. 5) Identified malnutrition children

drop child_sam child_mam child_normal

gen child_sam = (child_muac < 11.5)
gen child_mam = (child_muac >= 11.5 & child_muac < 12.5)
gen child_normal = (child_muac >= 12.5)

lab def yesno 1"Yes" 0"No"
lab val child_sam child_mam child_normal yesno

 save "${test_answer_dta}\pre_test_answer_tnangsengpan.dta", replace


** OTHER CODE PRACTICES **

// endcode or decode - group string var

encode camp_name, gen(camp_code)
tab camp_code,m
tab camp_code,m nolab

decode camp_code, gen(camp_name_decode)
tab camp_name_decode, m

decode camp_id, gen(camp_name_test) // why not working?

order camp_code camp_name_decode, after(camp_id)

encode child_sex, gen(child_gender)
tab child_gender,m
tab child_gender,m nolab

drop child_gender

gen child_gender = (child_sex == "M" | child_sex == "M " | child_sex == "m")
lab def child_gender 1"Male" 0"Female" // why it is not working?

lab def child_sex 1"Male" 0"Female"
lab val child_gender child_sex
tab child_gender, m

decode child_gender, gen(child_sex_decode) // note: this is also working in the num var with proper lableing

order child_gender, before(child_dob)


// Mvdecode and mvencode
gen test_var = .

mvdecode test_var, mv(-999)

gen test_var_str = "."
gen test_var2 = .

mvencode _all, mv(-999)
mvdecode _all, mv(-999 = .m )


// keep and drop

keep if child_normal == 1
tab child_normal, m nolab


drop if child_sam == 1
tab child_sam, m nolab

drop child_normal

keep child_sam


clear

use "${test_answer_dta}/pre_test/pre_test_answer_nicholus.dta", clear

preserve
// keep and drop

keep if child_normal == 1
tab child_normal, m nolab


drop if child_sam == 1
tab child_sam, m nolab

drop child_normal
describe, simple

keep child_sam
describe, simple

restore

// Note for logical and Relationship Operator

/*
The different relational operators are:
	== 		equal to
	!= 		not equal to
	> 		greater than
	>= 		greater than or equal to < less than
	<= 		less than or equal to
*/

/*
Note, the different logical operators are:
	& 		and 
	| 		or 
	~ 		not 
	! 		not
*/


// Sorting dataset


// sort - Ascending sort

destring geo_region child_id_good, replace
format child_id_good %11.0f

sort geo_region 

sort geo_region camp_id 

order geo_region camp_id child_id_good child_dob

sort geo_region camp_id child_id_good child_dob

// gsort - Ascending and descending sort

gsort - geo_region 
gsort - camp_id 
gsort - camp_id 

gsort + camp_id 


// bysort
 
tab child_num_camp, m

// bysort and egen

bysort camp_id : egen mam_child_camp = total(child_mam)
tab mam_child_camp, m

preserve
bysort camp_id: keep if _n == 1
tab mam_child_camp, m
restore

clear
