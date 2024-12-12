create_clock -name clk_i -period 10 [get_ports {clk_i}]

#set_dont_touch_network      [all_clocks]
#set_fix_hold                [all_clocks]
set_clock_uncertainty  0.1  [all_clocks]
set_clock_latency      1.0  [all_clocks]

set_input_transition 0.2 [all_inputs]

set_input_delay  -max 1.0 -clock $CLK [remove_from_collection [all_inputs] [get_ports {$CLK}]]
set_input_delay  -min 0.0 -clock $CLK [remove_from_collection [all_inputs] [get_ports {$CLK}]]
set_output_delay -max 1.0 -clock $CLK [all_outputs]
set_output_delay -min 0.0 -clock $CLK [all_outputs]

#set_input_delay -clock [get_clocks clk_i] -max 1 [all_inputs] 
#set_input_delay -clock [get_clocks clk_i] -min 0 [all_inputs]
#set_output_delay -clock [get_clocks clk_i] -max 1 [all_outputs]
#set_output_delay -clock [get_clocks clk_i] -min 0 [all_outputs]

set_load  0.012 [all_outputs]
#set_max_fanout 6 [all_inputs]

#set_input_delay -clock [get_clocks clk_i] 0.015 [all_inputs] 
#set_input_delay -clock [get_clocks clk_i] -min 0.5 [all_inputs]

#set_output_delay -clock [get_clocks clk_i] 0.015 [all_outputs]
#set_output_delay -clock [get_clocks clk_i] -min 0.5 [all_outputs]
