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

recode children(0 =0) (1 = 1) (2 = 2) (3 = 3) (4 = 4) (5 = 5) (nonmissing = 6 "6+"), gen(childs)
label var childs "Number of Children in the Household"
tab childs

label var roof "Type of Roof"
label var wall "Type of Wall"
label var electricity "Electricity"
label var water "Water Connection"



local dsingle "employment2"
local ivars "roof wall"

foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
		tabout `dvar' `ivar' using correlations/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N)
	}
}

//ranksum new_approach, by(spendvssave)





exit