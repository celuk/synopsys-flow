source scripts/00_setup.tcl

set PREVIOUS_STEP $COMPILE_BLOCK
set CURRENT_STEP $DPLAN_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

#initialize_floorplan -side_length "850 850"
#create_io_ring -name "ring" -corner_height 75

#set_block_pin_constraints -self -allowed_layers {M3 M4} -pin_spacing_distance 2

set_app_options -name route.common.connect_within_pins_by_layer_name -value { {M1 via_wire_all_pins} }

#set pgports [remove_from_collection [get_ports] {VDD VSS}]
place_pins -self 
#-ports $pgports

place_io

source scripts/createNplace_bondpads.tcl
sh cat scripts/createNplace_bondpads.tcl
createNplace_bondpads -inline_pad_ref_name PAD70N

source scripts/bmp2lay_offset.tcl
sh cat scripts/bmp2lay_offset.tcl
bmp2lay -f /home/ananas/denemeler/snpsdenemeler/kasirgalogo.bmp -layer AP -px 1 -py 1 -offsetx 244 -offsety 244

remove_pg_via_master_rules -all
remove_pg_patterns -all
remove_pg_strategies -all
remove_pg_strategy_via_rules -all
remove_routes -ring -stripe -lib_cell_pin_connect 

set_attribute -objects [get_nets VDD] -name net_type -value power
set_attribute -objects [get_nets VSS] -name net_type -value ground

set_app_options -name plan.pgroute.honor_signal_route_drc -value true
set_app_options -name plan.pgroute.merge_shapes_for_via_creation -value true

##set_pg_strategy_via_rule VIA_NIL -via_rule { {intersection: undefined} {via_master: NIL} }
#set_pg_via_master_rule PGVIA_10X10 -via_array_dimension {10 10}
#set_pg_strategy_via_rule VIA_NIL -via_rule { {intersection: adjacent} {via_master: PGVIA_10X10} }
#
##set_pg_strategy_via_rule VIA_NIL -via_rule {{intersection: adjacent} {via_master: default}}
#
#create_pg_std_cell_conn_pattern M1_rail -layers {M1} -rail_width {@wtop @wbottom} -parameters {wtop wbottom}
#
#set_pg_strategy M1_rail_strategy_pwr -core -pattern {{name: M1_rail} {nets: VDD} {parameters: {0.07 0.07}}}
#set_pg_strategy M1_rail_strategy_gnd -core -pattern {{name: M1_rail} {nets: VSS} {parameters: {0.07 0.07}}}
#
#compile_pg -strategies M1_rail_strategy_pwr
##-ignore_drc
#compile_pg -strategies M1_rail_strategy_gnd
##-ignore_drc
#
#create_pg_mesh_pattern M5_PG \
#	-layers { {vertical_layer: M5}   {width: 0.3} {spacing: interleaving} {pitch: 40} {offset: 0.5} } 
#
#set_pg_strategy M5_PG_Strategy -core \
#	-pattern   { {name: M5_PG} {nets:{VSS VDD}} } \
#	-extension { {stop: core_boundary} }
#
#compile_pg -strategies {M5_PG_Strategy} -via_rule VIA_NIL
#
#create_pg_mesh_pattern M6_PG \
#	-layers { {horizontal_layer: M6}   {width: 0.2} {spacing: interleaving} {pitch: 40} {offset: 0.06} }
#	 
#set_pg_strategy M6_PG_Strategy -core \
#	-pattern   { {name: M6_PG} {nets:{VSS VDD}} } \
#	-extension { {stop: design_boundary_and_generate_pin} }
#
#compile_pg -strategies {M6_PG_Strategy} -via_rule VIA_NIL
#
#create_pg_mesh_pattern M7_PG \
#	-layers { {vertical_layer: M7}   {width: 0.2} {spacing: interleaving} {pitch: 40} {offset: 0.06} } 
#
#set_pg_strategy M7_PG_Strategy -core \
#	-pattern   { {name: M7_PG} {nets:{VSS VDD}} } \
#	-extension { {stop: design_boundary_and_generate_pin} }
#
#compile_pg -strategies {M7_PG_Strategy} -via_rule VIA_NIL
#
#create_pg_ring_pattern PG_Ring \
#                 -horizontal_layer M6  -vertical_layer M7 \
#                 -horizontal_width 2 -vertical_width 2 \
#                 -horizontal_spacing 10 -vertical_spacing 10
#
#set_pg_strategy PG_Ring_Strategy -core -pattern {{ name: PG_Ring} { nets: "VDD VSS" } {offset: 0.5}}
#
#compile_pg -strategies PG_Ring_Strategy -via_rule VIA_NIL
#
#set_app_options -name plan.pgroute.fix_via_drc_multiple_viadef -value true
#set_app_options -name plan.pgroute.treat_fixed_stdcell_as_macro -value true
#
#create_pg_vias -insert_additional_vias -from_layers M5 -to_layers M1 -via_masters default -nets {VDD VSS}
#create_pg_vias -insert_additional_vias -from_layers M6 -to_layers M5 -via_masters default -nets {VDD VSS}
#create_pg_vias -insert_additional_vias -from_layers M7 -to_layers M6 -via_masters default -nets {VDD VSS}

connect_pg_net -automatic
create_pg_mesh_pattern mesh_pattern -layers { {{horizontal_layer: M1} {width: 0.2} {pitch: 48} {spacing: interleaving}} {{horizontal_layer: M7} {width: 0.2} {pitch: 48} {spacing: interleaving}} {{vertical_layer: M6} {width: 0.2} {pitch: 48} {spacing: interleaving}} }
set_pg_strategy mesh_strategy -core -pattern {{pattern: mesh_pattern}{nets: {VDD VSS}}} -blockage {macros: all}
create_pg_std_cell_conn_pattern std_cell_pattern
set_pg_strategy std_cell_strategy -core -pattern {{pattern: std_cell_pattern}{nets: {VDD VSS}}}
compile_pg

#create_pg_ring_pattern ring_pattern -horizontal_layer M7 \
#   -horizontal_width {5} -horizontal_spacing {2} \
#   -vertical_layer M8 -vertical_width {5} -vertical_spacing {2} \
#                        -corner_bridge true
#
#set_pg_strategy core_ring \
#   -pattern {{name: ring_pattern} \
#   {nets: {VDD VSS VDD VSS}} {offset: {3 3}}} -core
#
#compile_pg -strategies core_ring

#create_tap_cells -lib_cell $TAP_CELL -distance 30 -pattern every_row
#create_tap_cells -lib_cell $tapcell_ref -pattern stagger -distance 70 -skip_fixed_cells -voltage_area "PD_RISC_CORE"
#create_tap_cells -lib_cell $tapcell_ref -pattern stagger -distance 70 -skip_fixed_cells -voltage_area "DEFAULT_VA"

connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

check_pg_connectivity
check_pg_drc

#check_pg_drc -load_routing_of_all_nets

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
