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
set SIGNOFF_METAL_DENSITY_REPORT_FOLDER "signoff_metal_density_report_run"
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

#set_app_options -name design.enable_lib_cell_editing -value "mutable"
## fill or filler ??
#set_attribute [get_lib_cells */*FILL*] design_type filler
#get_attribute [lindex $NON_METAL_FILLER_CELLS 0] design_type

#set_attribute [get_site_defs unit] symmetry Y
#set_attribute [get_site_defs unit] is_default true

proc set_design_options {} {
    global \
    MAX_ROUTING_LAYER \
    MIN_ROUTING_LAYER \
    CTS_LIB_CELL_PATTERNS \
    METAL_FILL_BEOL_RUNSET \
    METAL_FILL_FEOL_RUNSET \
    SIGNOFF_METAL_FILL_FOLDER \
    SIGNOFF_METAL_DENSITY_REPORT_FOLDER \
    DRC_RUNSET \
    SIGNOFF_CHECK_DRC_FOLDER \
    SIGNOFF_FIX_DRC_FOLDER \
    SIGNOFF_CHECK_ANTENNA_DRC_FOLDER \
    SIGNOFF_CHECK_MIM_ANTENNA_DRC_FOLDER \
    SIGNOFF_CHECK_LVS_FOLDER \
    SIGNOFF_FIX_LVS_FOLDER \
    GDS_FILES_TO_MERGE \
    GDSOUT_MAP_FILE

    set_app_options -name lib.setting.enable_via_region_override -value true
    
    #set_app_options -name mv.upf.enable_golden_upf -value true

    #set_app_options -name mv.incomplete_upf.enable -value true

    ## to create voltage area automatically, it should be false
    set_app_options -name mv.upf.enable_missing_voltage_area -value false

    set_dont_touch [get_cells {Corner* VDD* VSS* PDDW0204CDG*}]

    #set_app_options -name compile.auto_floorplan.enable -value true
    #set_app_option -name compile.auto_floorplan.initialize -value auto
    ##set_app_options -name compile.auto_floorplan.initialize -value true
    ##set_app_options -name compile.auto_floorplan.place_pins -value all
    #set_app_options -name compile.auto_floorplan.shape_voltage_areas -value all
    #set_auto_floorplan_constraints -side_length "1200 1200"
    #set_shaping_options -guard_band_size 10

    #create_boundary -coordinate {{0 0} {1000 1000}}
    #initialize_floorplan -control_type boundary -left_io2core 500 -bottom_io2core 500 -right_io2core 500 -top_io2core 500

    #create_io_guide -name "io_guide" -line {{100 100} 100} -side left
    #create_io_ring -name "ring_outer" -corner_height 100
    #create_io_ring -name "ring_inner" -inside "ring_outer" -corner_height 75

    #initialize_floorplan -control_type die -side_length "1000 1000" -core_offset 100

    set_app_options -name compile.auto_floorplan.enable -value true
    set_app_options -name compile.auto_floorplan.initialize -value auto
    set_app_options -name compile.auto_floorplan.place_pins -value all
    set_app_options -name compile.auto_floorplan.shape_voltage_areas -value all
    set_app_options -name compile.auto_floorplan.place_ios -value all
    #set_app_options -name compile.auto_floorplan.place_hard_macros -value true

    set_app_options -name place.coarse.continue_on_missing_scandef -value true

    #set_app_options -name place.coarse.congestion_driven_max_util -value 0.83
    #set_app_options -name place.coarse.pin_density_aware -value false
    #set_app_options -name place.coarse.enhanced_auto_density_control -value false
    #set_app_options -name compile.flow.high_effort_timing -value 0
    #set_app_options -name place.coarse.auto_timing_control -value false
    #set_app_options -name place.coarse.cong_restruct -value on
    #set_app_options -name place.coarse.cong_restruct_effort -value high
    #set_app_options -name place.coarse.cong_restruct_iterations -value 2

    #set_app_options -name plan.macro.macro_place_only -value true
    #set_app_options -name plan.macro.allow_unmapped_design -value true
    #create_placement -floorplan

    #set_shaping_options -guard_band_size 10
    #shape_blocks
    #connect_pg_net -automatic

    set_app_options -name opt.common.enable_via_ladder_insertion -value true

    set_app_options -name opt.port.eliminate_verilog_assign -value true

    #set_level_shifter LVLSHS_STD -domain PD_C0_SOC
    #set_level_shifter LVLSHS_IO -domain PD_C0_IO
    #map_level_shifter_cell LVLSHS_STD -domain PD_C0_SOC -lib_cells $STD_LEVEL_SHIFTER_CELLS
    #map_level_shifter_cell LVLSHS_IO -domain PD_C0_IO -lib_cells $IO_LEVEL_SHIFTER_CELLS
    #
    #set_isolation ISO_STD -domain PD_C0_SOC
    #set_isolation ISO_IO -domain PD_C0_IO
    #map_isolation_cell ISO_STD -domain PD_C0_SOC -lib_cells $STD_ISOLATION_CELLS
    #map_isolation_cell ISO_IO -domain PD_C0_IO -lib_cells $IO_ISOLATION_CELLS

    set_app_options -name compile.flow.enable_multibit -value true

    set_app_options -name compile.place.congestion_effort -value high
    set_app_options -name compile.final_place.effort -value high
    set_app_options -name compile.initial_place.buffering_aware -value true
    set_app_options -name route.global.export_soft_congestion_maps -value true
    set_app_options -name place.coarse.cong_restruct_iterations -value 3
    set_app_options -name place.coarse.auto_timing_control -value true
    set_app_options -name place.coarse.auto_density_control -value true
    set_app_options -name place.coarse.enhanced_auto_density_control -value true

    set_ignored_layers -min_routing_layer $MIN_ROUTING_LAYER
    set_ignored_layers -max_routing_layer $MAX_ROUTING_LAYER
    report_ignored_layers

    ## do not use stdcell main rail as supply, use VDDPST
    #set_app_options -global {mv.upf.ignore_ls_main_rail true}

    set_block_pin_constraints -self -allowed_layers {M3 M4}
    #-pin_spacing_distance 2

    #set_app_options -name route.common.connect_within_pins_by_layer_name -value { {M1 via_wire_all_pins} }

    set_app_options -name plan.pins.incremental -value true

    set_app_options -name plan.pgroute.treat_pad_as_macro -value true

    set_attribute -objects [get_nets VDDPST] -name net_type -value power
    set_attribute -objects [get_nets VDD] -name net_type -value power
    set_attribute -objects [get_nets VSS] -name net_type -value ground

    set_app_options -name plan.pgroute.honor_signal_route_drc -value true
    ## should it be true?
    set_app_options -name plan.pgroute.honor_std_cell_drc -value false
    set_app_options -name plan.pgroute.merge_shapes_for_via_creation -value true

    #set_app_options -name plan.pgroute.maximum_cell_gap_for_alignment_strap -value 0.0

    #set_app_options -name plan.pgroute.snap_stdcell_rail -value true

    ## disabling via creation at partial intersection
    set_app_option -name plan.pgroute.via_site_threshold -value 1

    ## merge metal shapes in specified pad cell types while performing DRC checks
    ## -value {io_pad corner_pad}
    set_app_option -name plan.pgroute.merge_shapes_in_pad_cell -value {io_pad}

    set_app_option -name plan.pgroute.auto_connect_pg_net -value true
    set_app_options -name plan.pgroute.via_array_size_control -value try_cuts_in_intersection

    set_app_options -name plan.pgroute.connect_user_route_shapes -value true

    set_app_options -name plan.pgroute.decide_rail_width_from_routing_area -value true

    #set_app_options -name plan.pgroute.maximize_total_cut_area -value all

    #set_app_options -name plan.pgroute.treat_multiple_pins_as_one_target -value true

    #set_app_options -name plan.pgroute.disable_stapling_via_fixing -value true
    #set_app_options -name plan.pgroute.discard_stackvia_with_drc -value true
    set_app_options -name plan.pgroute.fix_via_drc_multiple_viadef -value true

    set_app_options -name plan.pgroute.use_via_matrix -value true
    set_app_options -name plan.pgroute.use_shape_pattern -value true
    ## reduce memory during via drc checking
    set_app_options -name plan.pgroute.high_capacity_mode -value 1

    set_app_options -name plan.pgroute.verbose -value true

    set_app_options -name plan.pgroute.optimize_track_alignment -value true
    set_app_options -name plan.pgroute.derive_cut_net_from_pin -value true

    #set_app_options -name plan.pgroute.snap_stdcell_rail -value true

    #set_app_options -name plan.pgroute.treat_cell_type_as_macro -value "well_tap"

    #set_app_options -name plan.pgroute.hmpin_connection_target_layers -value D6

    #set_app_options -name place.coarse.congestion_driven_max_util -value 0.83
    #set_app_options -name place.coarse.pin_density_aware -value false
    #set_app_options -name place.coarse.enhanced_auto_density_control -value false
    #set_app_options -name compile.flow.high_effort_timing -value 0
    #set_app_options -name place.coarse.auto_timing_control -value false
    #set_app_options -name place.coarse.cong_restruct -value on
    #set_app_options -name place.coarse.cong_restruct_effort -value high
    #set_app_options -name place.coarse.cong_restruct_iterations -value 2

    set_app_options -name place.coarse.continue_on_missing_scandef -value true
    set_app_options -name place_opt.final_place.effort -value high
    set_app_options -name place_opt.place.congestion_effort -value high
    set_app_options -name opt.common.user_instance_name_prefix -value place_opt

    set_app_options -name opt.common.honor_lib_cell_purpose -value true
    set_dont_touch [get_lib_cells $CTS_LIB_CELL_PATTERNS] false
    # -include {optimization cts hold power} all
    set_lib_cell_purpose -include {optimization cts} [get_lib_cells $CTS_LIB_CELL_PATTERNS]
    set_app_options -name place.fix_hard_macros -value true

    set_app_options -name route.global.export_soft_congestion_maps -value true
    set_app_options -name place.coarse.cong_restruct_iterations -value 3

    set_lib_cell_purpose -include optimization [get_lib_cells */*TIE*]

    set_app_options -name opt.common.enable_via_ladder_insertion -value true
    set_app_options -name opt.common.enable_via_ladder_area_api -value true

    set_app_options -name opt.buffering.enable_advanced_buffering -value true
    set_app_options -name opt.common.enable_rde -value true

    set_app_options -name route.global.export_soft_congestion_maps -value true

    #set_app_options -name cts.common.max_fanout -value 100
    #set_app_options -name cts.compile.enable_cell_relocation -value timing_aware
    #set_app_options -name cts.compile.size_pre_existing_cell_to_cts_references -value true
    #set_app_options -name cts.common.user_instance_name_prefix -value clock_opt

    set_app_options -name route.detail.antenna -value true

    set_app_options -name opt.common.enable_via_ladder_insertion -value true
    set_app_options -name opt.common.enable_via_ladder_area_api -value true

    set_app_options -name time.si_enable_analysis -value true
    set_app_options -name time.enable_ccs_rcv_cap -value true

    set_app_options -name route.global.force_rerun_after_global_route_opt -value true
    set_app_options -name route.global.timing_driven -value true
    set_app_options -name route.track.timing_driven -value true
    set_app_options -name route.detail.timing_driven -value true
    set_app_options -name route.detail.force_max_number_iterations -value true

    #set_app_options -name route.common.connect_within_pins_by_layer_name -value {{M1 via_wire_standard_cell_pins} {M2 off} {M3 off} {M4 off} {M5 off} {M6 off} {M7 off} {M8 off} }
    set_app_options -name route.common.net_max_layer_mode -value allow_pin_connection
    set_app_options -name route.common.global_max_layer_mode -value allow_pin_connection
    #set_app_options -name route.common.net_min_layer_mode -value soft
    set_app_options -name route.common.global_min_layer_mode -value allow_pin_connection
    #set_app_options -name route.common.number_of_vias_under_net_min_layer -value 5
    #set_app_options -name route.common.number_of_vias_over_net_max_layer -value 5
    #set_app_options -name route.common.number_of_vias_over_global_max_layer -value 5
    #set_app_options -name route.common.rotate_default_vias -value false
    #set_app_options -name route.common.route_top_boundary_mode -value stay_half_min_space_inside
    #set_app_options -name route.common.shielding_nets -value {}
    #set_app_options -name route.common.soft_rule_weight_to_effort_level_map -value {}
    #set_app_options -name route.common.threshold_noise_ratio -value 0.20
    #set_app_options -name route.common.via_array_mode -value off

    set_app_options -name opt.buffering.enable_advanced_buffering -value true
    set_app_options -name opt.common.enable_rde -value true

    set_app_options -name route.global.export_soft_congestion_maps -value true

    #set_app_options -name route.detail.antenna -value true
    ## hop_layers | use_diodes
    #set_app_options -name route.detail.antenna_fixing_preference -value use_diodes

    set_app_options -name signoff.create_metal_fill.runset -value $METAL_FILL_BEOL_RUNSET
    set_app_options -name signoff.create_metal_fill.base_layer_runset -value $METAL_FILL_FEOL_RUNSET
    set_app_options -name signoff.create_metal_fill.fix_density_errors -value true
    set_app_options -name signoff.create_metal_fill.run_dir -value $SIGNOFF_METAL_FILL_FOLDER
    #set_app_options -name signoff.create_metal_fill.user_defined_options -value "-64"
    # -D USE_ICC2 -dp8 -turbo
    set_app_options -name signoff.physical.merge_stream_files -value $GDS_FILES_TO_MERGE
    set_app_options -name signoff.physical.layer_map_file -value $GDSOUT_MAP_FILE
    set_app_options -name signoff.report_metal_density.run_dir -value $SIGNOFF_METAL_DENSITY_REPORT_FOLDER
    set_app_options -name signoff.report_metal_density.create_heat_maps -value true

    #set_app_options -name signoff.check_drc.runset -value $LVS_RUNSET
    #set_app_options -name signoff.check_drc.run_dir -value "z_lvs_run"

    #set_app_options -name signoff.check_drc.runset -value $LVS_RUNSET
    #set_app_options -name signoff.check_drc.run_dir -value $SIGNOFF_CHECK_LVS_FOLDER
    #set_app_options -name signoff.fix_drc.init_drc_error_db -value $SIGNOFF_CHECK_LVS_FOLDER
    #set_app_options -name signoff.fix_drc.run_dir -value $SIGNOFF_FIX_LVS_FOLDER

    #set_app_options -name signoff.check_design.max_errors_per_rule -value 6000
    #set_app_options -global {signoff.check_design.runset $LVS_RUNSET}

    set_app_options -name signoff.check_drc.runset -value $DRC_RUNSET
    set_app_options -name signoff.check_drc.run_dir -value $SIGNOFF_CHECK_DRC_FOLDER
    set_app_options -name signoff.check_drc.fill_view_data -value read
    ## View --> Map --> ICV Heatmap
    set_app_options -name signoff.check_drc.enable_icv_explorer_mode -value true
    set_app_options -name signoff.fix_drc.init_drc_error_db -value $SIGNOFF_CHECK_DRC_FOLDER
    set_app_options -name signoff.fix_drc.run_dir -value $SIGNOFF_FIX_DRC_FOLDER
    set_app_options -name signoff.physical.layer_map_file -value $GDSOUT_MAP_FILE
    set_app_options -name signoff.physical.merge_stream_files -value $GDS_FILES_TO_MERGE
    #set_app_options -name signoff.check_drc.user_defined_options -value "-D DENSITY_LAY"
    set_app_options -name signoff.create_pg_augmentation.power_net_name -value "VDD"
    set_app_options -name signoff.create_pg_augmentation.ground_net_name -value "VSS"
    set_app_options -name signoff.check_drc_live.runset -value $DRC_RUNSET
    set_app_options -name signoff.check_drc_live.exclude_command_class -value {{density false} {connectivity false}}
}
