source scripts/00_setup.tcl

set PREVIOUS_STEP $SDRC_BLOCK
set CURRENT_STEP $SLVS_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set ::env(ICV_HOME_DIR) $ICV_HOME_DIR
set ::env(PATH) "$ICV_EXEC_PATH:$env(PATH)"
set ::env(ICV_INCLUDES) "${ICV_HOME_DIR}/include"

#sh export SAED32_PATH=$EDK_PATH
#exec env SAED32_PATH=$EDK_PATH /bin/sh -c 'echo $SAED32_PATH'
#exec /bin/sh -c "export SAED32_PATH=$EDK_PATH; /bin/sh -c 'echo \$SAED32_PATH'"
#exec /bin/sh -c "export SAED32_PATH=$EDK_PATH; /bin/sh -c 'echo \$SAED32_PATH'"

set ::env(SAED32_PATH) $EDK_PATH

save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#set_app_options -name signoff.check_drc.runset -value $LVS_RUNSET
#set_app_options -name signoff.check_drc.run_dir -value "z_lvs_run"

set_app_options -name signoff.check_drc.runset -value $LVS_RUNSET
set_app_options -name signoff.check_drc.run_dir -value $SIGNOFF_CHECK_LVS_FOLDER
set_app_options -name signoff.fix_drc.init_drc_error_db -value $SIGNOFF_CHECK_LVS_FOLDER
set_app_options -name signoff.fix_drc.run_dir -value $SIGNOFF_FIX_LVS_FOLDER

save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

signoff_check_drc
signoff_fix_drc -max_number_repair_loop 10

#remove_stdcell_fillers_with_violation -check_between_fixed_objects true

# 0 for unlimited errors
check_lvs -checks all -max_errors 0

#set_app_options -name signoff.check_design.max_errors_per_rule -value 6000
#set_app_options -global {signoff.check_design.runset $LVS_RUNSET}
#signoff_check_design

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

exit
