source scripts/00_setup.tcl

set PREVIOUS_STEP $SMFILL_BLOCK
set CURRENT_STEP $SDRC_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_app_options -name signoff.check_drc.runset -value $DRC_RUNSET
#set_app_options -name signoff.check_drc_live.runset -value $DRC_RUNSET
set_app_options -name signoff.check_drc.run_dir -value $SIGNOFF_CHECK_DRC_FOLDER
set_app_options -name signoff.fix_drc.init_drc_error_db -value $SIGNOFF_CHECK_DRC_FOLDER
set_app_options -name signoff.fix_drc.run_dir -value $SIGNOFF_FIX_DRC_FOLDER
set_app_options -name signoff.physical.layer_map_file -value $GDSOUT_MAP_FILE
set_app_options -name signoff.physical.merge_stream_files -value $GDS_FILES_TO_MERGE

#create_cell SealRing $SEALRING_CELL

save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

signoff_check_drc
#-check_all_runset_layers true

save_block

#set_app_options -name signoff.fix_isolated_via.isolated_via_max_range -value {{M1 3.0}}
#signoff_fix_isolated_via -save_design true
signoff_fix_drc -max_number_repair_loop 10

save_block

set_app_options -name signoff.check_drc.runset -value $ANTENNA_DRC_RUNSET
set_app_options -name signoff.check_drc.run_dir -value $SIGNOFF_CHECK_ANTENNA_DRC_FOLDER
signoff_check_drc

set_app_options -name signoff.check_drc.runset -value $MIM_ANTENNA_DRC_RUNSET
set_app_options -name signoff.check_drc.run_dir -value $SIGNOFF_CHECK_MIM_ANTENNA_DRC_FOLDER
signoff_check_drc

set_app_options -name signoff.check_drc.runset -value $DRC_RUNSET
set_app_options -name signoff.check_drc.run_dir -value "${SIGNOFF_CHECK_DRC_FOLDER}_after_fix_drc"
signoff_check_drc

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

exit
