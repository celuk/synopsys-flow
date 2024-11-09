source scripts/00_setup.tcl

set PREVIOUS_STEP $INIT_BLOCK
set CURRENT_STEP $COMPILE_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

#create_net -power VDD
#create_net -ground VSS

#set_app_options -name compile.auto_floorplan.enable -value true
#set_app_option -name compile.auto_floorplan.initialize -value auto
##set_app_options -name compile.auto_floorplan.initialize -value true
##set_app_options -name compile.auto_floorplan.place_pins -value all
#set_app_options -name compile.auto_floorplan.shape_voltage_areas -value all
#set_auto_floorplan_constraints -side_length "1200 1200"
#set_shaping_options -guard_band_size 10

set_app_options -name place.coarse.continue_on_missing_scandef -value true

compile_fusion -to initial_map
compile_fusion -check_only


compile_fusion -from logic_opto -to logic_opto
compile_fusion -from initial_place -to initial_place
compile_fusion -from initial_drc -to initial_drc
compile_fusion -from initial_opto -to initial_opto
compile_fusion -from final_place -to final_place
compile_fusion -from final_opto -to final_opto

check_legality

#connect_pg_net -net VDD [get_pins -hierarchical */VDD]
#connect_pg_net -net VSS [get_pins -hierarchical */VSS]
#connect_pg_net -net VDD [get_pins -physical_context */VDD]
#connect_pg_net -net VSS [get_pins -physical_context */VSS]
#
#check_pg_connectivity
#check_pg_drc

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
