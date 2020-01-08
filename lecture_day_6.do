/*
Project Name		: 	Basic STATA Literacy Course
						Stata for Data Processing and Data Management

Purpose				:	Day 6 Lecture

Author				:	Nicholus

Date				: 	07 07 2018

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
global				do								C:\Users\DELL\Dropbox\Basic_Stata_Course\stud_lab\test_do
}

do "${do}/00_stata_basic_course_stud_master_dir_file.do"

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

**---------------------------------------------------------------------------------------**
** WORKING WITH DATE IN STATA **
**---------------------------------------------------------------------------------------**

// ref: https://stats.idre.ucla.edu/stata/modules/using-dates-in-stata/

// DATE / MDY OR ELS? 
input str4 name str11 bdate
"John"  "1 Jan 1960"
"Mary" "11 Jul 1955"
"Kate" "12 Nov 1962"
"Mark"  "8 Jun 1959" 
end

// apply split function in combine with "mdy" function
split bdate, p(" ")
replace bdate2 = "1" if bdate2 == "Jan"
replace bdate2 = "7" if bdate2 == "Jul"
replace bdate2 = "11" if bdate2 == "Nov"
replace bdate2 = "6" if bdate2 == "Jun"

destring bdate*, replace

//gen birthdate_2 = dmy(bdate1, bdate2, bdate3)

gen birthdate_2 = mdy(bdate2, bdate1, bdate3)
format birthdate_2 %td


// directly apply date function 
gen birthdate = date(bdate, "DMY")
format birthdate %td


// MORE EXERCISE ON DATE FUNCTION
clear
input str4 name str11 bdate
"John" "Jan 1 1960"
"Mary" "07/11/1955"
"Kate" "11.12.1962"
"Mark" "Jun/8 1959"
end

gen birthdate = date(bdate, "MDY")
format birthdate %td

clear
input str14 bdate
"Apr222000"
"Apr132010"
"Apr161990"
"Apr192020"
end

gen birthdate = date(bdate, "MDY")
format birthdate %td


// WORKING WITH CRAZY DATE FORMAT
// date function can work for all crazy date format as long as they are formated with
// proper delimiter for each date/month/year or written in stata date format with string value
clear
input str14 bdate
"4-12-1990"
"4.12.1990"
"Apr 12, 1990"
"Apr12,1990"
"April 12, 1990"
"4/12.1990"
"Apr121990"
"4121990"
"04121990"
"12199004"
"12041990"
"12-4-1990"
"4-1990-12"
"12-1990-4"
end

gen birthdate = date(bdate, "MDY")
format birthdate %td


// MDY FUNCTION
// Usage mdy function for the case with short from year value
clear
input month date year
 7 11 12
 1  1 13
10 15 16
12 10 17 
end

gen birthdate = mdy(month, date, year)
format birthdate %td

gen birthdate_1 = mdy(month, date, year + 1900)
format birthdate_1 %td

gen birthdate_2 = mdy(month, date, year + 2000)
format birthdate_2 %td

// REVERSE FUNCTION - DAY/MONTH/YEAR
// take individual month, date, year var from main date var
drop month date year

gen month = month(birthdate_2)
gen day = day(birthdate_2)
gen year = year(birthdate_2)



/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
/*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

// HOW STATA RECOGINZE DATE VALUE
// An elapsed date is the number of days from January 1, 1960

clear
input date 
0
1
365
-1
-2
3650
36500
end

gen birthdate = date
format birthdate %td  


clear
input month date year
 7 11 1948
 1 21 1952
11  2 1994
end

gen birthdate = mdy(month, date, year) // notice negative value. why?

format birthdate %td


// Practice on Extended date format
clear
import delimited using "${test_master_raw}/coding_challenge_1/Stataliteracy - attendance sheet.csv", varnames(1) clear


// date time format
split timestamp, p(" GMT+6:30")

gen double submission_time = clock(timestamp1, "YMDhms")
format submission_time %tc
order submission_time timestamp*
sort submission_time

gen subission_date = dofc(submission_time)
format subission_date %td
