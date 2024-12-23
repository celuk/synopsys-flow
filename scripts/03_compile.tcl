# This file is part of https://github.com/celuk/synopsys-flow
# Copyright (C) 2024  Seyyid Hikmet Celik
#                     seyyid4091@gmail.com
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

set_fix_multiple_port_nets -feedthroughs -outputs -buffer_constants [get_modules *]

check_hier_design -stage pre_placement

compile_fusion -check_only

#set_app_options -name compile.flow.enable_rtl_multibit_banking -value true
compile_fusion -to initial_map

#set_app_options -name compile.flow.enable_rtl_multibit_debanking -value true
compile_fusion -from logic_opto -to logic_opto

#create_mv_cells -all -verbose
#connect_pg_net -automatic
#check_mv_design

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

check_mv_design

report_power_domain

#analyze_mv_design -level_shifter -global_report -verbose
#report_mv_path
#analyze_mv_feasibility
#sizeof_collection [get_cells -hierarchical -filter "is_level_shifter==true"]

check_pg_drc -ignore_std_cells -do_not_check_shapes_in_hier_blocks

report_multibit

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_timing.rpt {report_timing -nosplit}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_area.rpt {report_area -nosplit}

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
