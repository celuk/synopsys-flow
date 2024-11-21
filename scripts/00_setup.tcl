set TOP_MODULE "c0_soc"
set DESIGN_NAME "${TOP_MODULE}"
set DESIGN_LIBRARY ${DESIGN_NAME}.nlib

set OUTPUTS_DIR "outputs"
set REPORTS_DIR "reports"
set LOGS_DIR "logs"

set_host_options -max_cores 8

set ICV_HOME_DIR "/usr/synopsys/icvalidator/V-2023.12"
set ICVWB_HOME_DIR "/usr/synopsys/icv_workbench/V-2023.09-SP1/bin"
set ICV_EXEC_PATH "${ICV_HOME_DIR}/bin"
set ICVWB_EXEC_PATH "${ICVWB_HOME_DIR}/bin"

set ::env(ICV_HOME_DIR) $ICV_HOME_DIR
set ::env(ICVWB_HOME_DIR) $ICVWB_HOME_DIR
set ::env(PATH) "$ICV_EXEC_PATH:$env(PATH)"
set ::env(PATH) "$ICVWB_EXEC_PATH:$env(PATH)"
set ::env(ICV_INCLUDES) "${ICV_HOME_DIR}/include"

set GATE_LEVEL_VERILOG ${OUTPUTS_DIR}/${TOP_MODULE}_gate_level.v

## needed by icv lvs runset
#set SAED32_PATH "/run/media/ananas/ext/SAED32_EDK_03312022/SAED32_EDK"
#sh export SAED32_PATH=$SAED32_PATH

#set_app_options -name search_path -value "."
set search_path "."
set NDM_PATH "data/lib"
set RTL_PATH "data/rtl"
set SDC_PATH "data/sdc"
set UPF_PATH "data/upf"
set TECH_PATH "data/tech"
set STARRC_PATH "data/starrc"
set LOGO_PATH "data/logo"

lappend search_path $NDM_PATH
lappend search_path $RTL_PATH
lappend search_path $SDC_PATH
lappend search_path $UPF_PATH
lappend search_path $TECH_PATH
lappend search_path $STARRC_PATH
lappend search_path $LOGO_PATH

source scripts/00_pdk_setup.tcl

set REFERENCE_LIBRARY [list \
${NDM_PATH}/stdcell.ndm \
${NDM_PATH}/stdcell_physical_only.ndm \
\
${NDM_PATH}/io.ndm \
${NDM_PATH}/io_physical_only.ndm \
\
${NDM_PATH}/bondpad.ndm \
];

#${NDM_PATH}/stdcell_lvl.ndm \
#${NDM_PATH}/sealring.ndm \

set LOGO_FILE "${LOGO_PATH}/kasirga_logo.bmp"

set UPF_FILE "${UPF_PATH}/c0_soc.upf"

set CONSTRAINT_FILE "${SDC_PATH}/${DESIGN_NAME}.sdc"

set UPF_FILE "${UPF_PATH}/${DESIGN_NAME}.upf"

set STARRC_CONFIG_FILE "${STARRC_PATH}/${TOP_MODULE}.starrc.cfg"
set STARRC_MAPPING_FILE "${STARRC_PATH}/${TOP_MODULE}.starrc.mapping"

set STREAMOUT_GDS_FILE "${OUTPUTS_DIR}/${DESIGN_NAME}.gds"
set STREAMOUT_DEF_FILE "${OUTPUTS_DIR}/${DESIGN_NAME}.def"
set STREAMOUT_SDF_FILE "${OUTPUTS_DIR}/${DESIGN_NAME}.sdf"
set STREAMOUT_PARASITICS_FILE "${OUTPUTS_DIR}/${DESIGN_NAME}.spef"

$SEALRING_WLCSP_GDS_FILE \

## report_lib $STDCELL_LIB_NAME
set STDCELL_LIB_NAME "stdcell"
set IO_LIB_NAME "io"

## can also be used in library creation with
## create_workspace -scale_factor 1000
## command
set STREAMOUT_RESOLUTION 1000

set CLK clk_i

set POWER_NET "VDD"
set GROUND_NET "VSS"

set MIN_ROUTING_LAYER "M4"
set MAX_ROUTING_LAYER "M7"

set ROUTING_LAYER_DIRECTION_OFFSET_LIST [list \
{M1 horizontal 0} \
{M2 vertical 0} \
{M3 horizontal 0} \
{M4 vertical 0} \
{M5 horizontal 0} \
{M6 vertical 0} \
{M7 horizontal 0} \
{M8 vertical 0} \
{M9 horizontal 0} \
{AP vertical 0} \
];
# {M1 horizontal 0} \
# {M2 vertical 0} \
# {M9 horizontal 0} \

