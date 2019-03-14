preserve

clear all
macro drop _all
set linesize 255
use 1309_mm_data02.dta, clear

// Recoding variables

recode service  (2 3 = 2 "Fnb ewallet") (4 = 4 "MPesa") (5 = 5 "MTN Mobile Money") (8 = 8 "Wizzit") (5 6 7 = 1 "Others"), gen(mm_service)
tab mm_service

recode employment(1 3 6 = 1 "Formal") (2 4 7 = 2 "Informal") (nonmissing = 3 "Unemployed"), gen(employment2)
label var employment2 "Employment"


recode age(1 2 = 1 "18-29") (3 4 = 2 "30-39") (nonmissing =  3 "40+"), gen(age2)
label var age2 "Age"

recode educ_year(0/8 = 0 "0-8") (9/11 = 9 "9-11") (12 = 12 "12") (15 = 15 "Tertiary"), gen(education)
label var education "Education Level"
replace education = 15 if educ_higher=="fet" | educ_higher=="tec" | educ_higher=="university" | educ_higher=="other"

generate higheduc = educ_higher
replace higheduc = "FET" if higheduc=="fet"
replace higheduc = "technikon" if higheduc=="tec"
replace higheduc = "Other" if higheduc=="other"
replace higheduc = "None" if higheduc=="none"
replace higheduc = "University" if higheduc=="university"
tab higheduc


label var age2 "Mobile Money User Age"
label var gender "Mobile Money User Gender"
label var marital "Mobile Money User Marital Status"
label var employment2 "Mobile Money User Employment Status"
label var higheduc "Mobile Money User Tertiary Education"


gen cell_usage_call = usage_receive
label var cell_usage_call "Call of Receive Calls"

gen cell_usage_airtime = usage_airtime
label var cell_usage_airtime "Buy and Receive Airtime"

gen cell_usage_internet = usage_internet
label var cell_usage_internet "Browse Internet"

gen cell_usage_msg = 0 if usage_sms < .
label var cell_usage_msg "Messagging"
replace cell_usage_msg = 1 if usage_sms == 1 | usage_whatsapp == 1 | usage_bbm == 1

gen cell_usage_mm = 0 if usage_money < .
label var cell_usage_mm "Mobile Money" 
replace cell_usage_mm = 1 if usage_money == 1 | usage_pay == 1
tab cell_usage_mm
exit

gen cell_usage_social:"Social Media" = 0 if usage_facebook < .
label var cell_usage_social "Social Media"
replace cell_usage_social = 1 if usage_facebook == 1 | usage_twitter == 1 | usage_mxit == 1




label var mm_service "Mobile Money Service Used"
label var freq_use "MM Usage Frequency"
label var freq_save "MM Savings Frequency"
label var more "MM Has Helped Save More Money"
label var month "Balance in the MM account at month end"
label var often "MM Has Helped Save More Often"
label var saved "MM Savings Increment"
label var best "Best MM Used Feature"

label var future "Planning to use MM in the Future"



local pvars "mm_service freq_use freq_save month more often saved best future"
local bvars "mm_service freq_use freq_save month more often saved best future"
local dmulti "heard feature no_use cell_usage"

local mm_ivars "age2 gender marital employment2"
local mm_bvars "education"


// Graphs for single variables

// Pie graph for some single variables

/*
foreach ivar of varlist `pvars' {
	tab `ivar'
	graph pie, over(`ivar') cw plabel(_all sum, size(small) orientation(horizontal) format(%3.0f)) title(`"`: var label `ivar''"') caption("Number of respondents: `r(N)'") subtitle("")
	graph export "descriptive/mobilemoney/`ivar'.png", replace
	// graph pie, over(`ivar') cw plabel(_all percent, color(white) size(small) orientation(vertical) format(%3.1f)) scheme(s2mono) title(`"`: var label `ivar''"') subtitle("")
	// graph export "descriptive/mobilemoney/`ivar'_mono.png", replace 
}

*/

/*
// Bar graphs
foreach ivar of varlist `bvars' {
	tab `ivar'
	catplot `ivar', recast(hbar) nopercent title (`"`: var label `ivar''"') ytitle("") caption("Number of respondents: `r(N)'") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/mobilemoney/`ivar'_bar.png", replace
}

*/

/*
// Mobile Money users Demographics

// Pie graph for some single variables
foreach ivar of varlist `mm_ivars' {
	tab `ivar' if cell_usage_mm==1
	graph pie if cell_usage_mm==1, over(`ivar') cw plabel(_all sum, size(small) orientation(vertical) format(%3.0f)) title(`"`: var label `ivar''"') caption("Number of Respondents: `r(N)'") subtitle("")
	graph export "descriptive/mobilemoney/`ivar'.png", replace
	
}
*/

foreach ivar of varlist `mm_bvars' {
	tab `ivar' if cell_usage_mm==1
	catplot `ivar' if cell_usage_mm==1, recast(bar) nopercent title (`"`: var label `ivar''"') ytitle("") caption("Number of Respondents: `r(N)'") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/mobilemoney/`ivar'.png", replace
}



/*

// graphs for multiple response variables

	mrtab cell_usage_*
	mrgraph hbar cell_usage_*, sort descending percent ytitle("") title("Cellphone Usage") caption("Valid cases: `r(N)' Missing cases: `r(N_miss)'") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/mobilemoney/cell_usage.png", replace
	

	mrtab heard_*
	mrgraph hbar heard_*, sort descending percent ytitle("") title("MM Awareness") caption("Valid cases: `r(N)' Missing cases: `r(N_miss)'") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/mobilemoney/heard.png", replace

	mrtab feature_*
	mrgraph hbar feature_*, sort descending percent ytitle("") title("Most Attractive MM Feature") caption("Valid cases: `r(N)' Missing cases: `r(N_miss)'") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/mobilemoney/feature.png", replace

	mrtab no_use_*
	mrgraph hbar no_use_*, sort descending percent ytitle("") title("MM not used because...") caption("Valid cases: `r(N)' Missing cases: `r(N_miss)'") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/mobilemoney/no_use.png", replace
*/

exit