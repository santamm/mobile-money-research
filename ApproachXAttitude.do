preserve

clear all
macro drop _all
set linesize 255
use 1309_mm_data02.dta, clear

recode age(1 2 = 1 "18-29") (3 4 = 2 "30-39") (nonmissing =  3 "40+"), gen(age2)
label var age2 "Age"
tab age2

// Recoding variables
recode approach (5 4 1 = 1 "Live day by day") (2 = 4 "I live for my family" ) (3 = 2 "I plan for the future") (6 = 3  "Stability and security is everything"), gen(new_approach)
label var new_approach "Approach to Life"

label var spendvssave "Spending vs Saving"






local ivars "spendvssave"
local dsingle "new_approach approach"

foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
		tabout `dvar' `ivar' using correlations/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N)
	}
}

ranksum new_approach, by(spendvssave)





exit