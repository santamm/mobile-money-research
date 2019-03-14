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

recode approach (5 4 1 = 1 "Live day by day") (2 = 4 "I live for my family" ) (3 = 2 "I plan for the future") (6 = 3  "Stability and security is everything"), gen(new_approach)
label var new_approach "Approach to Life"


recode educ_year(0/8 = 0 "0-8") (9/11 = 9 "9-11") (12 = 12 "12") (15 = 15 "Tertiary"), gen(education)
label var education "Education Level"

replace education = 15 if educ_higher=="fet" | educ_higher=="tec" | educ_higher=="university" | educ_higher=="other"
tab education


local ivars "employment2 spendvssave new_approach education"
local dsingle "security situation"
//local dmulti "event reason usage"

foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
		tabout `dvar' `ivar' using tables/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N)
		
	}
//	foreach dvar of local dmulti {
//		tabout `dvar'_* `ivar' using tables/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N) 
//	}
} 

ranksum situation, by(spendvssave)

ranksum security, by(spendvssave)





exit