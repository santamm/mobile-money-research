// Correlations on Mobile Money account
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

gen cell_usage_mm = 0 if usage_money < .
label var cell_usage_mm "Mobile Money" 
replace cell_usage_mm = 1 if usage_money == 1 | usage_pay == 1


recode educ_year(0/8 = 0 "0-8") (9/11 = 9 "9-11") (12 = 12 "12") (15 = 15 "Tertiary"), gen(education)
label var education "Education Level"
//tab education


//generate higher = 0
replace education = 15 if educ_higher=="fet" | educ_higher=="tec" | educ_higher=="university" | educ_higher=="other"
tab education

recode improve_trad (0 = 0 "Not Improved") (1 = 1  "Improved") (2 = 2 "Don't know"), gen(imp_trad)
recode improve_mm (0 = 0 "Not Improved") (1 = 1  "Improved") (2 = 2 "Don't know"), gen(imp_mm)

label var imp_mm "Improvement from saving through MM"
label var imp_trad "Improvement from saving throuth other methods"


local ivars "employment2 gender education"
local dsingle "month improve_mm improve_trad"


foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
		tabout `dvar' `ivar' using correlations/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N)
	}
//	foreach dvar of local dmulti {
//		tabout `dvar'_* `ivar' using tables/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N) 
//	}
} 

ranksum month, by(gender)

// usage of mobile money by education
tabout cell_usage_mm education using correlations/usagemmXeducation.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N)




/*
// Graphs for single variables
foreach dvar of varlist `dsingle' {
	catplot `dvar' `ivar', recast(bar) percent ytitle("") blabel(bar, position(center) format(%3.0f))
	graph export "graphs/`dvar'.png", replace
}

// graphs for multiple response variables
foreach dvar of local dmulti {
	mrgraph hbar `dvar'_*, percent ytitle("") title("") blabel(bar, position(center) format(%3.0f))
	graph export "graphs/`dvar'.png", replace
}

*/




exit