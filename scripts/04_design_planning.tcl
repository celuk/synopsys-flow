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

initialize_floorplan -control_type die -side_length "1000 1000" -core_offset 110

place_pins -self
#create_io_ring -name "ioring" -corner_height 75
## leave 10um gap for sealring
create_io_guide -name io_guide_left -side left -line {{10 10} 980}
create_io_guide -name io_guide_top -side top -line {{10 990} 980}
create_io_guide -name io_guide_right -side right -line {{990 990} 980}
create_io_guide -name io_guide_bottom -side bottom -line {{990 10} 980}
create_io_ring -name "io_ring" -guides {io_guide_left io_guide_top io_guide_right io_guide_bottom}
place_io
create_io_filler_cells -reference_cells $IO_PAD_FILLER_CELLS

create_tap_cells -lib_cell $TAP_CELL -distance 100 -pattern every_row
create_boundary_cells -left_boundary_cell "$STDCELL_LIB_NAME/$BOUNDARY_CELL" -right_boundary_cell "$STDCELL_LIB_NAME/$BOUNDARY_CELL"

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

create_pg_ring_pattern pg_ring -horizontal_layer M9 \
                               -horizontal_width {5} \
                               -horizontal_spacing {2} \
                               -vertical_layer M8 \
                               -vertical_width {5} \
                               -vertical_spacing {2}
# -corner_bridge true
set_pg_strategy s_core_ring -core -pattern {{pattern: pg_ring}{nets: {VDD VSS}}{offset: {2 2}}} \
                            -extension {{stop: core_boundary}}
compile_pg -strategies s_core_ring

create_pg_std_cell_conn_pattern pg_std_cell_rail -layers {M1}
set_pg_strategy s_std_cell_rail -core -pattern {{name: pg_std_cell_rail} {nets: VDD VSS}} -extension {{{stop : outermost_ring}}}
compile_pg -strategies s_std_cell_rail

create_pg_mesh_pattern pg_mesh -layers {{{vertical_layer: M8} {spacing: 10} \
                                         {width: 5} {pitch: 100} {trim: false}} \
                                        {{horizontal_layer: M9} {spacing: 10} \
                                         {width: 5} {pitch: 100} {trim: false}}}
set_pg_strategy s_mesh -pattern {{pattern: pg_mesh} {nets: {VDD VSS}} {offset_start: 100 100}} \
                       -core -extension {{stop: outermost_ring}}
compile_pg -strategies s_mesh

## this is worser
#create_pg_strap -layer M8 -direction vertical \
#   -net VDD -width 5 \
#   -start 200 -stop 800 -pitch 100
#
#create_pg_strap -layer M8 -direction horizontal \
#   -net VSS -width 5 \
#   -start 200 -stop 800 -pitch 100
#
#create_pg_vias -nets VDD \
#   -within_bbox [get_attribute [get_core_area] bbox] \
#   -from_layers M8 -to_layers M9
#
#create_pg_vias -nets VSS \
#   -within_bbox [get_attribute [get_core_area] bbox] \
#   -from_layers M9 -to_layers M8

set iopads [get_cells -physical_context -filter "design_type==pad" -quiet]
create_pg_macro_conn_pattern macro_connect_pattern_vss \
-pin_conn_type scattered_pin -nets {VDD VSS} \
-layers {M2 M2}
set_pg_strategy s_macro_connect_vss \
-pattern {{name: macro_connect_pattern_vss} {nets: VDD VSS}} \
-macros "$iopads"
compile_pg -strategies s_macro_connect_vss

#create_pg_macro_conn_pattern macro_connect_pattern_vdd \
#-pin_conn_type scattered_pin -nets {VDD} \
#-width {4 4} -layers {M2 M2}
#set_pg_strategy s_macro_connect_vdd \
#-pattern {{name: macro_connect_pattern_vdd} {nets: VDD}} \
#-macros "$iopads"
#compile_pg -strategies s_macro_connect_vdd

#set_app_options -name plan.pgroute.hmpin_connection_target_layers -value M8
#
#create_pg_macro_conn_pattern io_to_ring -pin_conn_type scattered_pin \
#    -pin_layers {M9} -layers {M9 M8} -nets {VDD VSS} -width 4 \
#    -via_rule {{{intersection: all} {via_master: NIL}}}
#
#set_pg_strategy s_io_to_ring -macros $iopads \
#    -pattern {{name: io_to_ring}{nets: VDD VSS}}
#
#set_pg_strategy_via_rule rule1 -via_rule { \
#   {{{strategies: s_io_to_ring}{layers: M9}} {{existing: ring}{layers: M8}} \
#    {via_master: default}} {{intersection: undefined} {via_master: NIL}}}
#
#compile_pg -strategies s_io_to_ring -via_rule rule1

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

## merge metal shapes in specified pad cell types while performing DRC checks
## -value {io_pad corner_pad}
set_app_option -name plan.pgroute.merge_shapes_in_pad_cell -value {io_pad}

check_pg_connectivity -check_std_cell_pins none
check_pg_missing_vias
check_pg_drc -ignore_std_cells -do_not_check_shapes_in_hier_blocks

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
