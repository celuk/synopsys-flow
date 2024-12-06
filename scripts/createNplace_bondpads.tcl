# Ported and modified from the ICC version of it to use in ICC2 or Fusion Compiler
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

proc createNplace_bondpads {args} {
  parse_proc_arguments -args $args pargs
  
  ## get inline bond pad ref_name
  if {[info exists pargs(-inline_pad_ref_name)]} {
      set bond_pad_ref_name $pargs(-inline_pad_ref_name)
      ## check specified inline bond pad cell
      if {[get_lib_cells $bond_pad_ref_name] == "" } {
            echo "==== INFO: You specified inline bond pad cell $bond_pad_ref_name don't exist in physical library."
            return
      }
   } else {
        echo "==== INFO: Please specify the inline bond pad ref_name."
      return
   }
   
   set oldSnapState [get_snap_setting -enabled]
   set_snap_setting -enabled false

   ## get bond pad height & width
   set bond_pad_bbox [get_attribute [get_lib_cells $bond_pad_ref_name] bbox]
   set pad_width     [expr [lindex $bond_pad_bbox 1 0] - [lindex $bond_pad_bbox 0 0]]
   set pad_height    [expr [lindex $bond_pad_bbox 1 1] - [lindex $bond_pad_bbox 0 1]]
   
   ## get all io_pad list and sort this list by coordinate
   set all_io_cell_list [collection_to_list -name_only -no_braces [get_cells -hier -f "design_type==pad"]]

   set filtered_io_cell_list {}
   foreach cell $all_io_cell_list {
       if { ![string match "CornerCell*" $cell] } {
           lappend filtered_io_cell_list $cell
       }
   }
   set all_io_cell_list $filtered_io_cell_list

   ## remove current exist inline bonding pad cell
   set get_bond_pad_cells_cmd "get_cells -quiet -hier -f \"ref_name == $bond_pad_ref_name\""
   
   set exist_bond_pad_list [eval $get_bond_pad_cells_cmd]
   
   if { $exist_bond_pad_list !=""} {
      echo "==== INFO: remove pre-exist inline bond pad cell $bond_pad_ref_name."
      remove_cell $exist_bond_pad_list
   }

   foreach io_cell $all_io_cell_list {
    set io_cell_bbox   [get_attribute [get_cells $io_cell] bbox]
    set io_cell_orient [get_attribute [get_cells $io_cell] orientation]
    set io_cell_LL_X [lindex $io_cell_bbox 0 0]
    set io_cell_LL_Y [lindex $io_cell_bbox 0 1]
    set io_cell_UR_X [lindex $io_cell_bbox 1 0]
    set io_cell_UR_Y [lindex $io_cell_bbox 1 1]

    set bond_pad_name ""
    append bond_pad_name [get_attribute [get_cells $io_cell] name] "_PAD"

    ## Update orientation based on current orientation
    switch $io_cell_orient {
        "R90" {
            set new_orientation "R90"
            set bond_pad_LL_X [expr $io_cell_LL_X + 0.5]
            set bond_pad_LL_Y [expr $io_cell_LL_Y]
        }
        "R0" {
            set new_orientation "R0"
            set bond_pad_LL_X [expr $io_cell_LL_X]
            set bond_pad_LL_Y [expr $io_cell_UR_Y - $pad_height - 0.5]
        }
        "R270" {
            set new_orientation "R270"
            set bond_pad_LL_X [expr $io_cell_UR_X - $pad_height - 0.5]
            set bond_pad_LL_Y [expr $io_cell_LL_Y]
        }
        "R180" {
            set new_orientation "R180"
            set bond_pad_LL_X [expr $io_cell_LL_X]
            set bond_pad_LL_Y [expr $io_cell_LL_Y + 0.5]
        }
    }

    ## Create and place the bond pad
    create_cell $bond_pad_name $bond_pad_ref_name
    set_attribute -quiet $bond_pad_name orientation $new_orientation
    move_objects -to [list $bond_pad_LL_X $bond_pad_LL_Y] [get_cells $bond_pad_name]
   }

   ## get current inline bonding pad cell
   set get_bond_pad_cells_cmd "get_cells -hier -f \"ref_name == $bond_pad_ref_name\""
   
   echo "==== INFO: Total add" [sizeof_collection [eval $get_bond_pad_cells_cmd]] "inline bond pad cell $bond_pad_ref_name."

   set_snap_setting -enabled $oldSnapState
}

define_proc_attributes createNplace_bondpads \
  -info "createNplace_bondpads # create and place inline bond pad" \
  -define_args {
	{-inline_pad_ref_name "inline bond pad reference name" inline_pad_ref_name string required}
}
