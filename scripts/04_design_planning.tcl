source scripts/00_setup.tcl

set PREVIOUS_STEP $COMPILE_BLOCK
set CURRENT_STEP $DPLAN_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

#set_block_pin_constraints -self -allowed_layers {M3 M4} -pin_spacing_distance 2

set_app_options -name route.common.connect_within_pins_by_layer_name -value { {M1 via_wire_all_pins} }

set_app_options -name plan.pins.incremental -value true

#set pgports [remove_from_collection [get_ports] {VDDPST VDD VSS}]
#place_pins -self -ports $pgports

#set pgports [remove_from_collection [get_ports] {VDD VSS}]
#place_pins -self 
#-ports $pgports
place_pins -ports [get_ports *]

#place_io

create_io_filler_cells -reference_cells $IO_PAD_FILLER_CELLS

create_tap_cells -lib_cell $TAP_CELL -distance 50 -pattern every_row
create_boundary_cells -left_boundary_cell $BOUNDARY_CELL -right_boundary_cell $BOUNDARY_CELL
#create_io_break_cells

#source scripts/createNplace_bondpads.tcl
#sh cat scripts/createNplace_bondpads.tcl
#createNplace_bondpads -inline_pad_ref_name PAD70N

#set_dont_touch [get_cells *PAD*]

#remove_pg_via_master_rules -all
#remove_pg_patterns -all
#remove_pg_strategies -all
#remove_pg_strategy_via_rules -all
#remove_routes -ring -stripe -lib_cell_pin_connect

#remove_routes -net_types {power ground} -ring -stripe -macro_pin_connect -lib_cell_pin_connect
#remove_pg_regions -all
#set macros_col [get_cells -physical_context -filter "is_hard_macro==true" -quiet]

set iopads [get_cells -physical_context -filter "design_type==pad" -quiet]

set_attribute -objects [get_nets VDDPST] -name net_type -value power
set_attribute -objects [get_nets VDD] -name net_type -value power
set_attribute -objects [get_nets VSS] -name net_type -value ground

set_app_options -name plan.pgroute.honor_signal_route_drc -value true
set_app_options -name plan.pgroute.honor_std_cell_drc -value true
set_app_options -name plan.pgroute.merge_shapes_for_via_creation -value true

#set_app_options -name plan.pgroute.maximum_cell_gap_for_alignment_strap -value 0.0

#set_app_options -name plan.pgroute.snap_stdcell_rail -value true


## disabling via creation at partial intersection
set_app_option -name plan.pgroute.via_site_threshold -value 1

## merge metal shapes in specified pad cell types while performing DRC checks
## -value {io_pad corner_pad}
set_app_option -name plan.pgroute.merge_shapes_in_pad_cell -value {io_pad}

set_app_option -name plan.pgroute.auto_connect_pg_net -value true
set_app_options -name plan.pgroute.via_array_size_control -value try_cuts_in_intersection

set_app_options -name plan.pgroute.connect_user_route_shapes -value true

set_app_options -name plan.pgroute.decide_rail_width_from_routing_area -value true

#set_app_options -name plan.pgroute.maximize_total_cut_area -value all

#set_app_options -name plan.pgroute.treat_multiple_pins_as_one_target -value true

#set_app_options -name plan.pgroute.disable_stapling_via_fixing -value true
#set_app_options -name plan.pgroute.discard_stackvia_with_drc -value true
set_app_options -name plan.pgroute.fix_via_drc_multiple_viadef -value true

set_app_options -name plan.pgroute.use_via_matrix -value true
set_app_options -name plan.pgroute.use_shape_pattern -value true
## reduce memory during via drc checking
set_app_options -name plan.pgroute.high_capacity_mode -value 1

set_app_options -name plan.pgroute.verbose -value true

set_app_options -name plan.pgroute.optimize_track_alignment -value true
set_app_options -name plan.pgroute.derive_cut_net_from_pin -value true

#create_pg_vias -nets VDDPST
#create_pg_vias -nets VDD
#create_pg_vias -nets VSS

#compile_pg

#compile_pg -create_ml_data
#train_pg_ml_model
#compile_pg -use_ml_model

#generate_pg_script -template

#set floating_shapes [check_pg_connectivity]
#remove_objects $floating_shapes
##remove_objects [check_pg_connectivity]

#compile_pg -show_phantom
#create_pg_vias -show_phantom
#create_pg_strap -show_phantom

create_pg_ring_pattern ring_pattern \
-horizontal_layer M7 -horizontal_width {5} -horizontal_spacing {2} \
-vertical_layer M8 -vertical_width {5} -vertical_spacing {2}

set_pg_strategy core_ring \
-pattern {{name: ring_pattern} \
{nets: {VSS VDD VDDPST}}{offset: {-50 -50}}} -core
#-extension {{stop: design_boundary_and_generate_pin}}

compile_pg -strategies core_ring

set_pg_strategy_via_rule adjacent_only \
-via_rule {{intersection: adjacent}{via_master: default}}

create_pg_mesh_pattern mesh_pattern \
-layers {{{vertical_layer: M6} {width: 0.6} \
{pitch: 20} {offset: 20}} \
{{horizontal_layer: M5} {width: 0.6} \
{pitch: 20} {spacing: interleaving}}}

set_pg_strategy M5M6_mesh \
-pattern {{name: mesh_pattern} {nets: VDD VSS}} -core

compile_pg -strategies M5M6_mesh -via_rule {adjacent_only}

create_pg_mesh_pattern strap_pattern \
-layers {{{vertical_layer: M4} {width: 0.6} \
{pitch: 20} {spacing: interleaving} {trim: false}}}

set_pg_strategy M4_straps -core \
-pattern {{name: strap_pattern} {nets: VDD VSS}}

compile_pg -strategies M4_straps

create_pg_std_cell_conn_pattern rail_pattern -layers M1

set_pg_strategy M1_rails \
-pattern {{name: rail_pattern} {nets: VDD VSS}} -core

compile_pg -strategies M1_rails

create_pg_macro_conn_pattern macro_connect_pattern \
-pin_conn_type scattered_pin -nets {VDDPST VDD VSS} \
-width {0.3 0.3} -layers {M5 M6}

set_pg_strategy macro_connect \
-pattern {{name: macro_connect_pattern} {nets: VDDPST VDD VSS}} \
-macros "$iopads"

compile_pg -strategies macro_connect -via_rule {adjacent_only}

#create_pg_strap -layer M4 -direction vertical \
#-net VDD -width 0.6 \
#-start 200 -stop 800 -pitch 20
#
#create_pg_strap -layer M5 -direction horizontal \
#-net VSS -width 0.6 \
#-start 200 -stop 800 -pitch 20

create_pg_vias -nets {VDD VSS} \
-within_bbox [get_attribute [get_core_area] bbox] \
-from_layers M5 -to_layers M4

#gui_add_missing_vias -min_layer M1 -max_layer M2 [get_shapes -of_objects [get_nets VDD]]

check_pg_connectivity
check_pg_drc

#check_pg_drc -load_routing_of_all_nets -check_detail_route_shapes

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

exit
