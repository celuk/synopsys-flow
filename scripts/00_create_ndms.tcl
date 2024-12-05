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
### BC1D11D1COM
#read_db ${STDCELL_DB_PREFIX}bc1d11d1.db
### BC1D11D32COM
#read_db ${STDCELL_DB_PREFIX}bc1d11d32.db
### BC1D1COM
#read_db ${STDCELL_DB_PREFIX}bc1d1.db
### BC1D321D1COM
#read_db ${STDCELL_DB_PREFIX}bc1d321d1.db
### BC1D321D32COM
#read_db ${STDCELL_DB_PREFIX}bc1d321d32.db
## BCCOM
read_db ${STDCELL_DB_PREFIX}bc.db

### LT1D11D1COM
#read_db ${STDCELL_DB_PREFIX}lt1d11d1.db
### LT1D11D32COM
#read_db ${STDCELL_DB_PREFIX}lt1d11d32.db
### LT1D1COM
#read_db ${STDCELL_DB_PREFIX}lt1d1.db
### LT1D321D1COM
#read_db ${STDCELL_DB_PREFIX}lt1d321d1.db
### LT1D321D32COM
#read_db ${STDCELL_DB_PREFIX}lt1d321d32.db
## LTCOM
read_db ${STDCELL_DB_PREFIX}lt.db

### ML1D11D1COM
#read_db ${STDCELL_DB_PREFIX}ml1d11d1.db
### ML1D11D32COM
#read_db ${STDCELL_DB_PREFIX}ml1d11d32.db
### ML1D1COM
#read_db ${STDCELL_DB_PREFIX}ml1d1.db
### ML1D321D1COM
#read_db ${STDCELL_DB_PREFIX}ml1d321d1.db
### ML1D321D32COM
#read_db ${STDCELL_DB_PREFIX}ml1d321d32.db
## MLCOM
read_db ${STDCELL_DB_PREFIX}ml.db

### NC1D01D0COM
#read_db ${STDCELL_DB_PREFIX}tc1d01d0.db
### NC1D01D2COM
#read_db ${STDCELL_DB_PREFIX}tc1d01d2.db
### NC1D0COM
#read_db ${STDCELL_DB_PREFIX}tc1d0.db
### NC1D21D0COM
#read_db ${STDCELL_DB_PREFIX}tc1d21d0.db
### NC1D21D2COM
#read_db ${STDCELL_DB_PREFIX}tc1d21d2.db
## NCCOM
read_db ${STDCELL_DB_PREFIX}tc.db

### WC0D90D9COM
#read_db ${STDCELL_DB_PREFIX}wc0d90d9.db
### WC0D91D08COM
#read_db ${STDCELL_DB_PREFIX}wc0d91d08.db
### WC0D9COM
#read_db ${STDCELL_DB_PREFIX}wc0d9.db
### WC1D080D9COM
#read_db ${STDCELL_DB_PREFIX}wc1d080d9.db
### WC1D081D08COM
#read_db ${STDCELL_DB_PREFIX}wc1d081d08.db
## WCCOM
read_db ${STDCELL_DB_PREFIX}wc.db

### WCL0D90D9COM
#read_db ${STDCELL_DB_PREFIX}wcl0d90d9.db
### WCL0D91D08COM
#read_db ${STDCELL_DB_PREFIX}wcl0d91d08.db
### WCL0D9COM
#read_db ${STDCELL_DB_PREFIX}wcl0d9.db
### WCL1D080D9COM
#read_db ${STDCELL_DB_PREFIX}wcl1d080d9.db
### WCL1D081D08COM
#read_db ${STDCELL_DB_PREFIX}wcl1d081d08.db
## WCLCOM
read_db ${STDCELL_DB_PREFIX}wcl.db

### WCZ0D90D9COM
#read_db ${STDCELL_DB_PREFIX}wcz0d90d9.db
### WCZ0D91D08COM
#read_db ${STDCELL_DB_PREFIX}wcz0d91d08.db
### WCZ0D9COM
#read_db ${STDCELL_DB_PREFIX}wcz0d9.db
### WCZ1D080D9COM
#read_db ${STDCELL_DB_PREFIX}wcz1d080d9.db
### WCZ1D081D08COM
#read_db ${STDCELL_DB_PREFIX}wcz1d081d08.db
## WCZCOM
read_db ${STDCELL_DB_PREFIX}wcz.db

