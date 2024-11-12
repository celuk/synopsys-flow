module c0_soc(
    input clk_i,
    input rstn_i,
    input [3:0] d_i,
    output [0:6] seg_o
    );

    wire clk;
    wire rstn;
    wire [3:0] d;
    wire [0:6] seg;
    c0_io c0_io_inst(
        .clk_i(clk_i),
        .clk(clk),
        .rstn_i(rstn_i),
        .rstn(rstn),
        .d_i(d_i),
        .d(d),
        .seg_o(seg_o),
        .seg(seg)
    );

    c0_top c0_top_inst(
        .clk(clk),
        .rstn(rstn),
        .d(d),
        .seg(seg)
    );

endmodule
