source scripts/00_setup.tcl

set PREVIOUS_STEP $ROUTE_BLOCK
set CURRENT_STEP $ROUTE_OPT_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

#compute_clock_latency

#hyper_route_opt

#connect_pg_net -automatic

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
