create_clock -name clk_i -period 20 [get_ports {clk_i}]
set_load 0.012 [all_outputs]
set_clock_uncertainty -setup 0.5 [get_clocks clk_i]
#set_clock_uncertainty -hold 0.02 [get_clocks clk_i]
set_clock_transition 0.1 [get_clocks clk_i]
set_input_transition -rise 0.5 [all_inputs -exclude_clock_ports]
set_input_transition -fall 0.5 [all_inputs -exclude_clock_ports]
set_input_delay -clock clk_i 5 [all_inputs]
set_output_delay -clock clk_i 5 [all_outputs]
set_max_transition 0.7 [all_outputs]
set_max_fanout 4 [all_inputs]

#set_false_path -to c0_top_inst/user_processor_dut/isl_blksiz/cek/getir_dut/ps_reg[18]/D

#set_dont_touch_network      [all_clocks]
#set_fix_hold                [all_clocks]
#set_clock_uncertainty  0.1  [all_clocks]
#set_clock_latency      1.0  [all_clocks]

#set_input_transition 0.2 [all_inputs]

#set_input_delay  -max 5.0 -clock clk_i [remove_from_collection [all_inputs] [get_ports {clk_i}]]
#set_input_delay  -min 0.0 -clock clk_i [remove_from_collection [all_inputs] [get_ports {clk_i}]]

#set_input_delay  -max 2.0 -clock clk_i [all_inputs]
#set_input_delay  -min 1.0 -clock clk_i [all_inputs]
#set_output_delay -max 2.0 -clock clk_i [all_outputs]
#set_output_delay -min 1.0 -clock clk_i [all_outputs]

#set_input_delay -clock [get_clocks clk_i] -max 1 [all_inputs] 
#set_input_delay -clock [get_clocks clk_i] -min 0 [all_inputs]
#set_output_delay -clock [get_clocks clk_i] -max 1 [all_outputs]
#set_output_delay -clock [get_clocks clk_i] -min 0 [all_outputs]

#set_false_path -to [get_pins c0_top_inst/user_processor_dut/isl_blksiz/buyruk_onbellegi_denetleyici_dut/iomem_addr_reg*/D]
#set_false_path -to [get_pins c0_top_inst/user_processor_dut/isl_blksiz/buyruk_onbellegi_denetleyici_dut/l1b_bekle_o_reg*/D]
#set_false_path -to [get_pins c0_top_inst/user_processor_dut/isl_blksiz/buyruk_onbellegi_denetleyici_dut/iomem_valid_reg*/D]

#set_input_delay -clock [get_clocks clk_i] 0.015 [all_inputs] 
#set_input_delay -clock [get_clocks clk_i] -min 0.5 [all_inputs]

#set_output_delay -clock [get_clocks clk_i] 0.015 [all_outputs]
#set_output_delay -clock [get_clocks clk_i] -min 0.5 [all_outputs]
