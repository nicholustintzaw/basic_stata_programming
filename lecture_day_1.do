/*
Project Name		: 	Basic STATA Literacy Course
						Stata for Data Processing and Data Management

Purpose				:	Day 1 lecture

Author				:	Nicholus

Date				: 	06 01 2018

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

sysdir // on which directory your stata build in

*dir // check the document locate in working dir

*help dta_examples // stata system buildin dataset

** Data in STATA **

sysuse auto // open stata buildin dataset named "auto" 
// (A) Vaiable 
codebook make  // string
return list
codebook mpg foreign gear_ratio // numeric

// scalars
sum rep78
return list

// matrices 
mean rep78
return list // stored general command results
ereturn list // stored est. command results
mat a = r(table) // ??
mat li a 

// Macros
local interested_var foreign // 1) what is usefulness of Local command? 2) interested var is assigned variable name which you would like to recall 
tab `interested_var' // ` " is key point to give attention. 

global v1 rep78  // 1) what is usefulness of global command? 2) v1 is assigned variable name which you would like to recall 
tab $v1 // $ is symbol of global function

clear

