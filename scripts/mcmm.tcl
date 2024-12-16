# This file is part of https://github.com/celuk/synopsys-flow
# Copyright (C) 2024  Seyyid Hikmet Celik
# 					  seyyid4091@gmail.com
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# p
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

create_corner TT
set_parasitics_parameters -early_spec nomTLU -late_spec nomTLU -corners {TT}
create_mode FUNC_12
current_mode FUNC_12
create_scenario -mode FUNC_12 -corner TT -name FUNC_12_TT
current_scenario FUNC_12_TT
source $CONSTRAINT_FILE
current_corner TT
current_mode FUNC_12
current_scenario FUNC_12_TT
set_temperature 25
set_process_number 1.00
set_voltage -object_list [get_cells -filter {design_type == pad}] 2.5
set_voltage -object_list VDD 1.2
set_voltage -object_list VSS 0.0
set_timing_derate -late 1.04
set_timing_derate -early 0.96
set_scenario_status FUNC_12_TT -all -active true -leakage_power true -dynamic_power true

create_corner BC
set_parasitics_parameters -early_spec minTLU -late_spec minTLU -corners {BC}
create_mode FUNC_132
current_mode FUNC_132
create_scenario -mode FUNC_132 -corner BC -name FUNC_132_BC
current_scenario FUNC_132_BC
source $CONSTRAINT_FILE
current_corner BC
current_mode FUNC_132
current_scenario FUNC_132_BC
set_process_number 1.00
set_temperature 0
set_voltage -object_list [get_cells -filter {design_type == pad}] 2.75
set_voltage -object_list VDD 1.32
set_voltage -object_list VSS 0.0
set_timing_derate -late 1.04
set_timing_derate -early 0.96
set_scenario_status FUNC_132_BC -all -active true -leakage_power true -dynamic_power true

#create_corner LT
#set_parasitics_parameters -early_spec minTLU -late_spec minTLU -corners {LT}
#create_mode FUNC_13240
#current_mode FUNC_13240
#create_scenario -mode FUNC_13240 -corner LT -name FUNC_13240_LT
#current_scenario FUNC_13240_LT
#source $CONSTRAINT_FILE
#current_corner LT
#current_mode FUNC_13240
#current_scenario FUNC_13240_LT
#set_process_number 1.00
#set_temperature -40
#set_voltage -object_list [get_cells -filter {design_type == pad}] 2.75
#set_voltage -object_list VDD 1.32
#set_voltage -object_list VSS 0.0
#set_timing_derate -late 1.04
#set_timing_derate -early 0.96
#set_scenario_status FUNC_13240_LT -all -active true -leakage_power true -dynamic_power true

#create_corner ML
#set_parasitics_parameters -early_spec minTLU -late_spec minTLU -corners {ML}
#create_mode FUNC_132125
#current_mode FUNC_132125
#create_scenario -mode FUNC_132125 -corner ML -name FUNC_132125_ML
#current_scenario FUNC_132125_ML
#source $CONSTRAINT_FILE
#current_corner ML
#current_mode FUNC_132125
#current_scenario FUNC_132125_ML
#set_process_number 1.00
#set_temperature 125
#set_voltage -object_list [get_cells -filter {design_type == pad}] 2.75
#set_voltage -object_list VDD 1.32
#set_voltage -object_list VSS 0.0
#set_timing_derate -late 1.04
#set_timing_derate -early 0.96
#set_scenario_status FUNC_132125_ML -all -active true -leakage_power true -dynamic_power true

create_corner WC
set_parasitics_parameters -early_spec maxTLU -late_spec maxTLU -corners {WC}
create_mode FUNC_108
current_mode FUNC_108
create_scenario -mode FUNC_108 -corner WC -name FUNC_108_WC
current_scenario FUNC_108_WC
source $CONSTRAINT_FILE
current_corner WC
current_mode FUNC_108
current_scenario FUNC_108_WC
set_process_number 1.00
set_temperature 125
set_voltage -object_list [get_cells -filter {design_type == pad}] 2.25
set_voltage -object_list VDD 1.08
set_voltage -object_list VSS 0.0
set_timing_derate -late 1.04
set_timing_derate -early 0.96
set_scenario_status FUNC_108_WC -all -active true -leakage_power true -dynamic_power true

#create_corner WCL
#set_parasitics_parameters -early_spec maxTLU -late_spec maxTLU -corners {WCL}
#create_mode FUNC_10840
#current_mode FUNC_10840
#create_scenario -mode FUNC_10840 -corner WCL -name FUNC_10840_WCL
#current_scenario FUNC_10840_WCL
#source $CONSTRAINT_FILE
#current_corner WCL
#current_mode FUNC_10840
#current_scenario FUNC_10840_WCL
#set_process_number 1.00
#set_temperature -40
#set_voltage -object_list [get_cells -filter {design_type == pad}] 2.25
#set_voltage -object_list VDD 1.08
#set_voltage -object_list VSS 0.0
#set_timing_derate -late 1.04
#set_timing_derate -early 0.96
#set_scenario_status FUNC_10840_WCL -all -active true -leakage_power true -dynamic_power true

#create_corner WCZ
#set_parasitics_parameters -early_spec maxTLU -late_spec maxTLU -corners {WCZ}
#create_mode FUNC_1080
#current_mode FUNC_1080
#create_scenario -mode FUNC_1080 -corner WCZ -name FUNC_1080_WCZ
#current_scenario FUNC_1080_WCZ
#source $CONSTRAINT_FILE
#current_corner WCZ
#current_mode FUNC_1080
#current_scenario FUNC_1080_WCZ
#set_process_number 1.00
#set_temperature 0
#set_voltage -object_list [get_cells -filter {design_type == pad}] 2.25
#set_voltage -object_list VDD 1.08
#set_voltage -object_list VSS 0.0
#set_timing_derate -late 1.04
#set_timing_derate -early 0.96
#set_scenario_status FUNC_1080_WCZ -all -active true -leakage_power true -dynamic_power true
