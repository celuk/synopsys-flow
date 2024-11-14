source scripts/00_setup.tcl

set PREVIOUS_STEP $SEXTRACT_BLOCK
set CURRENT_STEP $SMFILL_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

#set_app_options -name signoff.create_metal_fill.runset -value {fill.rs}
#set_app_options -name signoff.create_metal_fill.base_metal_layers -value {fill.rs}
#set_app_options -name signoff.create_metal_fill.fix_density_errors -value true
#signoff_create_metal_fill -all_runset_layers -track_fill generic -foundry_fill_type feol -auto_eco true
#set_app_options -name signoff.physical.merge_stream_files $GDS_FILES_TO_MERGE
#set_app_options -name signoff.physical.layer_map_file -value $GDSOUT_MAP_FILE

## add sealring before metal filling
create_cell SealRing $SEALRING_CELL

## post_route_auto_delete is not in docs??
create_stdcell_fillers -lib_cells "$METAL_FILLER_CELLS $NON_METAL_FILLER_CELLS" -rules {check_pnet no_1x post_route_auto_delete}

check_legality

connect_pg_net -automatic

check_mv_design

remove_stdcell_fillers_with_violation

connect_pg_net -automatic
check_mv_design

verify_pg_nets

connect_pg_net -automatic
check_mv_design

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}

exit
