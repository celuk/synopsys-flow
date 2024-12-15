# This file is part of https://github.com/celuk/synopsys-flow
# Copyright (C) 2024  Seyyid Hikmet Celik
# 					  seyyid4091@gmail.com
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

source scripts/00_setup.tcl

set PREVIOUS_STEP $SMFILL_BLOCK
set CURRENT_STEP $SDRC_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

#create_cell SealRing $SEALRING_CELL

save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#signoff_create_pg_augmentation -node generic
#save_block

#clock_opt

set_app_options -name signoff.check_drc.runset -value $ANTENNA_DRC_RUNSET
set_app_options -name signoff.check_drc.run_dir -value $SIGNOFF_CHECK_ANTENNA_DRC_FOLDER
signoff_check_drc -check_all_runset_layers true

save_block

set_app_options -name signoff.check_drc.runset -value $MIM_ANTENNA_DRC_RUNSET
set_app_options -name signoff.check_drc.run_dir -value $SIGNOFF_CHECK_MIM_ANTENNA_DRC_FOLDER
signoff_check_drc -check_all_runset_layers true

save_block

set_app_options -name signoff.check_drc.runset -value $DRC_RUNSET
set_app_options -name signoff.check_drc.run_dir -value $SIGNOFF_CHECK_DRC_FOLDER
#set_app_options -name signoff.check_drc.user_defined_options -value "-D WLCSP_SEALRING"
signoff_check_drc -check_all_runset_layers true -unselect_rules "RR* DRM.R.1*"
#-check_all_runset_layers true

save_block

#set_app_options -name signoff.fix_isolated_via.isolated_via_max_range -value {{M1 3.0}}
#signoff_fix_isolated_via -save_design true

set_app_options -name signoff.fix_drc.init_drc_error_db -value $SIGNOFF_CHECK_DRC_FOLDER
set_app_options -name signoff.fix_drc.run_dir -value $SIGNOFF_FIX_DRC_FOLDER
#set_app_options -name signoff.fix_drc.user_defined_options -value "-D WLCSP_SEALRING"
signoff_fix_drc -max_number_repair_loop 10 -unselect_rules "RR* DRM.R.1*"

save_block

set_app_options -name signoff.check_drc.runset -value $DRC_RUNSET
set_app_options -name signoff.check_drc.run_dir -value "${SIGNOFF_CHECK_DRC_FOLDER}_after_fix_drc"
#set_app_options -name signoff.check_drc.user_defined_options -value "-D WLCSP_SEALRING"
signoff_check_drc -check_all_runset_layers true -unselect_rules "RR* DRM.R.1*"

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
