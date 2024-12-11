module c0_soc(
    input clk_i,
    input rstn_i,
    input [1:0] d_i,
    output [0:1] seg_o
    );

    wire clk;
    wire rstn;
    wire [1:0] d;
    wire [0:1] seg;
    
    SEALRING_1KX1K SealRing();

    PCORNER CornerCell1();
    PCORNER CornerCell2();
    PCORNER CornerCell3();
    PCORNER CornerCell4();
 
    PVDD2POC VDD2POC ( .VDDPST() );

    PVDD2CDG VDDPST_0 ( .VDDPST() );
    PVDD2CDG VDDPST_1 ( .VDDPST() );
    PVDD2CDG VDDPST_2 ( .VDDPST() );
    PVDD2CDG VDDPST_3 ( .VDDPST() );
    PVDD2CDG VDDPST_4 ( .VDDPST() );
 
    PVDD1CDG VDD_0 ( .VDD() );
    PVDD1CDG VDD_1 ( .VDD() );
    PVDD1CDG VDD_2 ( .VDD() );
    PVDD1CDG VDD_3 ( .VDD() );
    PVDD1CDG VDD_4 ( .VDD() );
    PVDD1CDG VDD_5 ( .VDD() );
    PVDD1CDG VDD_6 ( .VDD() );
    PVDD1CDG VDD_7 ( .VDD() );
 
    PVSS3CDG VSS_0 ( .VSS() );
    PVSS3CDG VSS_1 ( .VSS() );
    PVSS3CDG VSS_2 ( .VSS() );
    PVSS3CDG VSS_3 ( .VSS() );
    PVSS3CDG VSS_4 ( .VSS() );
    PVSS3CDG VSS_5 ( .VSS() );
    PVSS3CDG VSS_6 ( .VSS() );
    PVSS3CDG VSS_7 ( .VSS() );

    PDDW0204CDG PDDW0204CDG_IN_CLK(.OEN(1'b1),.I(1'b0),.PAD(clk_i),.C(clk),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    
    PDDW0204CDG PDDW0204CDG_IN_RSTN(.OEN(1'b1),.I(1'b0),.PAD(rstn_i),.C(rstn),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    
    PDDW0204CDG PDDW0204CDG_IN0(.OEN(1'b1),.I(1'b0),.PAD(d_i[0]),.C(d[0]),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    PDDW0204CDG PDDW0204CDG_IN1(.OEN(1'b1),.I(1'b0),.PAD(d_i[1]),.C(d[1]),.DS(1'b0),.PE(1'b0),.IE(1'b1));

    PDDW0204CDG PDDW0204CDG_OUT0(.OEN(1'b0),.I(seg[0]),.PAD(seg_o[0]),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0204CDG PDDW0204CDG_OUT1(.OEN(1'b0),.I(seg[1]),.PAD(seg_o[1]),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));

    c0_top c0_top_inst(
        .clk(clk),
        .rstn(rstn),
        .d(d),
        .seg(seg)
    );

endmodule
