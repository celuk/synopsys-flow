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

set PREVIOUS_STEP $SDRC_BLOCK
set CURRENT_STEP $SLVS_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

#set_app_options -name signoff.check_design.runset -value $LVS_RUNSET
#set_app_options -name signoff.check_design.run_dir -value $SIGNOFF_CHECK_DESIGN_FOLDER
#signoff_check_design

# 0 for unlimited errors
check_lvs -checks all -max_errors 0

check_lvs -check_child_cells true -check_zero_spacing_blockages true -report_floating_pins true -open_reporting detailed

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
