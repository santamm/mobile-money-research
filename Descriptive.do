preserve

clear all
macro drop _all
set linesize 255
use 1309_mm_data02.dta, clear

// Recoding variables
recode age(1 2 = 1 "18-29") (3 4 = 2 "30-39") (nonmissing =  3 "40+"), gen(age2)
label var age2 "Age"
tab age2

recode employment(1 3 6 = 1 "Formal") (2 4 7 = 2 "Informal") (nonmissing = 3 "Unemployed"), gen(employment2)
label var employment2 "Employment"
tab employment2


// change labels for approach variables
label define approach 1 "I Live to survive day to day", modify
label define approach 2 "I live for my family", modify
label define approach 3 "I plan for the future", modify
label define approach 4 "I live for myself", modify
label define approach 5 "I live only for now", modify
label define approach 6 "Security and stability is everything", modify


gen method_insurance = (method_life+method_funeral+method_household+method_car+method_cashback)
replace method_insurance=1 if method_insurance > 0 & method_insurance < .




local ivars "gender age2 employment2 spendvssave approach educ_year"
local dsingle "approach"
//local dmulti "event reason usage spending"
local dmulti "event"

/*
foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
		tabout `dvar' `ivar' using "descriptive/tables/`dvar'X`ivar'.csv", stats(chi2) replace format (0p 0) cells(col freq) clab(% N)
	}

//	foreach dvar of local dmulti {
//		tabout `dvar'_* `ivar' using "descriptive/tables/`dvar'X`ivar'.csv", stats(chi2) replace format (0p 0) cells(col freq) clab(% N) 
//	}

*/

// Graphs for single variables
foreach ivar of varlist `ivars' {
	tab `ivar'
	graph pie, over(`ivar') cw plabel(_all sum, size(small) orientation(verticak) format(%3.1f)) title(`"`: var label `ivar''"') subtitle() caption("Number of Respondents: `r(N)'")
	graph export "descriptive/graphs/`ivar'.png", replace

}

/*


// Pie graph for some single variables
tab approach
graph pie, over(approach) cw plabel(_all sum, size(small) orientation(verticak) format(%3.1f)) title(Approach to Life) subtitle(What best describes your approach to life) caption("Number of Respondents: `r(N)'")
graph export "descriptive/graphs/approach.png", replace
//graph pie, over(approach) cw plabel(_all percent, color(white) size(small) orientation(vertical) format(%3.1f)) scheme(s2mono) title(Approach to Life) subtitle(What best describes your approach to life)
//graph export "descriptive/graphs/approach_mono.png", replace 


//foreach dvar of varlist `dsingle' {
//	catplot `dvar' `ivar', recast(bar) percent title("`dvar'") blabel(bar, position(outside) format(%3.2f))
//	graph export "descriptive/graphs/`dvar'.png", replace
//}


// graphs for multiple response variables
foreach dvar of local dmulti {
	mrgraph hbar `dvar'_*, percent ytitle("") title("Events that nnfluenced Savings Behavior in the last year") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/graphs/`dvar'.png", replace
}

*/

// Example of combining reason_house and reason_extend 
replace reason_house = 1 if reason_extend ==1 
drop reason_extend



exit