source scripts/00_setup.tcl

set PREVIOUS_STEP $SEXTRACT_BLOCK
set CURRENT_STEP $SOPT_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

# route.detail.insert_diodes_during_routing
# route.detail.hop_layers_to_fix_antenna
# route.detail.reuse_filler_locations_for_diodes
# route.detail.diode_insertion_mode


#
#route_detail -incremental true -initial_drc_from_input true
#
##connect_pg_net
###connect_pg_net -automatic
#connect_pg_net -net $POWER_NET [get_pins -physical_context */VDD]
#connect_pg_net -net $GROUND_NET [get_pins -physical_context */VSS]

check_mv_design

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
