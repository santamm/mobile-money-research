preserve

clear all
macro drop _all
set linesize 255
use 1309_mm_data02.dta, clear

// Recoding variables
//recode approach (1 = 2 "Live day by day") (2 = 5 "I live for my family" ) (3 = 4 "I plan for the future") (4 = 3 "I live for myself") (5 = 1 "I live only for now") (6 = 6  "Stability and security is everything"), gen(ord_approach)
recode approach (5 4 1 = 1 "Live day by day") (2 = 4 "I live for my family" ) (3 = 2 "I plan for the future") (6 = 3  "Stability and security is everything"), gen(new_approach)

recode amount (1 2 3 = 1 "Small Savers <500/month") (4 5 = 2 "Big Savers >500/month") (98 = .), gen(savers)
label var savers "Savers"

gen cut_airtime = 1 if cut1==1 | cut2==1 | cut3==1
gen cut_alcohol = 1 if cut1==2 | cut2==2 | cut3==2
gen cut_cigarettes = 1 if cut1==3 | cut2==3 | cut3==3
gen cut_clothes = 1 if cut1==4 | cut2==4 | cut3==4
gen cut_food = 1 if cut1==5 | cut2==5 | cut3==5
gen cut_gambling = 1 if cut1==6 | cut2==6 | cut3==6
gen cut_junkfood = 1 if cut1==7 | cut2==7 | cut3==7
gen cut_lotto = 1 if cut1==8 | cut2==8 | cut3==8
gen cut_schoolfees = 1 if cut1==10 | cut2==10 | cut3==10 

label var cut_airtime "Airtime"
label var cut_alcohol "Alcohol"
label var cut_cigarettes "Cigarettes"
label var cut_clothes "Clothes"
label var cut_food "Food"
label var cut_gambling "Gambling"
label var cut_junkfood "Junkfood"
label var cut_lotto "Lotto"
label var cut_schoolfees "School Fees"


gen spare_account = 1 if spare1==1 | spare2==1 | spare3==1
gen spare_airtime = 1 if spare1==2 | spare2==2 | spare3==2
gen spare_clothes = 1 if spare1==3 | spare2==3 | spare3==3
gen spare_gambling = 1 if spare1==4 | spare2==4 | spare3==4
gen spare_gift= 1 if spare1==5 | spare2==5 | spare3==5
gen spare_groceries = 1 if spare1==6 | spare2==6 | spare3==6
gen spare_invest = 1 if spare1==7 | spare2==7 | spare3==7
gen spare_lotto = 1 if spare1==8 | spare2==8 | spare3==8
gen spare_treat = 1 if spare1==10 | spare2==10 | spare3==10


gen method_insurance = (method_life+method_household+method_car+method_cashback)
replace method_insurance=1 if method_insurance > 0 & method_insurance < .
tab method_insurance



label var spare_account "Money into account"
label var spare_airtime "Airtime"
label var spare_clothes "Clothes"
label var spare_gambling "Gambling"
label var spare_gift "Buy Gifts"
label var spare_groceries "Groceries"
label var spare_invest "Invest into business"
label var spare_lotto "Lotto"
label var spare_treat "Treat myself"



//label var ord_approach "Approach to Life"
label var new_approach "Approach to Life"
label var spare1 "Spare Money First Usage"
label var spare2 "Spare Money Second Usage"
label var spare3 "Spare Money Third Usage"
label var cut1 "First Expense to Cut"
label var cut2 "Second Expense to Cut"
label var cut3 "Third Expense to Cut"

label var spendvssave "Spending vs Saving"
label var amount "Monthly Savings Amount"

label var method_cash "Cash in a Safe Place"
label var method_bank "Bank Account"
label var method_funeral "Funeral Plan"

local pvars "ord_approach spendvssave"
local bvars "new approach spare1 spare2 spare3 cut1 cut2 cut3"
local pvars2 "amount"
local dmulti "reason method spending"
local savings_methods "method_insurance method_funeral method_stokvel method_cash method_bank"



// Graphs for single variables

/*
// Pie graph for some single variables

foreach ivar of varlist `pvars' {
	tab `ivar'
	graph pie, over(`ivar') cw plabel(_all sum, size(small) orientation(horizontal) format(%3.0f)) title(`"`: var label `ivar''"') caption("Number of Respondents: `r(N)'") subtitle("")
	graph export "descriptive/savingsbh_info/`ivar'.png", replace
//	graph pie, over(`ivar') cw plabel(_all percent, color(white) size(small) orientation(vertical) format(%3.1f)) scheme(s2mono) title(`"`: var label `ivar''"') subtitle("")
//	graph export "descriptive/savingsbh_info/`ivar'_mono.png", replace 
}
*/

/*

foreach ivar of varlist `pvars2' {
	graph pie, over(`ivar') cw plabel(_all sum, size(small) orientation(horizontal) format(%3.0f)) title(`"`: var label `ivar''"') caption("Repondents: 262") subtitle("")
	graph export "descriptive/savingsbh_info/`ivar'.png", replace
	catplot `ivar', recast(hbar) nopercent title(`"`: var label `ivar''"') caption("Respondents: 262") b1title("") ytitle("") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/savingsbh_info/`ivar'_b.png", replace
}

*/	

/*
// Bar graphs
foreach ivar of varlist `bvars' {
catplot `ivar', var1opts(sort(1) descending) recast(hbar) nopercent title(`"`: var label `ivar''"') caption("Observations: 528") b1title("") ytitle("") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/savingsbh_info/`ivar'_b.png", replace
}


*/



// graphs for multiple response variables
/*
	mrgraph hbar reason_*, sort descending percent ytitle("") title("Why do you regularly put money aside for?") caption("Valid Cases: 258" "Missing Cases: 270") blabel(bar, position(outide) format(%3.0f))
	graph export "descriptive/savingsbh_info/reason.png", replace

	mrgraph hbar method_*, sort descending percent ytitle("") title("Which method do you you to put money aside?") caption("Valid Cases: 259" "Missing Cases: 269") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/savingsbh_info/method.png", replace

	mrgraph hbar spending_*, sort descending percent ytitle("") title("What have you used your savings for in the last 12 months?") caption("Valid Cases: 239" "Missing Cases: 289") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/savingsbh_info/spending.png", replace

 	mrgraph hbar cut_*, sort descending percent ytitle("") title("Overall Expenses Cut") caption("Valid Cases: 527") blabel(bar, position(outide) format(%3.0f))
	graph export "descriptive/savingsbh_info/aggr_cut.png", replace

	mrgraph hbar spare_*, sort descending percent ytitle("") title("Overall Spare Money Usage") caption("Valid Cases: 527") blabel(bar, position(outide) format(%3.0f))
	graph export "descriptive/savingsbh_info/aggr_spare.png", replace

*/


// graphs of savings amount per savings method

foreach ivar of varlist `pvars2' {
	foreach mvar of varlist `savings_methods' {
	tab `mvar'	
	catplot `ivar' if `mvar'==1, recast(hbar) percent title("`: var label `ivar'' using `: var label `mvar''") caption("Respondents: `r(N)'") b1title("") ytitle("") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/savingsbh_info/`ivar'X`mvar'_b.png", replace
	}
}



exit