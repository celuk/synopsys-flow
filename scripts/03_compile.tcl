source scripts/00_setup.tcl

set PREVIOUS_STEP $INIT_BLOCK
set CURRENT_STEP $COMPILE_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

compile_fusion -check_only

set_app_options -name compile.flow.enable_rtl_multibit_banking -value true
compile_fusion -to initial_map

set_app_options -name compile.flow.enable_rtl_multibit_debanking -value true
compile_fusion -from logic_opto -to logic_opto

compile_fusion -from initial_place -to initial_place
compile_fusion -from initial_drc -to initial_drc

set_app_options -name compile.flow.enable_physical_multibit_banking -value true
set_app_options -name compile.flow.enable_multibit_debanking -value true
compile_fusion -from initial_opto -to initial_opto

set_app_options -name compile.flow.enable_second_pass_multibit_banking -value true
compile_fusion -from final_place -to final_place

set_app_options -name compile.flow.enable_multibit_debanking -value true
compile_fusion -from final_opto -to final_opto

check_legality

#create_mv_cells -all -verbose
#connect_pg_net -automatic
#check_mv_design

connect_pg_net -automatic
check_mv_design

report_power_domain

#analyze_mv_design -level_shifter -global_report -verbose
#report_mv_path
#analyze_mv_feasibility
#sizeof_collection [ get_cells -hierarchical -filter "is_level_shifter==true"]

check_pg_drc -ignore_std_cells

report_multibit

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
