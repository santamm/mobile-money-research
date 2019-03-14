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

recode educ_year(0/8 = 0 "0-8") (9/11 = 9 "9-11") (12 = 12 "12") (15 = 15 "Tertiary"), gen(education)
label var education "Education Level"

replace education = 15 if educ_higher=="fet" | educ_higher=="tec" | educ_higher=="university" | educ_higher=="other"
tab education


fre amount
replace amount = . if amount == 98

// Small Savers vs Big Savers
recode amount (1 2 3 = 1 "Small Savers <500/month") (4 5 = 2 "Big Savers >500/month") (98 = .), gen(savers)
label var savers "Savers"

label var method_cash "Cash in a Safe Place"
label var method_bank "Bank Account"
label var method_funeral "Funeral Plan"

gen method_insurance = method_car + method_life + method_cashback + method_household
replace method_insurance=1 if method_insurance==2 | method_insurance==3 | method_insurance==4
label var method_insurance "Insurance"

gen method_mm = method_ewallet + method_mtn
replace method_mm =1 if method_mm==2
label var method_mm "Mobile Money"


local ivars "employment2 gender education"
local mvars ""
local dsingle "amount"
local savings_methods "method_insurance method_funeral method_stokvel method_cash method_bank method_mm"

foreach ivar of varlist `ivars' {
	foreach dvar of varlist `dsingle' {
		tabout `dvar' `ivar' using correlations/`dvar'X`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N)
	}
}

ranksum amount, by(gender)

foreach ivar of varlist `savings_methods' {
	
		tabout savers `ivar' using correlations/SaversX`ivar'.csv, stats(chi2) replace format (0p 0) cells(col freq) clab(% N)
	
}



exit