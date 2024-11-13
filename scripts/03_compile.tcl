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

initialize_floorplan -side_length "850 850"
create_io_ring -name "ring" -corner_height 75

set_app_options -name compile.auto_floorplan.enable -value true
set_app_options -name compile.auto_floorplan.initialize -value auto
set_app_options -name compile.auto_floorplan.place_pins -value all
set_app_options -name compile.auto_floorplan.shape_voltage_areas -value all
set_app_options -name compile.auto_floorplan.place_ios -value all
#set_app_options -name compile.auto_floorplan.place_hard_macros -value true

set_app_options -name place.coarse.continue_on_missing_scandef -value true

#set_app_options -name place.coarse.congestion_driven_max_util -value 0.83
#set_app_options -name place.coarse.pin_density_aware -value false
#set_app_options -name place.coarse.enhanced_auto_density_control -value false
#set_app_options -name compile.flow.high_effort_timing -value 0
#set_app_options -name place.coarse.auto_timing_control -value false
#set_app_options -name place.coarse.cong_restruct -value on
#set_app_options -name place.coarse.cong_restruct_effort -value high
#set_app_options -name place.coarse.cong_restruct_iterations -value 2

set_shaping_options -guard_band_size 10
shape_blocks
connect_pg_net -automatic

set_app_options -name opt.common.enable_via_ladder_insertion -value true

#set_level_shifter LVLSHS_STD -domain PD_C0_SOC
#set_level_shifter LVLSHS_IO -domain PD_C0_IO
#map_level_shifter_cell LVLSHS_STD -domain PD_C0_SOC -lib_cells $STD_LEVEL_SHIFTER_CELLS
#map_level_shifter_cell LVLSHS_IO -domain PD_C0_IO -lib_cells $IO_LEVEL_SHIFTER_CELLS
#
#set_isolation ISO_STD -domain PD_C0_SOC
#set_isolation ISO_IO -domain PD_C0_IO
#map_isolation_cell ISO_STD -domain PD_C0_SOC -lib_cells $STD_ISOLATION_CELLS
#map_isolation_cell ISO_IO -domain PD_C0_IO -lib_cells $IO_ISOLATION_CELLS

create_mv_cells -all -verbose
connect_pg_net -automatic
check_mv_design

compile_fusion -check_only

compile_fusion -to initial_map
compile_fusion -from logic_opto -to logic_opto
compile_fusion -from initial_place -to initial_place
compile_fusion -from initial_drc -to initial_drc
compile_fusion -from initial_opto -to initial_opto
compile_fusion -from final_place -to final_place
compile_fusion -from final_opto -to final_opto

check_legality

connect_pg_net -automatic
check_mv_design

report_power_domain

analyze_mv_design -level_shifter -global_report -verbose
report_mv_path
analyze_mv_feasibility
sizeof_collection [ get_cells -hierarchical -filter "is_level_shifter==true"]

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
