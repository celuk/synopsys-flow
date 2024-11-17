source scripts/00_setup.tcl

set PREVIOUS_STEP $CTS_BLOCK
set CURRENT_STEP $CTS_OPT_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

#clock_opt -from final_opto -to final_opto

#connect_pg_net -automatic

#fix_eco_timing -physical_mode occupied_site -type hold -methods "insert_buffer" -buffer_list $BUFFER_CELLS
#fix_eco_drc
#fix_eco_power -pattern {HVT LVT}

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

exit
