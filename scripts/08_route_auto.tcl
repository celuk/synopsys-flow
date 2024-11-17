source scripts/00_setup.tcl

set PREVIOUS_STEP $CTS_BLOCK
set CURRENT_STEP $ROUTE_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_app_options -name opt.common.enable_via_ladder_insertion -value true
set_app_options -name opt.common.enable_via_ladder_area_api -value true

set_app_options -name time.si_enable_analysis -value true
set_app_options -name time.enable_ccs_rcv_cap -value true

set_app_options -name route.global.force_rerun_after_global_route_opt -value true
set_app_options -name route.global.timing_driven -value true
set_app_options -name route.track.timing_driven -value true
set_app_options -name route.detail.timing_driven -value true

#set_app_options -name route.common.connect_within_pins_by_layer_name -value {{M1 via_wire_standard_cell_pins} {M2 off} {M3 off} {M4 off} {M5 off} {M6 off} {M7 off} {M8 off} }
set_app_options -name route.common.net_max_layer_mode -value allow_pin_connection
set_app_options -name route.common.global_max_layer_mode -value allow_pin_connection
#set_app_options -name route.common.net_min_layer_mode -value soft
set_app_options -name route.common.global_min_layer_mode -value allow_pin_connection
#set_app_options -name route.common.number_of_vias_under_net_min_layer -value 5
#set_app_options -name route.common.number_of_vias_over_net_max_layer -value 5
#set_app_options -name route.common.number_of_vias_over_global_max_layer -value 5
#set_app_options -name route.common.rotate_default_vias -value false
#set_app_options -name route.common.route_top_boundary_mode -value stay_half_min_space_inside
#set_app_options -name route.common.shielding_nets -value {}
#set_app_options -name route.common.soft_rule_weight_to_effort_level_map -value {}
#set_app_options -name route.common.threshold_noise_ratio -value 0.20
#set_app_options -name route.common.via_array_mode -value off

set_app_options -name opt.buffering.enable_advanced_buffering -value true
set_app_options -name opt.common.enable_rde -value true

set_app_options -name route.global.export_soft_congestion_maps -value true

set_ignored_layers -min_routing_layer $MIN_ROUTING_LAYER
set_ignored_layers -max_routing_layer $MAX_ROUTING_LAYER

report_ignored_layers

sizeof_collection [get_nets -hierarchical *]

check_routability

route_global

route_track

route_detail -incremental true -max_number_iterations 1000

route_opt

#set_app_options -name route_opt.flow.enable_ccd -value true
#set_app_options -name route_opt.flow.enable_power -value true
#set_app_options -name time.pba_optimization_mode -value path
#route_opt
#
#set_app_options -name route_opt.flow.enable_ccd -value false
#route_opt
#
#set_app_options -name route_opt.flow.size_only_mode -value equal_or_smaller
#route_opt


add_redundant_vias -effort high

route_eco

check_routes
check_lvs

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

check_legality

#derive_hier_antenna_property -design_name $DESIGN_NAME

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

exit
