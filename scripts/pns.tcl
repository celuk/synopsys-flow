remove_pg_via_master_rules -all
remove_pg_patterns -all
remove_pg_strategies -all
remove_pg_strategy_via_rules -all
remove_routes -ring -stripe -lib_cell_pin_connect -macro_pin_connect

connect_pg_net -automatic
connect_pg_net -net VDD [get_pins -hierarchical */VDD]
connect_pg_net -net VSS [get_pins -hierarchical */VSS]
connect_pg_net -net VDD [get_pins -physical_context */VDD]
connect_pg_net -net VSS [get_pins -physical_context */VSS]

create_pg_ring_pattern pg_ring -horizontal_layer M9 \
                               -horizontal_width {4} \
                               -horizontal_spacing {2} \
                               -vertical_layer M8 \
                               -vertical_width {4} \
                               -vertical_spacing {2}
# -corner_bridge true
set_pg_strategy s_core_ring -core -pattern {{pattern: pg_ring}{nets: {VDD VSS VDD VSS VDD VSS VDD VSS}}} \
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

set_app_options -name plan.pgroute.disable_via_creation -value true

#set iopads [get_cells -physical_context -filter {design_type == "pad" && (name =~ "*VDD_*" || name =~ "*VSS_*")} -quiet]
set iopads [get_cells -physical_context -filter "design_type==pad" -quiet]
create_pg_macro_conn_pattern macro_connect_pattern_vss \
-pin_conn_type scattered_pin -nets {VDD VSS} \
-layers {M2 M2}
set_pg_strategy s_macro_connect_vss \
-pattern {{name: macro_connect_pattern_vss} {nets: VDD VSS}} \
-macros "$iopads"
compile_pg -strategies s_macro_connect_vss

set_app_options -name plan.pgroute.disable_via_creation -value false

#set iopads [get_cells -physical_context -filter "design_type==pad" -quiet]
#create_pg_macro_conn_pattern macro_connect_pattern_vdd \
#-pin_conn_type scattered_pin -nets {VDD} \
#-layers {M2 M2}
#set_pg_strategy s_macro_connect_vdd \
#-pattern {{name: macro_connect_pattern_vdd} {nets: VDD}} \
#-macros "$iopads"
#compile_pg -strategies s_macro_connect_vdd

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
