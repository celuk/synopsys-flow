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

set ICC_SHELL_EXEC "data/icc_shell"
set_app_options -name lib.configuration.icc_shell_exec -value "$ICC_SHELL_EXEC"
#set_app_options -name lib.setting.icc_shell_exec -value "$ICC_SHELL_EXEC -shared_license"
set_app_options -name lib.workspace.library_developer_mode -value true
set_app_options -name lib.configuration.display_lm_messages -value true

set_app_options -name shell.common.tmp_dir_path -value $NDM_PATH

set_app_var link_library " \
${STDCELL_DB_PREFIX}bc.db \
${STDCELL_DB_PREFIX}lt.db \
${STDCELL_DB_PREFIX}ml.db \
${STDCELL_DB_PREFIX}tc.db \
${STDCELL_DB_PREFIX}wc.db \
${STDCELL_DB_PREFIX}wcl.db \
${STDCELL_DB_PREFIX}wcz.db \
${IO_DB_PREFIX}bc1.db \
${IO_DB_PREFIX}lt1.db \
${IO_DB_PREFIX}ml1.db \
${IO_DB_PREFIX}tc1.db \
${IO_DB_PREFIX}wc1.db \
${IO_DB_PREFIX}wcl1.db \
${IO_DB_PREFIX}wcz1.db \
"

create_lib $DESIGN_LIBRARY -technology $TECH_FILE -ref_libs $REFERENCE_LIBRARY
#" \
#${STD_MILKYWAY} \
#${IO_MILKYWAY} \
#${BONDPAD_MILKYWAY} \
#" -scale_factor 1000

#${STD_MILKYWAY} \
#${IO_MILKYWAY} \
#${BONDPAD_MILKYWAY} \
#${STD_MILKYWAY_FRAME_ONLY} \
#${IO_MILKYWAY_FRAME_ONLY} \
#${BONDPAD_MILKYWAY_FRAME_ONLY} \

#set_design_options

read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name nomTLU -tlup $PARASITICS_NOM_TLUPLUS_FILE
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name minTLU -tlup $PARASITICS_MIN_TLUPLUS_FILE
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name maxTLU -tlup $PARASITICS_MAX_TLUPLUS_FILE
current_lib

report_ref_libs

set_current_mismatch_config auto_fix -enable {library netlist routing}

set_app_options -name lib.setting.enable_via_region_override -value true
derive_design_level_via_regions

analyze -format sverilog $VERILOG_FILES
elaborate $TOP_MODULE
set_top_module $TOP_MODULE

write_verilog $GATE_LEVEL_VERILOG

save_lib -all

save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
