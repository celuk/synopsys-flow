source scripts/00_setup.tcl

set PREVIOUS_STEP $DPLAN_BLOCK
set CURRENT_STEP $PLACE_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

add_tie_cells

#compile_fusion -to initial_opto
#
##reset_placement
##create_placement -timing_driven -congestion -congestion_effort high -buffering_aware_timing_driven
#
##legalize_placement
##-incremental
#
#place_opt
#
#check_legality

set_qor_strategy -stage pnr -metric $QOR_STRATEGY_METRIC -mode $QOR_STRATEGY_MODE

# -high_effort_congestion
set_stage -step placement

set_app_options -name opt.common.user_instance_name_prefix -value place_opt_
set_app_options -name cts.common.user_instance_name_prefix -value place_opt_cts_

set rm_leakage_scenarios [get_object_name [get_scenarios -filter active==true&&leakage_power==true]]
set rm_dynamic_scenarios [get_object_name [get_scenarios -filter active==true&&dynamic_power==true]]
set_scenario_status -leakage_power false -dynamic_power false [get_scenarios "$rm_leakage_scenarios $rm_dynamic_scenarios"]

#add_spare_cells -num_cells {and1 10 nor1 5} -cell_name SpareCell -random_distribution
#place_eco_cells -legalize_only -cells [get_cells -physical_context *SpareCell*]

redirect -file $REPORTS_DIR/05_${CURRENT_STEP}/${TOP_MODULE}_non_default_app_options.rpt {report_app_options -non_default *}
redirect -file $REPORTS_DIR/05_${CURRENT_STEP}/${TOP_MODULE}_lib_cell_purposes.rpt {report_lib_cells -objects [get_lib_cells] -columns {full_name:20 valid_purposes}}

#-reduced_effort
redirect -file $REPORTS_DIR/05_${CURRENT_STEP}/${TOP_MODULE}_check_stage_settings.rpt {check_stage_settings -stage pnr -metric $QOR_STRATEGY_METRIC -step placement}

set currentMode [current_mode]
foreach_in_collection mode [all_modes] {
    current_mode $mode
    set clock_tree [all_fanout -flat -clock_tree]
    if { [sizeof_collection $clock_tree] > 0 } {
        set_ideal_network $clock_tree
        remove_propagated_clock [get_pins -hierarchical]
        remove_propagated_clock [get_ports]
        remove_propagated_clock [get_clocks -filter !is_virtual]
    }
}
current_mode $currentMode

mark_clock_trees -routing_rules

## if high utilization needed
#reset_app_options time.delay_calc_wareform_analysis_mode
#remove_buffer_trees -all
#create_placement -buffering_aware_timing_driven 
#place_opt -from initial_drc -to initial_drc

#plan.macro.allow_unmapped_design
#create_placement -floorplan

## first pass
place_opt -from initial_place -to initial_place
place_opt -from initial_drc -to initial_drc
update_timing -full

create_placement -floorplan

## second pass
# -congestion_effort high
create_placement -incremental -timing_driven -congestion -congestion_effort high

save_block -as ${DESIGN_NAME}/${CURRENT_STEP}_two_pass_placement

place_opt -from initial_drc

## if high utilization needed
#place_opt -from final_place

legalize_placement
report_placement -verbose low

source scripts/createNplace_bondpads.tcl
sh cat scripts/createNplace_bondpads.tcl
createNplace_bondpads -inline_pad_ref_name $BONDPAD_CELL

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

check_mv_design

check_pin_placement -self

save_block

redirect -file $REPORTS_DIR/05_${CURRENT_STEP}/${TOP_MODULE}_qor.rpt {report_qor -nosplit}
redirect -file $REPORTS_DIR/05_${CURRENT_STEP}/${TOP_MODULE}_place_utilization.rpt {report_congestion -nosplit}
redirect -file $REPORTS_DIR/05_${CURRENT_STEP}/${TOP_MODULE}_place_utilization.rpt {report_utilization -verbose}
redirect -file $REPORTS_DIR/05_${CURRENT_STEP}/${TOP_MODULE}_place_setup.rpt {report_timing -nosplit -delay max -max_paths 20}
redirect -file $REPORTS_DIR/05_${CURRENT_STEP}/${TOP_MODULE}_place_hold.rpt {report_timing -nosplit -delay min -max_paths 20}

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
