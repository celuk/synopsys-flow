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

set PREVIOUS_STEP $COMPILE_BLOCK
set CURRENT_STEP $DPLAN_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

remove_cells "SealRing"

initialize_floorplan -control_type die -side_length "1000 1000" -core_offset 150

place_pins -self
#create_io_ring -name "ioring" -corner_height 75
## leave 10um gap for sealring

create_io_guide -name io_guide_bottom -side bottom -line {{980 20} 960}
create_io_guide -name io_guide_right -side right -line {{980 980} 960}
create_io_guide -name io_guide_top -side top -line {{20 980} 960}
create_io_guide -name io_guide_left -side left -line {{20 20} 960}
create_io_ring -name "io_ring" -guides {io_guide_right io_guide_bottom io_guide_top io_guide_left}
place_io
create_io_filler_cells -reference_cells $IO_PAD_FILLER_CELLS

create_tap_cells -lib_cell $TAP_CELL -distance 20 -pattern every_row
create_boundary_cells -left_boundary_cell "$STDCELL_LIB_NAME/$BOUNDARY_CELL" -right_boundary_cell "$STDCELL_LIB_NAME/$BOUNDARY_CELL"
add_tie_cells

source scripts/pns.tcl

## merge metal shapes in specified pad cell types while performing DRC checks
## -value {io_pad corner_pad}
set_app_option -name plan.pgroute.merge_shapes_in_pad_cell -value {io_pad}

check_pg_missing_vias
check_pg_connectivity -check_std_cell_pins none
check_pg_drc -ignore_std_cells -do_not_check_shapes_in_hier_blocks

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
