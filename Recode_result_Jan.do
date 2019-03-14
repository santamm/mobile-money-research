use 1309_mm_data01.dta, clear

/// Generating new variables to encode Shock Coping Behavior
*preserve //you want to keep the results from this file so you don't want to use preseve

*gen optimal_strategy:"Optimal Shock Coping Strategy" = result_cash+result_gifts+result_grants+result_funeral+result_save+result_stokvel+result_bank+result_local+result_insure+result_work+result_mm

*gen suboptimal_strategy:"Sub Optimal Shock Coping Strategy" = result_assets+result_fees+result_food+result_house+result_left+result_move+result_reduce+result_none

gen strategy = (result_cash+result_gifts+result_grants+result_funeral+result_save+result_stokvel+result_bank+result_local+result_insure+result_work+result_mm) - (result_assets+result_fees+result_food+result_house+result_left+result_move+result_reduce+result_none)
replace strategy = -1 if strategy < 0
replace strategy = 1 if strategy > 0 & strategy < .

label define strategy 1 "Optimal" 0 "Neutral" -1 "Sub-optimal", modify //define label
label values strategy strategy
label var strategy "Strategy"

 

*tab optimal_strategy

*tab suboptimal_strategy

save 1309_mm_data02.dta, replace //save as a new data-file

exit
