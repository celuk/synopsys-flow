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

set PREVIOUS_STEP $SEXTRACT_BLOCK
set CURRENT_STEP $SMFILL_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

## post_route_auto_delete is not in docs??
create_stdcell_fillers -lib_cells "$METAL_FILLER_CELLS $NON_METAL_FILLER_CELLS" -rules {check_pnet no_1x post_route_auto_delete}
check_legality
connect_pg_net -automatic
check_mv_design
remove_stdcell_fillers_with_violation
connect_pg_net -automatic

check_pg_drc
check_connectivity
check_lvs

check_mv_design
verify_pg_nets

#signoff_create_metal_fill -track_fill generic -fill_all_tracks true -select_layers [get_layers *]
#signoff_create_metal_fill -track_fill generic -fill_all_tracks true -select_layers "M1 M2 M3 M4 M5 M6 M7 M8 M9 OD PO"

#signoff_create_metal_fill -foundry_fill_type both -foundry_for_feol_fill generic -all_runset_layers true
#signoff_create_metal_fill -foundry_fill_type both -foundry_for_feol_fill generic -select_layers [get_layers *]

#signoff_create_metal_fill -foundry_fill_type both -foundry_for_feol_fill generic -select_layers "M1 M2 M3 M4 M5 M6 M7 M8 M9 OD PO"

set_app_options -name signoff.create_metal_fill.runset -value $METAL_FILL_BEOL_RUNSET
signoff_create_metal_fill -all_runset_layers true

set_app_options -name signoff.create_metal_fill.runset -value $METAL_FILL_FEOL_RUNSET
signoff_create_metal_fill -all_runset_layers true


#signoff_create_metal_fill -all_runset_layers true -track_fill generic -fill_all_tracks true -foundry_fill_type both
# -fill_all_tracks true -mode overwrite

#signoff_create_metal_fill -track_fill generic -select_layers [get_layers M*] -fill_all_tracks true

#signoff_create_metal_fill -track_fill generic -select_layers [get_layers M*] -fill_all_tracks true -foundry_fill_type both -foundry_for_feol_fill generic

#signoff_report_metal_density

#set_extraction_options -real_metalfill_extraction auto

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

save_block

check_lvs -checks all -max_errors 0

set_app_options -name signoff.check_drc.runset -value $DRC_RUNSET
set_app_options -name signoff.check_drc.run_dir -value "${SIGNOFF_CHECK_DRC_FOLDER}_after_metal_fill"
signoff_check_drc -unselect_rules "RR*"

save_block

create_cell SealRing $SEALRING_CELL
set sealring [get_cells -filter "is_hard_macro == true" -hier]
set_attribute $sealring -name physical_status -value fixed
#move_objects -to [list -5 -5] [get_cells "SealRing"]

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

#save_block
#
#set_app_options -name signoff.check_drc.runset -value $DRC_RUNSET
#set_app_options -name signoff.check_drc.run_dir -value $SIGNOFF_CHECK_DRC_FOLDER
#set_app_options -name signoff.check_drc.user_defined_options -value "-D WLCSP_SEALRING"
#signoff_check_drc -unselect_rules "RR*"

#set_app_options -name signoff.create_metal_fill.user_defined_options -value "-D WithSealring"
#signoff_create_metal_fill -foundry_fill_type both -foundry_for_feol_fill generic -select_layers "M1 M2 M3 M4 M5 M6 M7 M8 M9 OD PO"

check_mv_design

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
