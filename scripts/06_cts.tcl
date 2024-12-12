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

set PREVIOUS_STEP $PLACE_BLOCK
set CURRENT_STEP $CTS_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

synthesize_clock_trunks

source -echo $TCL_ANTENNA_RULE_FILE

#set_lib_cell_purpose -include cts $CTS_LIB_CELL_PATTERNS

#create_routing_rule CTS_NDR -default_reference_rule \
#	-multiplier_width 2 \
#	-spacings {M2 0.052 M3 0.052 M4 0.08 M5 0.08} \
#	-shield \
#	-shield_spacings {M2 0.026 M3 0.026 M4 0.04 M5 0.04} \
#	-snap_to_track 
#set_clock_routing_rules -rules CTS_NDR -min_routing_layer M2 -max_routing_layer M5

#set_clock_uncertainty 0.1 [all_clocks]

#create_routing_rule CTS_NDR -spacings {M2 0.3 M3 0.5 M4 0.7}
#set_clock_routing_rules -rules CTS_NDR -min_routing_layer M2 -max_routing_layer M4

#set_clock_tree_options -clocks [all_clocks] -target_skew 0.1

#get_clocks
#clock_opt -list_only
#clock_opt -to build_clock
#clock_opt -from build_clock -to route_clock 
#clock_opt -to final_opto

set_driving_cell -lib_cell $CLOCK_BUFFER_CELL [get_ports $CLK]

set_clock_tree_options -clocks [all_clocks] -target_skew 0.1

#set_app_options -name clock_opt.flow.optimize_ndr -value true

clock_opt

#remove_routes -global_route 

#set clock_nets [get_nets -hierarchical -filter "net_type == clock"]
#create_shields -nets ${clock_nets} -with_ground VSS

#set_app_options -name refine_opt.flow.optimize_ndr -value true
#refine_opt

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

check_legality

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_constraints.rpt {report_constraints -nosplit}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_clocks.rpt {report_clocks -nosplit}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_clocks_skew.rpt {report_clocks -skew -nosplit}
#redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_clock_qor.rpt {report_clock_qor -clocks $CLK -all -nosplit}

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
