preserve

clear all
macro drop _all
set linesize 255
use 1309_mm_data02.dta, clear

// Recoding variables
recode improve_trad (0 = 0 "Not Improved") (1 = 1  "Improved") (2 = 2 "Don't know"), gen(imp_trad)
recode improve_mm (0 = 0 "Not Improved") (1 = 1  "Improved") (2 = 2 "Don't know"), gen(imp_mm)

// Labels
label var result_assets "Sold assets"
label var result_cash "Used cash savings"
label var result_gifts "Received money from friends and relatives"
label var result_move "Moved somewhere else for work"
label var result_reduce "Reduced consumption of goods/services"
label var result_food "Bought less food"
label var result_grants "Received governmt grants"
label var result_local "Received a loan"
label var result_fees "Stopped paying school fees"
//label var result_business "Sold my business"
label var result_left "Left my family"
label var result_insure "Took up insurance"
label var result_save "Started saving every month"
label var result_stokvel "Joined a stokvel"
label var result_funeral "Took out a funeral plan"
label var result_bank "Opened a bank account"
//label var result_other "Other"
label var result_mm "Started using a Mobile Money Service"
//label var result_advice "Started having a financial advisor"
label var result_house "Stopped spending money on the house"
label var result_none "Did not do anything"


label var shock_death_hh "Death of a HH member"
label var shock_death_hhh "Death of a HH head"
label var shock_fights "Communal Fights"
label var shock_breakup "HH breakup"
label var shock_support "End of regular financial support"
label var shock_accident "Serious illness/accident"
label var shock_food "Steep rise of food prices"
label var shock_damaged "Dwelling damaged"
label var shock_unemployed "Loss of Employment"
label var shock_breakin "Break-in"

gen method_insurance = (method_life+method_household+method_car+method_cashback)
replace method_insurance=1 if method_insurance > 0 & method_insurance < .
tab method_insurance


label var imp_mm "Improvement from saving through MM"
label var imp_trad "Improvement from saving throuth other methods"
local savings_methods "method_insurance method_funeral method_stokvel method_cash method_bank"

gen impv_bank=0
replace impv_bank = 1 if improve_trad ==1 & method_bank ==1
replace impv_bank = -1 if improve_trad ==0 & method_bank ==1

tab impv_bank


gen impv_insurance=0
replace impv_insurance = 1 if improve_trad ==1 & method_insurance ==1
replace impv_insurance = -1 if improve_trad ==0 & method_insurance ==1
tab impv_insurance

gen impv_funeral=0
replace impv_funeral = 1 if improve_trad ==1 & method_funeral ==1
replace impv_funeral = -1 if improve_trad ==0 & method_funeral ==1
tab impv_funeral

gen impv_stokvel=0
replace impv_stokvel = 1 if improve_trad ==1 & method_stokvel ==1
replace impv_stokvel = -1 if improve_trad ==0 & method_stokvel ==1
tab impv_stokvel

gen impv_cash=0
replace impv_cash = 1 if improve_trad ==1 & method_cash ==1
replace impv_cash = -1 if improve_trad ==0 & method_cash ==1
tab impv_cash

gen impv_mm = imp_mm
tab impv_mm



local pvars "improve_mm improve_trad strategy"
local bvars "imp_mm imp_trad strategy"
local dmulti "event shock result impv"





// Graphs for single variables

// Pie graph for some single variables

/*
foreach ivar of varlist `pvars' {
	graph pie, over(`ivar') cw plabel(_all percent, size(small) orientation(horizontal) format(%3.1f)) title(`"`: var label `ivar''"') subtitle("")
	graph export "descriptive/events/`ivar'.png", replace
	//graph pie, over(`ivar') cw plabel(_all percent, color(white) size(small) orientation(vertical) format(%3.1f)) scheme(s2mono) title(`"`: var label `ivar''"') subtitle("")
	//graph export "descriptive/events/`ivar'_mono.png", replace 
}
*/




// title(`"`: var label `ivar''"')
/*
// Bar graphs
foreach ivar of varlist `bvars' {
tab `ivar'	
catplot `ivar', recast(bar) nopercent title(`: var label `ivar'') caption("Number of Observations: `r(N)'") b1title("") ytitle("") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/events/`ivar'_bar.png", replace
}
*/

/*

// graphs for multiple response variables

	mrgraph hbar event_*, sort descending nopercent ytitle("") title("Events that affected savings behavior in the last 12m") caption("Valid cases: 526") blabel(bar, position(outide) format(%3.0f))
	graph export "descriptive/events/events.png", replace

	mrgraph hbar shock_*, sort descending nopercent ytitle("") title("Shocks experienced in the last 12m") caption("Valid cases: 526") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/events/shocks.png", replace

	mrgraph hbar result_*, sort descending nopercent ytitle("") title("Shock Coping Behavior") caption("Valid cases: 526") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/events/shockcoping.png", replace
*/


exit