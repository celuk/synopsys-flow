source scripts/00_setup.tcl

set PREVIOUS_STEP $COMPILE_BLOCK
set CURRENT_STEP $DPLAN_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_block_pin_constraints -self -allowed_layers {M3 M4}
#-pin_spacing_distance 2

#set_app_options -name route.common.connect_within_pins_by_layer_name -value { {M1 via_wire_all_pins} }

set_app_options -name plan.pins.incremental -value true

set_app_options -name plan.pgroute.treat_pad_as_macro -value true

#set pgports [remove_from_collection [get_ports] {VDDPST VDD VSS}]
#place_pins -self -ports $pgports

#set pgports [remove_from_collection [get_ports] {VDD VSS}]
#place_pins -self 
#-ports $pgports

initialize_floorplan -control_type die -side_length "1000 1000" -core_offset 100
# initialize_floorplan -side_length "650 650" -core_offset 200

#create_io_ring -name "ioring" -corner_height 75
#set_attribute -objects ioring -name bounding_box -value 

#create_io_guide -name io_guide_left -side left -line {{100 100} 800}
#create_io_guide -name io_guide_top -side top -line {{100 900} 800}
#create_io_guide -name io_guide_right -side right -line {{900 900} 800}
#create_io_guide -name io_guide_bottom -side bottom -line {{900 100} 800}
#create_io_guide -name io_guide_left -side left -line {{0 0} 1000}
#create_io_guide -name io_guide_top -side top -line {{0 1000} 1000}
#create_io_guide -name io_guide_right -side right -line {{1000 1000} 1000}
#create_io_guide -name io_guide_bottom -side bottom -line {{1000 0} 1000}
#create_io_ring -name "io_ring" -guides {io_guide_left io_guide_top io_guide_right io_guide_bottom}

#place_pins -ports [get_ports *]
#set pgports [remove_from_collection [get_ports] {VDD VSS}]
#place_pins -self -ports $pgports

create_io_ring -name "ioring" -corner_height 75
place_io
place_pins -self

create_io_filler_cells -reference_cells $IO_PAD_FILLER_CELLS

# PAD70GU_SL

create_tap_cells -lib_cell $TAP_CELL -distance 100 -pattern every_row
create_boundary_cells -left_boundary_cell "$STDCELL_LIB_NAME/$BOUNDARY_CELL" -right_boundary_cell "$STDCELL_LIB_NAME/$BOUNDARY_CELL"
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

#set_app_options -name plan.pgroute.snap_stdcell_rail -value true

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

#create_pad_rings -create pg -route_pins_on_layer {M8}
#create_pad_rings -create all -route_pins_on_layer {M4 M5}

create_pg_ring_pattern vdd_ring -horizontal_layer M9     \
                                -horizontal_width {5}       \
                                -horizontal_spacing {5}   \
                                -vertical_layer M8      \
                                -vertical_width {5}         \
                                -vertical_spacing {5}     \
                                -corner_bridge false
set_pg_strategy vdd_core_ring -core -pattern {{pattern: vdd_ring}{nets: {VDD}}} \
                                  -extension {{stop: core_boundary}}
create_pg_ring_pattern vss_ring -horizontal_layer M8     \
                                -horizontal_width {5}       \
                                -horizontal_spacing {5}   \
                                -vertical_layer M9      \
                                -vertical_width {5}         \
                                -vertical_spacing {5}     \
                                -corner_bridge false
set_pg_strategy vss_core_ring -core -pattern {{pattern: vss_ring}{nets: {VSS}}} \
                                  -extension {{stop: core_boundary}}
compile_pg -strategies vdd_core_ring
compile_pg -strategies vss_core_ring

create_pg_mesh_pattern pg_mesh -layers {{{vertical_layer: M9} {spacing: 5}      \
                                          {width: 5} {pitch: 150} {trim: false}}    \
                                        {{horizontal_layer: M8} {spacing: 5}    \
                                          {width: 5} {pitch: 150} {trim: false}}}
