source scripts/00_setup.tcl

set PREVIOUS_STEP $COMPILE_BLOCK
set CURRENT_STEP $DPLAN_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

initialize_floorplan -side_length "850 850"
create_io_ring -name "ring" -corner_height 75

#set_block_pin_constraints -self -allowed_layers {M3 M4} -pin_spacing_distance 2

set_app_options -name route.common.connect_within_pins_by_layer_name -value { {M1 via_wire_all_pins} }

#set pgports [remove_from_collection [get_ports] {VDD VSS}]
place_pins -self 
#-ports $pgports

place_io

source scripts/createNplace_bondpads.tcl
sh cat scripts/createNplace_bondpads.tcl
createNplace_bondpads -inline_pad_ref_name PAD70N

#source scripts/bmp2lay_offset.tcl
#sh cat scripts/bmp2lay_offset.tcl
#bmp2lay -f /home/ananas/denemeler/snpsdenemeler/kasirgalogo.bmp -layer AP -px 1 -py 1 -offsetx 244 -offsety 244

remove_pg_via_master_rules -all
remove_pg_patterns -all
remove_pg_strategies -all
remove_pg_strategy_via_rules -all
remove_routes -ring -stripe -lib_cell_pin_connect 

set_attribute -objects [get_nets VDDPST] -name net_type -value power
set_attribute -objects [get_nets VDD] -name net_type -value power
set_attribute -objects [get_nets VSS] -name net_type -value ground

set_app_options -name plan.pgroute.honor_signal_route_drc -value true
set_app_options -name plan.pgroute.merge_shapes_for_via_creation -value true

### remove all pg routes
remove_routes -net_types {power ground} -ring -stripe -macro_pin_connect -lib_cell_pin_connect

### create pg regions for all macros
remove_pg_regions -all
set macros_col [get_cells -physical_context -filter "is_hard_macro==true" -quiet]

create_pg_std_cell_conn_pattern pattern_pg_rail -layers M1 -rail_width {@w} -parameters {w}
create_pg_wire_pattern pattern_stripe -layer @l -direction @d -width @w -spacing @s -pitch @p -track_alignment @t -parameters {l d w s p t} 
create_pg_wire_pattern pattern_wire_based_on_track -layer @l -direction @d -width @w -spacing @s -pitch @p -parameters {l d w s p} -track_alignment track 

set_pg_strategy strategy_pg_rail_top -pattern "{name: pattern_pg_rail} {nets: VDD VSS} {parameters: 0.06}" -blockage {{macros_with_keepout: $macros_col} {placement_blockages: all}} -voltage_areas DEFAULT_VA
set_pg_strategy strategy_pg_rail_risc -pattern "{name: pattern_pg_rail} {nets: VDDPST VSS} {parameters: 0.06}" -blockage {{macros_with_keepout: $macros_col} {placement_blockages: all}} -voltage_areas DEFAULT_VA
compile_pg -strategies {strategy_pg_rail_top strategy_pg_rail_risc} -tag pg_rail

create_pg_composite_pattern pattern_core_m6_mesh_top -nets {VDD VSS} -add_patterns {{{pattern: pattern_wire_based_on_track} {nets: {VDD VSS}} {parameters: {M6 vertical   0.224 0.112 6.72 }}{offset: 0.1 }}} 
create_pg_composite_pattern pattern_core_m7_mesh_top -nets {VDD VSS} -add_patterns {{{pattern: pattern_wire_based_on_track} {nets: {VDD VSS}} {parameters: {M7 horizontal 0.224 0.112 6.72 }}{offset: 0.1 }}} 
create_pg_composite_pattern pattern_core_m8_mesh_top -nets {VDD VSS} -add_patterns {{{pattern: pattern_wire_based_on_track} {nets: {VDD VSS}} {parameters: {M8 vertical   0.224 0.112 6.72 }}{offset: 0.1 }}} 

create_pg_composite_pattern pattern_core_m6_mesh_risc -nets {VDDPST VSS} -add_patterns {{{pattern: pattern_wire_based_on_track} {nets: {VDDPST VSS}} {parameters: {M6 vertical   0.224 0.112 6.72 }}{offset: 0.1 }}} 
create_pg_composite_pattern pattern_core_m7_mesh_risc -nets {VDDPST VSS} -add_patterns {{{pattern: pattern_wire_based_on_track} {nets: {VDDPST VSS}} {parameters: {M7 horizontal 0.224 0.112 6.72 }}{offset: 0.1 }}} 
create_pg_composite_pattern pattern_core_m8_mesh_risc -nets {VDDPST VSS} -add_patterns {{{pattern: pattern_wire_based_on_track} {nets: {VDDPST VSS}} {parameters: {M8 vertical   0.224 0.112 6.72 }}{offset: 0.1 }}} 

create_pg_composite_pattern pattern_core_m9_mesh -nets {VDD VDDPST VSS} -add_patterns {{{pattern: pattern_wire_based_on_track} {nets: {VDD VDDPST VSS}} {parameters: {M9 horizontal 0.64  0.32  3.20 }}{offset: 0.1 }}} 

set_pg_strategy_via_rule via_pg_core -via_rule { \
{{{strategies: strategy_m9_pg_mesh}{layers: M9}}{{strategies: strategy_m8_pg_mesh_top}{layers: M8}}{via_master:default} } \
{{{strategies: strategy_m9_pg_mesh}{layers: M9}}{{strategies: strategy_m8_pg_mesh_risc}{layers: M8}}{via_master:default} } \
{{{strategies: strategy_m8_pg_mesh_top}{layers: M8}}{{strategies: strategy_m7_pg_mesh_top}{layers: M7}}{via_master:default} } \
{{{strategies: strategy_m8_pg_mesh_risc}{layers: M8}}{{strategies: strategy_m7_pg_mesh_risc}{layers: M7}}{via_master:default} } \
{{{strategies: strategy_m7_pg_mesh_top}{layers: M7}}{{strategies: strategy_m6_pg_mesh_top}{layers: M6}}{via_master:default} } \
{{{strategies: strategy_m7_pg_mesh_risc}{layers: M7}}{{strategies: strategy_m6_pg_mesh_risc}{layers: M6}}{via_master:default} } \
{{{existing : std_conn }}{{strategies: strategy_m6_pg_mesh_top}{layers: M6}}{via_master:default} } \
{{{existing : std_conn }}{{strategies: strategy_m6_pg_mesh_risc}{layers: M6}}{via_master:default} } \
{{intersection: adjacent}{via_master: default}} }

compile_pg -strategies {strategy_m6_pg_mesh_top strategy_m6_pg_mesh_risc strategy_m7_pg_mesh_top strategy_m7_pg_mesh_risc strategy_m8_pg_mesh_top strategy_m8_pg_mesh_risc strategy_m9_pg_mesh} -tag pg_stripes -via_rule {via_pg_core} -ignore_via_drc

check_pg_connectivity
check_pg_drc

#check_pg_drc -load_routing_of_all_nets

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