#set IO_PAD_FILLER_CELLS $ALL_IO_PAD_FILLER_CELLS

set MAX_TRANSITION 0.5
set MAX_FANOUT 20

# timing|leakage_power|total_power
set QOR_STRATEGY_METRIC "timing"
# balanced|extreme_power|early_design
set QOR_STRATEGY_MODE "balanced"

set SIGNOFF_METAL_FILL_FOLDER "signoff_fill_run"
set SIGNOFF_CHECK_DRC_FOLDER "signoff_check_drc_run"
set SIGNOFF_FIX_DRC_FOLDER "signoff_fix_drc_run"
set SIGNOFF_CHECK_ANTENNA_DRC_FOLDER "signoff_check_antenna_drc_run"
set SIGNOFF_CHECK_MIM_ANTENNA_DRC_FOLDER "signoff_check_mim_antenna_drc_run"
set SIGNOFF_CHECK_LVS_FOLDER "signoff_check_lvs_run"
set SIGNOFF_FIX_LVS_FOLDER "signoff_fix_lvs_run"

## borrowed from: https://wiki.tcl-lang.org/page/recursive%5Fglob
proc rglob {dirlist globlist} {
    set result {}
    set recurse {}
    foreach dir $dirlist {
        if ![file isdirectory $dir] {
            return -code error "'$dir' is not a directory"
        }
        foreach pattern $globlist {
            lappend result {*}[glob -nocomplain -directory $dir -- $pattern]
        }
        foreach file [glob -nocomplain -directory $dir -- *] {
            set file [file join $dir $file]
            if [file isdirectory $file] {
                set fileTail [file tail $file]
                if {!($fileTail eq "." || $fileTail eq "..")} {
                    lappend recurse $file
                }
            }
        }
    }
    if {[llength $recurse] > 0} {
        lappend result {*}[rglob $recurse $globlist]
    }
    return $result
}

set VERILOG_FILES [rglob data/rtl/ *]

set SYNTH_BLOCK 01-synthesize
set INIT_BLOCK 02-init_design
set COMPILE_BLOCK 03-compile
set DPLAN_BLOCK 04-design_planning
set PLACE_BLOCK 05-placement
set CTS_BLOCK 06-cts
set CTS_OPT_BLOCK 07-cts_opt
set ROUTE_BLOCK 08-route_auto
set ROUTE_OPT_BLOCK 09-route_opt
set SEXTRACT_BLOCK 10-signoff_extraction
set SOPT_BLOCK 11-signoff_opt
set SMFILL_BLOCK 12-signoff_metal_fill
set SDRC_BLOCK 13-signoff_drc
set SLVS_BLOCK 14-signoff_lvs
set STREAMOUT_BLOCK 15-streamout

if { ![file exists $OUTPUTS_DIR] } {
    file mkdir $OUTPUTS_DIR
}
if { ![file exists $REPORTS_DIR] } {
    file mkdir $REPORTS_DIR
}
if { ![file exists $LOGS_DIR] } {
    file mkdir $LOGS_DIR
}

set counter 1

foreach block {
    SYNTH_BLOCK
    INIT_BLOCK
    COMPILE_BLOCK
    DPLAN_BLOCK
    PLACE_BLOCK
    CTS_BLOCK
    CTS_OPT_BLOCK
    ROUTE_BLOCK
    ROUTE_OPT_BLOCK
    SEXTRACT_BLOCK
    SOPT_BLOCK
    SMFILL_BLOCK
    SDRC_BLOCK
    SLVS_BLOCK
    STREAMOUT_BLOCK
} {
    set block_name [set $block]
    set padded_counter [format "%02d" $counter]
    if { ![file exists $REPORTS_DIR/${padded_counter}_$block_name] } {
        file mkdir $REPORTS_DIR/${padded_counter}_$block_name
    }
    incr counter
}

set_svf -off

#if {[file exists $DESIGN_LIBRARY]} {
#    file delete -force $DESIGN_LIBRARY
#}

#set_app_var search_path "scripts"

##exit

set_app_options -name design.enable_lib_cell_editing -value "mutable"
set_attribute [get_lib_cells */*FILL*] design_type filler
#get_attribute [lindex $NON_METAL_FILLER_CELLS 0] design_type

#set_attribute [get_site_defs unit] symmetry Y
#set_attribute [get_site_defs unit] is_default true