set_pg_strategy s_mesh -pattern {{pattern: pg_mesh} {nets: {VDD VSS}} {offset_start: 150 150}} \
                       -core -extension {{stop: outermost_ring}}
compile_pg -strategies s_mesh

create_pg_std_cell_conn_pattern pg_std_cell_rail -layers {M1}
set_pg_strategy s_std_cell_rail -core -pattern {{name: pg_std_cell_rail} {nets: VDD VSS}} -extension {{{stop : outermost_ring}}}
compile_pg -strategies s_std_cell_rail

create_pg_macro_conn_pattern macro_connect_pattern \
-pin_conn_type scattered_pin -nets {VDD VSS} \
-width {2 2} -layers {M9 M8}
set_pg_strategy s_macro_connect \
-pattern {{name: macro_connect_pattern} {nets: VDD VSS}} \
-macros "$iopads"
compile_pg -strategies s_macro_connect

resolve_pg_nets -verbose
connect_pg_net -automatic

#create_pg_vias -nets VDD -within_bbox [get_attribute [get_core_area] bbox]
#create_pg_vias -nets VSS -within_bbox [get_attribute [get_core_area] bbox]

#compile_pg
#-via_rule {adjacent_only}

#create_pg_strap -layer M4 -direction vertical \
#-net VDD -width 0.6 \
#-start 200 -stop 800 -pitch 20
#
#create_pg_strap -layer M5 -direction horizontal \
#-net VSS -width 0.6 \
#-start 200 -stop 800 -pitch 20

#set_pg_via_master_rule via_rule
# -contact_code {VIA67_BW114 VIA67_BW76 VIA67_BW38_UW38 VIA67_BW21}
#create_pg_vias -nets {VDD VSS} \
#-within_bbox [get_attribute [get_core_area] bbox] \
#-from_layers M5 -to_layers M4 -via_masters {via_rule}

#create_pg_vias -nets VDDPST


#create_pg_vias -nets {VDD VSS} -create_ml_data
#train_pg_ml_model
#create_pg_vias -nets {VDD VSS} -use_ml_model

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

#gui_add_missing_vias -min_layer M1 -max_layer M2 [get_shapes -of_objects [get_nets VDD]]

#place_io
#set_app_options -name plan.pgroute.hmpin_connection_target_layers -value D6
# 
#create_pg_macro_conn_pattern io_to_ring -pin_conn_type scattered_pin \
#    -pin_layers {G1} -layers {G1 D6} -width 0.7 \
#    -via_rule {{{intersection: all} {via_master: NIL}}}
# 
#set_pg_strategy s_io_to_ring -macros I_PAD/I_VSSIO_L01 \
#    -pattern {{name: io_to_ring}{nets: VSSIO}}
# 
#set_pg_strategy_via_rule rule1 -via_rule { \
#   {{{strategies: s_io_to_ring}{layers: G1}} {{existing: ring}{layers: D6}} \
#    {via_master: default}} {{intersection: undefined} {via_master: NIL}}}
# 
#compile_pg -strategies s_io_to_ring -via_rule rule1

#set cellPtr WELLTAP_3_R3_C0_8138
#
#set_app_options -name plan.pgroute.treat_cell_type_as_macro -value "well_tap"
#
#create_pg_macro_conn_pattern P_tapcell \
#        -pin_conn_type scattered_pin \
#        -nets          "gnds vdds" \
#        -pin_layers    M2 \
#        -layers        "M2 M3" \
#        -via_rule {{intersection: adjacent} {via_master: iccII_M3_M2_0_050_x_0_054_WELLTAP}}
#
#set_pg_strategy S_tapcell \
#        -macros [get_cells $cellPtr] \
#        -pattern   "{name: P_tapcell}{nets: gnds vdds}"
#
#compile_pg -strategies S_tapcell

synthesize_clock_trunks

check_pg_connectivity
check_pg_drc

#check_pg_drc -load_routing_of_all_nets -check_detail_route_shapes

# analyze_power_plan -nets {VDD VSS} -power_budget 1000

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

exit
