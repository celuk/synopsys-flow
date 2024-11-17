source scripts/00_setup.tcl

set PREVIOUS_STEP $SYNTH_BLOCK
set CURRENT_STEP $INIT_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

#set_app_options -name mv.upf.enable_golden_upf -value true

#set_max_transition 5.0 [current_design]

#set_attribute [get_site_defs unit] symmetry {X Y}
#set_attribute [get_site_defs unit] is_default true

#set VDD [get_nets VDD -all]
#set VSS [get_nets VSS -all]

read_sdc $CONSTRAINT_FILE

set_dont_touch [get_cells {Corner* VDD* VSS* PDDW0204CDG*}]

#set_app_options -name mv.incomplete_upf.enable -value true

## to create voltage area automatically, it should be false
set_app_options -name mv.upf.enable_missing_voltage_area -value false

#load_upf $UPF_FILE
#commit_upf

report_incomplete_upf

create_corner TT
set_parasitics_parameters -early_spec nomTLU -late_spec nomTLU -corners {TT}
create_mode FUNC_12
current_mode FUNC_12
create_scenario -mode FUNC_12 -corner TT -name FUNC_12_TT
current_scenario FUNC_12_TT
read_sdc $CONSTRAINT_FILE
current_corner TT
current_mode FUNC_12
current_scenario FUNC_12_TT
#set_operating_conditions $TT_OPC_STDCELL -library $STDCELL_LIB_NAME
#set_operating_conditions $TT_OPC_IO -library $IO_LIB_NAME
#set_operating_conditions $TT_OPC_IO
set_temperature 25
set_process_number 1.00
set_voltage 1.2
set_voltage -object_list VDDPST 2.5
set_voltage -object_list VSS 0.0
#set_operating_conditions $TT_OPC_STDCELL
#set_operating_conditions $TT_OPC_IO
set_temperature 25
set_process_number 1.00

set_voltage -object_list VDD 1.2
set_voltage -object_list VSS 0.0

set_timing_derate -late 1.04
set_timing_derate -early 0.96
set_scenario_status FUNC_12_TT -all -active true

#create_corner TT
#set_parasitics_parameters -early_spec nomTLU -late_spec nomTLU -corners {TT}
#create_mode FUNC_12
#current_mode FUNC_12
#create_scenario -mode FUNC_12 -corner TT -name FUNC_12_TT
#current_scenario FUNC_12_TT
#read_sdc $CONSTRAINT_FILE
#current_corner TT
#current_mode FUNC_12
#current_scenario FUNC_12_TT
#set_operating_conditions $TT_OPC_STDCELL
#set_scenario_status FUNC_12_TT -all -active true

set_max_transition $MAX_TRANSITION [current_design]
set_max_fanout $MAX_FANOUT [current_design]

#create_voltage_area -power_domains PD_CORE -region {{0 0} {850 850}} -guard_band {{10 10}}

#create_voltage_area -name VA_IO -power_domain PD_C0_IO -power VDDPST -ground VSS
#create_voltage_area -name VA_SOC -power_domain PD_C0_SOC -power VDD -ground VSS

connect_pg_net -automatic

check_mv_design

report_pvt

set_ignored_layers -min_routing_layer $MIN_ROUTING_LAYER
set_ignored_layers -max_routing_layer $MAX_ROUTING_LAYER

## Set routing directions
foreach direction_offset_pair $ROUTING_LAYER_DIRECTION_OFFSET_LIST {
	set layer [lindex $direction_offset_pair 0]
	set direction [lindex $direction_offset_pair 1]
	set offset [lindex $direction_offset_pair 2]
	set_attribute [get_layers $layer] routing_direction $direction
	set_attribute [get_layers $layer] track_offset $offset
}

#commit_block "c0_top"

report_design_mismatch -verbose

#set_attribute [get_mismatch_types missing_logical_reference] current_repair(user_config) create_blackbox
#report_design_mismatch -verbose

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

exit
