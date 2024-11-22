source scripts/00_setup.tcl

set PREVIOUS_STEP $SEXTRACT_BLOCK
set CURRENT_STEP $SMFILL_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_app_options -name signoff.create_metal_fill.runset -value $METAL_FILL_BEOL_RUNSET
set_app_options -name signoff.create_metal_fill.base_layer_runset -value $METAL_FILL_FEOL_RUNSET
set_app_options -name signoff.create_metal_fill.fix_density_errors -value true
set_app_options -name signoff.create_metal_fill.run_dir -value $SIGNOFF_METAL_FILL_FOLDER
#set_app_options -name signoff.create_metal_fill.user_defined_options -value "-64"
# -D USE_ICC2 -dp8 -turbo
set_app_options -name signoff.physical.merge_stream_files -value $GDS_FILES_TO_MERGE
set_app_options -name signoff.physical.layer_map_file -value $GDSOUT_MAP_FILE
set_app_options -name signoff.report_metal_density.run_dir -value $SIGNOFF_METAL_DENSITY_REPORT_FOLDER
set_app_options -name signoff.report_metal_density.create_heat_maps -value true

## post_route_auto_delete is not in docs??
create_stdcell_fillers -lib_cells "$METAL_FILLER_CELLS $NON_METAL_FILLER_CELLS" -rules {check_pnet no_1x post_route_auto_delete}
check_legality
connect_pg_net -automatic
check_mv_design
remove_stdcell_fillers_with_violation
connect_pg_net -automatic


check_mv_design
verify_pg_nets

signoff_create_metal_fill -track_fill generic -fill_all_tracks true -select_layers [get_layers *]

#signoff_create_metal_fill -foundry_fill_type both -foundry_for_feol_fill generic -all_runset_layers true
signoff_create_metal_fill -foundry_fill_type both -foundry_for_feol_fill generic -select_layers [get_layers *]
#signoff_create_metal_fill -all_runset_layers true -track_fill generic -fill_all_tracks true -foundry_fill_type both
# -fill_all_tracks true -mode overwrite

#signoff_create_metal_fill -track_fill generic -select_layers [get_layers M*] -fill_all_tracks true

#signoff_create_metal_fill -track_fill generic -select_layers [get_layers M*] -fill_all_tracks true -foundry_fill_type both -foundry_for_feol_fill generic

signoff_report_metal_density

#set_extraction_options -real_metalfill_extraction auto

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

check_mv_design

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

#exit
