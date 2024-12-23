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

set PREVIOUS_STEP $SLVS_BLOCK
set CURRENT_STEP $STREAMOUT_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

#create_cell SealRing $SEALRING_CELL
#set sealring [get_cells -filter "is_hard_macro == true" -hier]
#set_attribute $sealring -name physical_status -value fixed

write_gds -units $STREAMOUT_RESOLUTION -hierarchy all \
-lib_cell_view {design frame layout} \
-layer_map $GDSOUT_MAP_FILE \
-merge_files "$GDS_FILES_TO_MERGE" \
$STREAMOUT_GDS_WLOGO_FILE \
-merge_gds_top_cell $TOP_MODULE \
-verbose \
-long_names \
-keep_data_type;

#change_names -rules verilog -verbose
write_verilog -include {all} ${TOP_MODULE}_gate_level_all.v

write_sdf $STREAMOUT_SDF_FILE

write_def -units $STREAMOUT_RESOLUTION $STREAMOUT_DEF_FILE

write_parasitics -output $STREAMOUT_PARASITICS_FILE -format spef

# -pba_mode exhaustive -slack_lesser_than 0 -max_paths 1000
## -transition_time --> slew
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_timing.rpt {report_timing -nosplit -transition_time -capacitance}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_drc_lvs.rpt {check_routes -open_net true -report_all_open_nets true -drc true -antenna true -voltage_area true -write_blockage_drcs_to_error_cell_as_ignored true}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_check_lvs.rpt {check_lvs -checks all -max_errors 0 -exclude_child_cell_types {macro}}

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_area.rpt {report_area -nosplit}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_power.rpt {report_power -nosplit}

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_clock_qor.rpt {report_clock_qor -all -nosplit}

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_clock_max_tim.rpt {report_timing -capacitance -transition_time -input_pins -nets -delay_type max}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_clock_min_tim.rpt {report_timing -capacitance -transition_time -input_pins -nets -delay_type min}
redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_hold_setup_global_timing.rpt {report_global_timing -pba_mode [get_app_option_value -name time.pba_optimization_mode] -nosplit}

redirect -file $REPORTS_DIR/${CURRENT_STEP}/${TOP_MODULE}_constraints.rpt {report_constraints -nosplit}

write_lib_package -include_all_blocks -include_db_files $LIB_PACKAGE

#save_block
#set_app_options -name signoff.check_drc.runset -value $DRC_RUNSET
#set_app_options -name signoff.check_drc.run_dir -value ${SIGNOFF_CHECK_DRC_FOLDER}_streamout
#signoff_check_drc -check_all_runset_layers true -unselect_rules "RR* DRM.R.1*"

#/usr/synopsys/icvalidator/V-2023.12/bin/icv_nettran -verilog all_c0_soc_gate_level.v -sp $STDCELL_SPICE_FILE $IO_SPICE_FILE -verilog-b1 VDD -verilog-b0 VSS -outName c0_soc.spi -outType SPICE -dupCell USE_MULTIPLE -sp-dupPort WARNING -sp-resolveDupInstances -globalNets VDD -forceGlobalsOn

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
