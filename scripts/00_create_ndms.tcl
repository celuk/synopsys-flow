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

#source scripts/00_setup.tcl

set TECH_PATH "data/tech"
set NDM_PATH "data/lib"
set NLDM_PATH "data/nldm"
set LEF_PATH "data/lef"
set GDS_PATH "data/gds"
set TLUPLUS_PATH "data/tech/tluplus"

set LOGS_DIR "logs"
if { ![file exists $LOGS_DIR] } {
    file mkdir $LOGS_DIR
}

source scripts/00_pdk_setup.tcl

# ./GenPRTF.tcl -InputPRTF HVH/PRTF_ICC_N65_9M_6X1Z1U_RDL.24a.tf -CellHeight 12

set_app_options -name lib.workspace.allow_commit_workspace_overwrite -value true
set_app_options -name lib.workspace.create_workspace_tf_verbose -value true

## STDCELLS
create_workspace stdcell -technology $TECH_FILE -flow normal
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name maxTLU -tlup $PARASITICS_MAX_TLUPLUS_FILE
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name nomTLU -tlup $PARASITICS_NOM_TLUPLUS_FILE
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name minTLU -tlup $PARASITICS_MIN_TLUPLUS_FILE

## BCCOM
read_db ${STDCELL_DB_PREFIX}bc.db

## LTCOM
read_db ${STDCELL_DB_PREFIX}lt.db

## MLCOM
read_db ${STDCELL_DB_PREFIX}ml.db

## NCCOM
read_db ${STDCELL_DB_PREFIX}tc.db

## WCCOM
read_db ${STDCELL_DB_PREFIX}wc.db

## WCLCOM
read_db ${STDCELL_DB_PREFIX}wcl.db

## WCZCOM
read_db ${STDCELL_DB_PREFIX}wcz.db

read_lef $STDCELL_LEF_FILE
#read_gds $STDCELL_GDS_FILE -layer_map $GDSOUT_MAP_FILE

set_attribute [get_lib_cells $FILLER_CELLS] design_type filler

check_workspace -allow_missing
commit_workspace -output ${NDM_PATH}/stdcell.ndm -force
remove_workspace

## PHYSICAL ONLY STDCELLS
create_workspace stdcell_physical_only -technology $TECH_FILE -flow physical_only
read_lef $STDCELL_LEF_FILE
set_attribute [get_lib_cells $FILLER_CELLS] design_type filler
check_workspace
commit_workspace -output ${NDM_PATH}/stdcell_physical_only.ndm -force
remove_workspace

## IO
create_workspace io -technology $TECH_FILE -flow normal
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name maxTLU -tlup $PARASITICS_MAX_TLUPLUS_FILE
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name nomTLU -tlup $PARASITICS_NOM_TLUPLUS_FILE
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name minTLU -tlup $PARASITICS_MIN_TLUPLUS_FILE
## for europractice miniasic, core and io voltages should be 1.2V&2.5V
## so 1 ones should be selected for operating conditions
## BCCOM1
read_db ${IO_DB_PREFIX}bc1.db

## LTCOM1
read_db ${IO_DB_PREFIX}lt1.db

## MLCOM1
read_db ${IO_DB_PREFIX}ml1.db

## NCCOM1
read_db ${IO_DB_PREFIX}tc1.db

## WCCOM1
read_db ${IO_DB_PREFIX}wc1.db

## WCLCOM1
read_db ${IO_DB_PREFIX}wcl1.db

## WCZCOM1
read_db ${IO_DB_PREFIX}wcz1.db

read_lef $IO_LEF_FILE
#read_gds $IO_GDS_FILE -layer_map $GDSOUT_MAP_FILE
check_workspace
commit_workspace -output ${NDM_PATH}/io.ndm -force
remove_workspace

## PHYSICAL ONLY IO
create_workspace io_physical_only -technology $TECH_FILE -flow physical_only
read_lef $IO_LEF_FILE
check_workspace
commit_workspace -output ${NDM_PATH}/io_physical_only.ndm -force
remove_workspace

## WB BONDPAD
#create_workspace wb_bondpad -technology $TECH_FILE -flow physical_only
#read_lef $WB_BONDPAD_LEF_FILE
#read_gds $WB_BONDPAD_GDS_FILE -layer_map $GDSOUT_MAP_FILE
#check_workspace
#commit_workspace -output ${NDM_PATH}/wb_bondpad.ndm -force
#remove_workspace

## CUP BONDPAD
create_workspace bondpad -technology $TECH_FILE -flow physical_only
read_lef $BONDPAD_LEF_FILE
read_gds $BONDPAD_GDS_FILE -layer_map $GDSOUT_MAP_FILE
check_workspace
commit_workspace -output ${NDM_PATH}/bondpad.ndm -force
remove_workspace

## SEALRING
create_workspace sealring -technology $TECH_FILE -flow physical_only
#read_gds $SEALRING_WLCSP_GDS_FILE -layer_map $GDSOUT_MAP_FILE
read_gds $SEALRING_GDS_FILE -layer_map $GDSOUT_MAP_FILE
check_workspace
commit_workspace -output ${NDM_PATH}/sealring.ndm -force
remove_workspace

#set ICC_SHELL_EXEC "/usr/synopsys/icc/V-2023.12-SP1/bin/icc_shell"
#set_app_options -name lib.setting.icc_shell_exec -value "$ICC_SHELL_EXEC -shared_license"
#
#generate_frame_from_mw ${NDM_PATH}/stdcell_mw.frame -mw_lib $STD_MILKYWAY -overwrite
#generate_frame_from_mw ${NDM_PATH}/io_mw.frame -mw_lib $IO_MILKYWAY -overwrite
#generate_frame_from_mw ${NDM_PATH}/bondpad_mw.frame -mw_lib $BONDPAD_MILKYWAY -overwrite
