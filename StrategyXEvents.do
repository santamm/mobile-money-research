preserve

clear all
macro drop _all
set linesize 255
use 1309_mm_data02.dta, clear

recode age(1 2 = 1 "18-29") (3 4 = 2 "30-39") (nonmissing =  3 "40+"), gen(age2)
label var age2 "Age"
tab age2

recode employment(1 3 6 = 1 "Formal") (2 4 7 = 2 "Informal") (nonmissing = 3 "Unemployed"), gen(employment2)
label var employment2 "Employment"
tab employment2


gen event_intentional = event_bank+event_insurance+event_stokvel+event_mobile_money+event_job+event_house+event_relationship
replace event_intentional=1 if event_intentional>1
tab event_intentional
gen event_unintentional=event_lotto+event_recession+event_food+event_petrol+event_children+event_loss+event_gift+event_none
replace event_unintentional=1 if event_unintentional>1
tab event_unintentional


local ivars "event_intentional event_unintentional"
local dsingle "strategy"
local dmulti ""

foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
		tabout `dvar' `ivar' using correlations/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N)
	}
} 

/*
// Graphs for single variables
foreach dvar of varlist `dsingle' {
	catplot `dvar' `ivar', recast(bar) percent ytitle("") blabel(bar, position(center) format(%3.0f))
	graph export "graphs/`dvar'.png", replace
}

// graphs for multiple response variables
//foreach dvar of local dmulti {
//	mrgraph hbar `dvar'_*, percent ytitle("") title("") blabel(bar, position(center) format(%3.0f))
//	graph export "graphs/`dvar'.png", replace
//}


*/



exit