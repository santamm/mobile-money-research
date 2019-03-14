preserve

clear all
macro drop _all
set linesize 255
use 1309_mm_data02.dta, clear

recode age(1 2 = 1 "18-29") (3 4 = 2 "30-39") (nonmissing =  3 "40+"), gen(age2)
label var age2 "Age"

recode employment(1 3 6 = 1 "Formal") (2 4 7 = 2 "Informal") (nonmissing = 3 "Unemployed"), gen(employment2)
label var employment2 "Employment"

recode approach (5 4 1 = 1 "Live day by day") (2 = 4 "I live for my family" ) (3 = 2 "I plan for the future") (6 = 3  "Stability and security is everything"), gen(new_approach)
label var new_approach "Approach to Life"

recode amount (1 2 3 = 1 "Small Savers <500/month") (4 5 = 2 "Big Savers >500/month") (98 = .), gen(savers)
label var savers "Savers"

//recode educ_year(0/8 = 0 "0-8") (9/11 = 9 "9-11"), gen(education)
//label var education "High School Grade Passed"
//label var education "Education (Grade Passed)"
//Grouped together Education and Tertiary
recode educ_year(0/8 = 0 "0-8") (9/11 = 9 "9-11") (12 = 12 "12") (15 = 15 "Tertiary"), gen(education)
label var education "Education Level"

replace education = 15 if educ_higher=="fet" | educ_higher=="tec" | educ_higher=="university" | educ_higher=="other"
tab education


recode situation (1 = 1 "Insufficient") (2 = 2 "Basic") (3 4 = 3 "Extra/Comfortable") (99 = .), gen(perceived_situation)
label var perceived_situation "Perceived Financial Situation"
tab perceived_situation

gen tertiary = 0 if educ_higher == "none"
replace tertiary = 1 if educ_higher == "fet" | educ_higher == "university" | educ_higher =="other" | educ_higher=="tech"


local ivars "employment2 spendvssave new_approach education amount savers month perceived_situation"
local dsingle "strategy"
local dmulti "event reason usage"


// Graphs for single variables

/*
foreach ivar of varlist `dsingle' {
	graph pie, over(`ivar') cw plabel(_all sum, size(small) orientation(horizontal) format(%3.0f)) title("Shock-coping Strategy") caption("Repondents: 423") subtitle("")
	graph export "graphs/`ivar'.png", replace

}
*/
 

foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
		tabout `dvar' `ivar' using tables/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N)
	}
//	foreach dvar of local dmulti {
//		tabout `dvar'_* `ivar' using tables/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N) 
//	}
} 




/*
foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
	catplot `dvar' `ivar', recast(bar) percent title ("`dvar' by `ivar'") ytitle("") blabel(bar, position(center) format(%3.0f))
	graph export "graphs/`dvar'X`ivar'.png", replace
	}
}
*/


/*
// graphs for multiple response variables
foreach dvar of local dmulti {
	mrgraph hbar `dvar'_*, percent ytitle("") title("") blabel(bar, position(center) format(%3.0f))
	graph export "graphs/`dvar'.png", replace
}

*/

// Example of combining reason_house and reason_extend 
//replace reason_house = 1 if reason_extend ==1 
//drop reason_extend



exit