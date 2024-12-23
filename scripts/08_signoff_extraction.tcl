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

set PREVIOUS_STEP $ROUTING_BLOCK
set CURRENT_STEP $SEXTRACT_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

# fusion_adv or in_design

#set_starrc_in_design -config $STARRC_CONFIG_FILE -mode starrc_centric
#sh cat $STARRC_CONFIG_FILE
#sh cat $PARASITICS_MAP_FILE
#sh cat $STARRC_MAPPING_FILE

set_app_options -name extract.starrc_mode -value fusion_adv
set_app_options -name extract.fusion_without_starrc_config -value 1

set route_global_timing_driven [get_app_option_value -name route.global.timing_driven]
set route_track_timing_driven [get_app_option_value -name route.track.timing_driven]
set route_detail_timing_driven [get_app_option_value -name route.detail.timing_driven]
set route_global_crosstalk_driven [get_app_option_value -name route.global.crosstalk_driven]
set route_track_crosstalk_driven [get_app_option_value -name route.track.crosstalk_driven]

set_app_options -name route.global.timing_driven -value false
set_app_options -name route.track.timing_driven -value false
set_app_options -name route.detail.timing_driven -value false 
set_app_options -name route.global.crosstalk_driven -value false
set_app_options -name route.track.crosstalk_driven -value false

route_eco -utilize_dangling_wires true -reroute modified_nets_first_then_others

set_app_options -name route.global.timing_driven -value $route_global_timing_driven
set_app_options -name route.track.timing_driven -value $route_track_timing_driven
set_app_options -name route.detail.timing_driven -value $route_detail_timing_driven
set_app_options -name route.global.crosstalk_driven -value $route_global_crosstalk_driven
set_app_options -name route.track.crosstalk_driven -value $route_track_crosstalk_driven

route_detail -incremental true -initial_drc_from_input true

update_timing -full

#route_eco -max_detail_route_iterations 1000

#update_timing -full

#route_eco -max_detail_route_iterations 1000

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

check_mv_design

check_lvs

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_extracted_clock_tree.rpt {report_clock_qor -all -nosplit}

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_timing.rpt {report_timing -nosplit -transition_time -capacitance}

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_area.rpt {report_area -nosplit}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_power.rpt {report_power -nosplit}

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_clock_qor.rpt {report_clock_qor -all -nosplit}

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_clock_max_tim.rpt {report_timing -capacitance -transition_time -input_pins -nets -delay_type max}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_clock_min_tim.rpt {report_timing -capacitance -transition_time -input_pins -nets -delay_type min}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_hold_setup_global_timing.rpt {report_global_timing -pba_mode [get_app_option_value -name time.pba_optimization_mode] -nosplit}

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_constraints.rpt {report_constraints -nosplit}

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
