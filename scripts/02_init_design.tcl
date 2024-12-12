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

set PREVIOUS_STEP $SYNTH_BLOCK
set CURRENT_STEP $INIT_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

set_design_options

#set_app_options -name power.leakage_mode -value "average"
#set_app_options -name power.swcap_mode -value "on"
#set_app_options -name power.internal_mode -value "on"

#read_sdc $CONSTRAINT_FILE

source scripts/mcmm.tcl

#set_max_transition $MAX_TRANSITION [current_design]
#set_max_fanout $MAX_FANOUT [current_design]

check_mv_design

report_pvt -object_list [get_cells -filter {design_type == pad}]
report_pvt

## Set routing directions
foreach direction_offset_pair $ROUTING_LAYER_DIRECTION_OFFSET_LIST {
	set layer [lindex $direction_offset_pair 0]
	set direction [lindex $direction_offset_pair 1]
	set offset [lindex $direction_offset_pair 2]
	set_attribute [get_layers $layer] routing_direction $direction
	set_attribute [get_layers $layer] track_offset $offset
}

report_design_mismatch -verbose

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
