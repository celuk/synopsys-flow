set_units -capacitance 1.0pF
set_units -time 1.0ns
create_clock clk_i -period 10
set_input_transition 1 [all_inputs]
