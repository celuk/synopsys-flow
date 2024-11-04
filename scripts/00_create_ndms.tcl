#source scripts/00_setup.tcl

set LOGS_DIR "logs"
if { ![file exists $LOGS_DIR] } {
    file mkdir $LOGS_DIR
}

source scripts/00_pdk_setup.tcl

set TECH_PATH "data/tech"
set NDM_PATH "data/lib"

set EM_TECH_FILE ""

#set ANT_TCL_FILE ""
set ANT_TCL_FILE ""
set ANT_SCM_FILE ""

set_app_options -name file.gds.trace_terminal_type -value PG
set_app_options -list {file.gds.port_type_map {{power VDDPST} {power VDD} {ground VSS}}}

## STDCELLS
create_workspace stdcell -technology $TECH_FILE -flow normal
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name maxTLU -tlup $PARASITICS_MAX_TLUPLUS_FILE
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name nomTLU -tlup $PARASITICS_NOM_TLUPLUS_FILE
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name minTLU -tlup $PARASITICS_MIN_TLUPLUS_FILE
read_db ${STDCELL_DB_PREFIX}tc.db
read_db ${STDCELL_DB_PREFIX}bc.db
read_db ${STDCELL_DB_PREFIX}wc.db
read_lef $STDCELL_LEF_FILE
read_gds $STDCELL_GDS_FILE -layer_map $GDSOUT_MAP_FILE
check_workspace
commit_workspace -output ${NDM_PATH}/stdcell.ndm -force
remove_workspace
create_workspace stdcell_physical_only -technology $TECH_FILE -flow physical_only
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name maxTLU -tlup $PARASITICS_MAX_TLUPLUS_FILE
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name nomTLU -tlup $PARASITICS_NOM_TLUPLUS_FILE
read_parasitic_tech -layermap $PARASITICS_MAP_FILE -name minTLU -tlup $PARASITICS_MIN_TLUPLUS_FILE
read_db ${STDCELL_DB_PREFIX}tc.db
read_db ${STDCELL_DB_PREFIX}bc.db
read_db ${STDCELL_DB_PREFIX}wc.db
read_lef $STDCELL_LEF_FILE
read_gds $STDCELL_GDS_FILE -layer_map $GDSOUT_MAP_FILE
check_workspace
commit_workspace -output ${NDM_PATH}/stdcell_physical_only.ndm -force
remove_workspace

## IO
create_workspace io -technology $TECH_FILE -flow normal
read_db ${IO_DB_PREFIX}tc.db
read_db ${IO_DB_PREFIX}bc.db
read_db ${IO_DB_PREFIX}wc.db
read_lef $IO_LEF_FILE
read_gds $IO_GDS_FILE -layer_map $GDSOUT_MAP_FILE
check_workspace
commit_workspace -output ${NDM_PATH}/io.ndm -force
remove_workspace
create_workspace io_physical_only -technology $TECH_FILE -flow physical_only
read_db ${IO_DB_PREFIX}tc.db
read_db ${IO_DB_PREFIX}bc.db
read_db ${IO_DB_PREFIX}wc.db
read_lef $IO_LEF_FILE
read_gds $IO_GDS_FILE -layer_map $GDSOUT_MAP_FILE
check_workspace
commit_workspace -output ${NDM_PATH}/io_physical_only.ndm -force
remove_workspace

## BONDPAD
create_workspace wb_bondpad -technology $TECH_FILE -flow physical_only
read_lef $WB_BONDPAD_LEF_FILE
read_gds $WB_BONDPAD_GDS_FILE -layer_map $GDSOUT_MAP_FILE
check_workspace
commit_workspace -output ${NDM_PATH}/wb_bondpad.ndm -force
remove_workspace

## SEALRING
create_workspace sealring -technology $TECH_FILE -flow physical_only
read_gds $SEALRING_WLCSP_GDS_FILE -layer_map $GDSOUT_MAP_FILE
check_workspace
commit_workspace -output ${NDM_PATH}/sealring.ndm -force
remove_workspace

exit
