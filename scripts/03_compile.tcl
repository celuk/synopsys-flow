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

set PREVIOUS_STEP $INIT_BLOCK
set CURRENT_STEP $COMPILE_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

compile_fusion -check_only

set_app_options -name compile.flow.enable_rtl_multibit_banking -value true
compile_fusion -to initial_map

set_app_options -name compile.flow.enable_rtl_multibit_debanking -value true
compile_fusion -from logic_opto -to logic_opto

compile_fusion -from initial_place -to initial_place
compile_fusion -from initial_drc -to initial_drc

set_app_options -name compile.flow.enable_physical_multibit_banking -value true
set_app_options -name compile.flow.enable_multibit_debanking -value true
compile_fusion -from initial_opto -to initial_opto

set_app_options -name compile.flow.enable_second_pass_multibit_banking -value true
compile_fusion -from final_place -to final_place

set_app_options -name compile.flow.enable_multibit_debanking -value true
compile_fusion -from final_opto -to final_opto

check_legality

#create_mv_cells -all -verbose
#connect_pg_net -automatic
#check_mv_design

connect_pg_net -automatic
check_mv_design

report_power_domain

#analyze_mv_design -level_shifter -global_report -verbose
#report_mv_path
#analyze_mv_feasibility
#sizeof_collection [get_cells -hierarchical -filter "is_level_shifter==true"]

check_pg_drc -ignore_std_cells -do_not_check_shapes_in_hier_blocks

report_multibit

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
