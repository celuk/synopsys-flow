source scripts/00_setup.tcl

set PREVIOUS_STEP $SEXTRACT_BLOCK
set CURRENT_STEP $SMFILL_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

create_stdcell_fillers -lib_cells "$METAL_FILLER_CELLS $NON_METAL_FILLER_CELLS" -rules {check_pnet no_1x}

check_legality

connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

check_mv_design

remove_stdcell_fillers_with_violation

connect_pg_net
check_mv_design

verify_pg_nets

connect_pg_net -net VDD [get_pins -hierarchical  */VDD]
connect_pg_net -net VSS [get_pins -hierarchical  */VSS]
check_mv_design

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
