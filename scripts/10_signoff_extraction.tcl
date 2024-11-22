source scripts/00_setup.tcl

set PREVIOUS_STEP $ROUTE_BLOCK
set CURRENT_STEP $SEXTRACT_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

# fusion_adv or in_design

#set_starrc_in_design -config $STARRC_CONFIG_FILE -mode starrc_centric
#sh cat $STARRC_CONFIG_FILE
#sh cat $PARASITICS_MAP_FILE
#sh cat $STARRC_MAPPING_FILE

set_app_options -name extract.starrc_mode -value fusion_adv
set_app_options -name extract.fusion_without_starrc_config -value 1

set route_global_timing_driven [get_app_option_value -name route.global.timing_driven]
set route_track_timing_driven [get_app_option_value -name route.track.timing_driven]
set route_detail_timing_driven [get_app_option_value -name route.detail.timing_driven]
set route_global_crosstalk_driven [get_app_option_value -name route.global.crosstalk_driven]
set route_track_crosstalk_driven [get_app_option_value -name route.track.crosstalk_driven]

set_app_options -name route.global.timing_driven -value false
set_app_options -name route.track.timing_driven -value false
set_app_options -name route.detail.timing_driven -value false 
set_app_options -name route.global.crosstalk_driven -value false
set_app_options -name route.track.crosstalk_driven -value false

route_eco -utilize_dangling_wires true -reroute modified_nets_first_then_others

set_app_options -name route.global.timing_driven -value $route_global_timing_driven
set_app_options -name route.track.timing_driven -value $route_track_timing_driven
set_app_options -name route.detail.timing_driven -value $route_detail_timing_driven
set_app_options -name route.global.crosstalk_driven -value $route_global_crosstalk_driven
set_app_options -name route.track.crosstalk_driven -value $route_track_crosstalk_driven

#route_detail -incremental true -initial_drc_from_input true

update_timing -full

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

check_mv_design

redirect -file $REPORTS_DIR/10_${CURRENT_STEP}/${TOP_MODULE}_extracted_clock_tree.rpt {report_clock_qor -all -nosplit}

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
