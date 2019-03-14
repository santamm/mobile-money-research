preserve

clear all
macro drop _all
set linesize 255
use 1309_mm_data02.dta, clear

// Recoding variables
recode children(0 =0) (1 = 1) (2 = 2) (3 = 3) (4 = 4) (5 = 5) (nonmissing = 6 "6+"), gen(childs)
label var childs "Number of Children in the Household"
tab childs

label var roof "Type of Roof"
label var wall "Type of Wall"
label var electricity "Electricity"
label var water "Water Connection"

local ivars "roof walls electricity water childs"
local bvars "childs"


// Graphs for single variables

// Pie graph for some single variables

foreach ivar of varlist `ivars' {
	tab `ivar'
	graph pie, over(`ivar') cw plabel(_all sum, size(small) orientation(vertical) format(%3.0f)) title(`"`: var label `ivar''"') caption("Number of Respondents: `r(N)'") subtitle("")
	graph export "descriptive/household_info/`ivar'.png", replace
	//graph pie, over(`ivar') cw plabel(_all percent, color(white) size(small) orientation(vertical) format(%3.1f)) scheme(s2mono) title(`"`: var label `ivar''"') subtitle("")
	//graph export "descriptive/household_info/`ivar'_mono.png", replace 
}
/*
// Bar graphs
foreach ivar of varlist `bvars' {
	tab `ivar'
	catplot `ivar', var1opts(sort(1) descending) recast(hbar) nopercent title(`"`: var label `ivar''"') caption("Observations: `r(N)'") b1title("") ytitle("") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/household_info/`ivar'_b.png", replace
}

*/
exit