read_lef $STDCELL_LEF_FILE
#read_gds $STDCELL_GDS_FILE -layer_map $GDSOUT_MAP_FILE
check_workspace -allow_missing
commit_workspace -output ${NDM_PATH}/stdcell.ndm -force
remove_workspace

## PHYSICAL ONLY STDCELLS
create_workspace stdcell_physical_only -technology $TECH_FILE -flow physical_only
read_lef $STDCELL_LEF_FILE
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
### BCCOM2
#read_db ${IO_DB_PREFIX}bc2.db
### BCCOM3
#read_db ${IO_DB_PREFIX}bc3.db
### BCCOM4
#read_db ${IO_DB_PREFIX}bc4.db
### BCCOM5
#read_db ${IO_DB_PREFIX}bc5.db
### BCCOM
#read_db ${IO_DB_PREFIX}bc.db

## LTCOM1
read_db ${IO_DB_PREFIX}lt1.db
### LTCOM2
#read_db ${IO_DB_PREFIX}lt2.db
### LTCOM3
#read_db ${IO_DB_PREFIX}lt3.db
### LTCOM4
#read_db ${IO_DB_PREFIX}lt4.db
### LTCOM5
#read_db ${IO_DB_PREFIX}lt5.db
### LTCOM
#read_db ${IO_DB_PREFIX}lt.db

## MLCOM1
read_db ${IO_DB_PREFIX}ml1.db
### MLCOM2
#read_db ${IO_DB_PREFIX}ml2.db
### MLCOM3
#read_db ${IO_DB_PREFIX}ml3.db
### MLCOM4
#read_db ${IO_DB_PREFIX}ml4.db
### MLCOM5
#read_db ${IO_DB_PREFIX}ml5.db
### MLCOM
#read_db ${IO_DB_PREFIX}ml.db

## NCCOM1
read_db ${IO_DB_PREFIX}tc1.db
### NCCOM2
#read_db ${IO_DB_PREFIX}tc2.db
### NCCOM3
#read_db ${IO_DB_PREFIX}tc3.db
### NCCOM4
#read_db ${IO_DB_PREFIX}tc4.db
### NCCOM5
#read_db ${IO_DB_PREFIX}tc5.db
### NCCOM
#read_db ${IO_DB_PREFIX}tc.db

## WCCOM1
read_db ${IO_DB_PREFIX}wc1.db
### WCCOM2
#read_db ${IO_DB_PREFIX}wc2.db
### WCCOM3
#read_db ${IO_DB_PREFIX}wc3.db
### WCCOM4
#read_db ${IO_DB_PREFIX}wc4.db
### WCCOM5
#read_db ${IO_DB_PREFIX}wc5.db
### WCCOM
#read_db ${IO_DB_PREFIX}wc.db

## WCLCOM1
read_db ${IO_DB_PREFIX}wcl1.db
### WCLCOM2
#read_db ${IO_DB_PREFIX}wcl2.db
### WCLCOM3
#read_db ${IO_DB_PREFIX}wcl3.db
### WCLCOM4
#read_db ${IO_DB_PREFIX}wcl4.db
### WCLCOM5
#read_db ${IO_DB_PREFIX}wcl5.db
### WCLCOM
#read_db ${IO_DB_PREFIX}wcl.db

## WCZCOM1
read_db ${IO_DB_PREFIX}wcz1.db
### WCZCOM2
#read_db ${IO_DB_PREFIX}wcz2.db
### WCZCOM3
#read_db ${IO_DB_PREFIX}wcz3.db
### WCZCOM4
#read_db ${IO_DB_PREFIX}wcz4.db
### WCZCOM5
#read_db ${IO_DB_PREFIX}wcz5.db
### WCZCOM
#read_db ${IO_DB_PREFIX}wcz.db

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
#create_workspace sealring -technology $TECH_FILE -flow physical_only
#read_gds $SEALRING_WLCSP_GDS_FILE -layer_map $GDSOUT_MAP_FILE
#check_workspace
#commit_workspace -output ${NDM_PATH}/sealring.ndm -force
#remove_workspace
