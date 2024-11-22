source scripts/00_setup.tcl

set PREVIOUS_STEP $CTS_BLOCK
set CURRENT_STEP $ROUTE_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

sizeof_collection [get_nets -hierarchical *]

check_routability

route_global

route_track

check_routes
route_detail -incremental true -initial_drc_from_input true -max_number_iterations 1000

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
remove_redundant_shapes -remove_loop_shapes true -report_changed_nets true -initial_drc_from_input false

check_routes

optimize_routes -max_detail_route_iterations 1000
check_routes

spread_wires -pitch 2.5
widen_wires

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

#exit
