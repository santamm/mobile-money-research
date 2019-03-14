/// Generating new variables to encode Shock Coping Behavior
preserve

gen optimal_strategy:"Optimal Shock Coping Strategy" = result_cash+result_gifts+result_grants+result_funeral+result_save+result_stokvel+result_bank+result_local+result_insure+result_work+result_mm

gen suboptimal_strategy:"Sub Optimal Shock Coping Strategy" = result_assets+result_fees+result_food+result_house+result_left+result_move+result_reduce+result_none

tab optimal_strategy

tab suboptimal_strategy



