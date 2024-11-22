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

source scripts/bmp2lay_offset.tcl
sh cat scripts/bmp2lay_offset.tcl
bmp2lay -f $LOGO_FILE -layer AP -px 1 -py 1 -offsetx 244 -offsety 244

write_gds -units $STREAMOUT_RESOLUTION -hierarchy all \
-lib_cell_view {design frame layout} \
-layer_map $GDSOUT_MAP_FILE \
-merge_files "$GDS_FILES_TO_MERGE" \
$STREAMOUT_GDS_FILE \
-verbose \
-long_names \
-keep_data_type;

#change_names -rules verilog -verbose
write_verilog -include {all} $GATE_LEVEL_VERILOG

#write_sdf $STREAMOUT_SDF_FILE

#write_def -units $STREAMOUT_RESOLUTION $STREAMOUT_DEF_FILE

#write_parasitics -output $STREAMOUT_PARASITICS_FILE -format spef

# -pba_mode exhaustive -slack_lesser_than 0 -max_paths 1000
## -transition_time --> slew
redirect -file $REPORTS_DIR/15_${CURRENT_STEP}/${TOP_MODULE}_timing.rpt {report_timing -nosplit -transition_time -capacitance}
redirect -file $REPORTS_DIR/15_${CURRENT_STEP}/${TOP_MODULE}_drc_lvs.rpt {check_routes -open_net true -report_all_open_nets true -drc true -antenna true -voltage_area true}
redirect -file $REPORTS_DIR/15_${CURRENT_STEP}/${TOP_MODULE}_check_lvs.rpt {check_lvs -checks all -max_errors 0}

redirect -file $REPORTS_DIR/15_${CURRENT_STEP}/${TOP_MODULE}_area.rpt {report_area -nosplit}
redirect -file $REPORTS_DIR/15_${CURRENT_STEP}/${TOP_MODULE}_power.rpt {report_power -nosplit}

redirect -file $REPORTS_DIR/15_${CURRENT_STEP}/${TOP_MODULE}_clock_qor.rpt {report_clock_qor -all -nosplit}

redirect -file $REPORTS_DIR/15_${CURRENT_STEP}/${TOP_MODULE}_clock_max_tim.rpt {report_timing -capacitance -transition_time -input_pins -nets -delay_type max}
redirect -file $REPORTS_DIR/15_${CURRENT_STEP}/${TOP_MODULE}_clock_max_tim.rpt {report_timing -capacitance -transition_time -input_pins -nets -delay_type max}
redirect -file $REPORTS_DIR/15_${CURRENT_STEP}/${TOP_MODULE}_hold_setup_global_timing.rpt {report_global_timing -pba_mode [get_app_option_value -name time.pba_optimization_mode] -nosplit}

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
