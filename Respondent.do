preserve

clear all
macro drop _all
set linesize 255
use 1309_mm_data02.dta, clear

// Recoding variables
recode age(1 2 = 1 "18-29") (3 4 = 2 "30-39") (nonmissing =  3 "40+"), gen(age2)
label var age2 "Age"
tab age2

recode employment(1 3 6 = 1 "Formal") (2 4 7 = 2 "Informal") (nonmissing = 3 "Unemployed"), gen(employment2)
label var employment2 "Employment"
tab employment2

recode educ_year(0/8 = 0 "0-8") (9/11 = 9 "9-11") (12 = 12 "12") (15 = 15 "Tertiary"), gen(education)
label var education "Education Level"

//generate higher = 0
replace education = 15 if educ_higher=="fet" | educ_higher=="tec" | educ_higher=="university" | educ_higher=="other"
tab education


generate higheduc = educ_higher
replace higheduc = "FET" if higheduc=="fet"
replace higheduc = "technikon" if higheduc=="tec"
replace higheduc = "Other" if higheduc=="other"
replace higheduc = "None" if higheduc=="none"
replace higheduc = "University" if higheduc=="university"
tab higheduc




label var age2 "Respondent Age"
label var gender "Respondent Gender"
label var marital "Marital Status"
label var employment2 "Employment Status"
label var higheduc "Tertiary Education"

local ivars "age2 gender marital employment2"
local bvars "education higheduc"



// Graphs for single variables

/*
// Pie graph for some single variables
foreach ivar of varlist `ivars' {
	tab `ivar'
	graph pie, over(`ivar') cw plabel(_all sum, size(small) orientation(vertical) format(%3.0f)) title(`"`: var label `ivar''"') caption("Number of Respondents: `r(N)'") subtitle("")
	graph export "descriptive/respondent_info/`ivar'.png", replace
	//graph pie, over(`ivar') cw plabel(_all percent, color(white) size(small) orientation(vertical) format(%3.1f)) scheme(s2mono) title(`"`: var label `ivar''"') subtitle("") xsize(2) ysize(2)
	//graph export "descriptive/respondent_info/`ivar'_mono.png", replace 
}

*/

foreach ivar of varlist `bvars' {
	tab `ivar'
	catplot `ivar', recast(bar) nopercent title (`"`: var label `ivar''"') ytitle("") caption("Number of Respondents: `r(N)'") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/respondent_info/`ivar'.png", replace
}




exit