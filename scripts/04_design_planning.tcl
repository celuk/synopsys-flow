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
#create_io_break_cells

#source scripts/createNplace_bondpads.tcl
#sh cat scripts/createNplace_bondpads.tcl
#createNplace_bondpads -inline_pad_ref_name PAD70N

#set_dont_touch [get_cells *PAD*]

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

check_pg_connectivity
check_pg_drc

#check_pg_drc -load_routing_of_all_nets -check_detail_route_shapes

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
