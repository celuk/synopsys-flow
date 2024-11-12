source scripts/00_setup.tcl

set PREVIOUS_STEP $COMPILE_BLOCK
set CURRENT_STEP $DPLAN_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

#set_block_pin_constraints -self -allowed_layers {M3 M4} -pin_spacing_distance 2

set_app_options -name route.common.connect_within_pins_by_layer_name -value { {M1 via_wire_all_pins} }

#set pgports [remove_from_collection [get_ports] {VDDPST VDD VSS}]
#place_pins -self -ports $pgports

#set pgports [remove_from_collection [get_ports] {VDD VSS}]
#place_pins -self 
#-ports $pgports
place_pins -ports [get_ports *]

#place_io

source scripts/createNplace_bondpads.tcl
sh cat scripts/createNplace_bondpads.tcl
createNplace_bondpads -inline_pad_ref_name PAD70N

#source scripts/bmp2lay_offset.tcl
#sh cat scripts/bmp2lay_offset.tcl
#bmp2lay -f /home/ananas/denemeler/snpsdenemeler/kasirgalogo.bmp -layer AP -px 1 -py 1 -offsetx 244 -offsety 244

#remove_pg_via_master_rules -all
#remove_pg_patterns -all
#remove_pg_strategies -all
#remove_pg_strategy_via_rules -all
#remove_routes -ring -stripe -lib_cell_pin_connect

#remove_routes -net_types {power ground} -ring -stripe -macro_pin_connect -lib_cell_pin_connect
#remove_pg_regions -all
#set macros_col [get_cells -physical_context -filter "is_hard_macro==true" -quiet]

set_attribute -objects [get_nets VDDPST] -name net_type -value power
set_attribute -objects [get_nets VDD] -name net_type -value power
set_attribute -objects [get_nets VSS] -name net_type -value ground

set_app_options -name plan.pgroute.honor_signal_route_drc -value true
set_app_options -name plan.pgroute.merge_shapes_for_via_creation -value true


check_pg_connectivity
check_pg_drc

#check_pg_drc -load_routing_of_all_nets

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
