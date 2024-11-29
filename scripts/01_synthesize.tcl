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

set CURRENT_STEP $SYNTH_BLOCK

create_lib $DESIGN_LIBRARY -technology $TECH_FILE -ref_libs $REFERENCE_LIBRARY
# -scale_factor 1000

#set_design_options

read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name nomTLU -tlup $PARASITICS_NOM_TLUPLUS_FILE
current_lib

report_ref_libs

set_current_mismatch_config auto_fix -enable {library netlist routing}

set_app_options -name lib.setting.enable_via_region_override -value true
derive_design_level_via_regions

analyze -format sverilog $VERILOG_FILES
elaborate $TOP_MODULE
set_top_module $TOP_MODULE

write_verilog $GATE_LEVEL_VERILOG

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_timing.rpt {report_timing -nosplit}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_area.rpt {report_area -nosplit}

save_lib -all

save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
