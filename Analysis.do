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


local ivars "gender age2 employment2 spendvssave approach educ_year"
local dsingle "security situation spendvssave strategy"
local dmulti "event reason usage"

foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
		tabout `dvar' `ivar' using tables/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N)
	}
	foreach dvar of local dmulti {
		tabout `dvar'_* `ivar' using tables/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N) 
	}
} 

// Graphs for single variables
foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
	catplot `dvar' `ivar', recast(bar) percent title ("`dvar' by `ivar'") ytitle("") blabel(bar, position(center) format(%3.0f))
	graph export "graphs/`dvar'X`ivar'.png", replace
	}
}


// graphs for multiple response variables
foreach dvar of local dmulti {
	mrgraph hbar `dvar'_*, percent ytitle("") title("") blabel(bar, position(center) format(%3.0f))
	graph export "graphs/`dvar'.png", replace
}



// Example of combining reason_house and reason_extend 
replace reason_house = 1 if reason_extend ==1 
drop reason_extend



exit