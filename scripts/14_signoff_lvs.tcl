source scripts/00_setup.tcl

set PREVIOUS_STEP $SDRC_BLOCK
set CURRENT_STEP $SLVS_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

#sh export SAED32_PATH=$EDK_PATH
#exec env SAED32_PATH=$EDK_PATH /bin/sh -c 'echo $SAED32_PATH'
#exec /bin/sh -c "export SAED32_PATH=$EDK_PATH; /bin/sh -c 'echo \$SAED32_PATH'"
#exec /bin/sh -c "export SAED32_PATH=$EDK_PATH; /bin/sh -c 'echo \$SAED32_PATH'"

#set ::env(SAED32_PATH) $EDK_PATH

#save_block -as ${DESIGN_NAME}/${CURRENT_STEP}


#
#save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
#
#signoff_check_drc
#signoff_fix_drc -max_number_repair_loop 10

#remove_stdcell_fillers_with_violation -check_between_fixed_objects true

# 0 for unlimited errors
check_lvs -checks all -max_errors 0

check_lvs -check_child_cells true -check_zero_spacing_blockages true -report_floating_pins true -open_reporting detailed

#signoff_check_design

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
