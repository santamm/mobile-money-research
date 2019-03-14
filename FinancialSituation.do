preserve

clear all
macro drop _all
set linesize 255
use 1309_mm_data02.dta, clear

// Recoding variables


label var situation "Perceived Financial Situation of the HH"
label var security "Perceived security of the HH finances"


local ivars "security situation"
local bvars "security situation"



// Graphs for single variables

// Pie graph for some single variables
/*
foreach ivar of varlist `ivars' {
	graph pie, over(`ivar') cw plabel(_all percent, size(small) orientation(vertical) format(%3.1f)) title(`"`: var label `ivar''"') subtitle("")
	graph export "descriptive/fin_situation/`ivar'.png", replace
	//graph pie, over(`ivar') cw plabel(_all percent, color(white) size(small) orientation(vertical) format(%3.1f)) scheme(s2mono) title(`"`: var label `ivar''"') subtitle("") xsize(2) ysize(2)
	//graph export "descriptive/fin_situation/`ivar'_mono.png", replace 
}
*/


foreach ivar of varlist `bvars' {
catplot `ivar', recast(bar) nopercent title (`"`: var label `ivar''"') caption("Respondents: 528") b1title("") ytitle("") blabel(bar, position(outside) format(%3.0f))
	graph export "descriptive/fin_situation/`ivar'_bar.png", replace
}




exit