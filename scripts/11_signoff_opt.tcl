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
set CURRENT_STEP $SOPT_BLOCK
open_lib $DESIGN_LIBRARY
copy_block -from ${DESIGN_NAME}/${PREVIOUS_STEP} -to ${DESIGN_NAME}/${CURRENT_STEP}
current_block ${DESIGN_NAME}/${CURRENT_STEP}
link_block

# route.detail.insert_diodes_during_routing
# route.detail.hop_layers_to_fix_antenna
# route.detail.reuse_filler_locations_for_diodes
# route.detail.diode_insertion_mode


#
#route_detail -incremental true -initial_drc_from_input true
#
##connect_pg_net
###connect_pg_net -automatic
#connect_pg_net -net $POWER_NET [get_pins -physical_context */VDD]
#connect_pg_net -net $GROUND_NET [get_pins -physical_context */VSS]

check_mv_design

save_lib -all
save_block -as ${DESIGN_NAME}/${CURRENT_STEP}
