source scripts/00_setup.tcl

set PREVIOUS_STEP $SYNTH_BLOCK
set CURRENT_STEP $INIT_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

#set_max_transition 5.0 [current_design]

#set_attribute [get_site_defs unit] symmetry {X Y}
#set_attribute [get_site_defs unit] is_default true

read_sdc $CONSTRAINT_FILE

create_corner TT
set_parasitics_parameters -early_spec nomTLU -late_spec nomTLU -corners {TT}
create_mode FUNC_105
current_mode FUNC_105
create_scenario -mode FUNC_105 -corner TT -name FUNC_105_TT
current_scenario FUNC_105_TT
read_sdc $CONSTRAINT_FILE
current_corner TT
current_mode FUNC_105
current_scenario FUNC_105_TT
set_operating_conditions $TT_OPC
set_scenario_status FUNC_105_TT -all -active true

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

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

exit
