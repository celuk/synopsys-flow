module c0_soc(
    input clk_i,
    input rstn_i,
    input wire [3:0] d_i,
    output reg [0:6] seg_o
    );

    PCORNER CornerCell1();
    PCORNER CornerCell2();
    PCORNER CornerCell3();
    PCORNER CornerCell4();

    //PVDD2POC VDD2POC ( .VDDPST() );
    //PVDD2CDG VDDPST_0 ( .VDDPST() );
    //PVDD2CDG VDDPST_1 ( .VDDPST() );
    PVDD1CDG VDD_0 ( .VDD() );
    PVDD1CDG VDD_1 ( .VDD() );
    PVSS3CDG VSS3_0 ( .VSS() );
    PVSS3CDG VSS3_1 ( .VSS() );

    wire clk;
    PDDW0204CDG PDDW0204CDG_IN_CLK(.OEN(1'b1),.I(1'b0),.PAD(clk_i),.C(clk),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    
    wire rstn;
    PDDW0204CDG PDDW0204CDG_RSTN(.OEN(1'b1),.I(1'b0),.PAD(rstn_i),.C(rstn),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    
    wire [3:0] d;
    PDDW0204CDG PDDW0204CDG_IN0(.OEN(1'b1),.I(1'b0),.PAD(d_i[0]),.C(d[0]),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    PDDW0204CDG PDDW0204CDG_IN1(.OEN(1'b1),.I(1'b0),.PAD(d_i[1]),.C(d[1]),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    PDDW0204CDG PDDW0204CDG_IN2(.OEN(1'b1),.I(1'b0),.PAD(d_i[2]),.C(d[2]),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    PDDW0204CDG PDDW0204CDG_IN3(.OEN(1'b1),.I(1'b0),.PAD(d_i[3]),.C(d[3]),.DS(1'b0),.PE(1'b0),.IE(1'b1));

    reg [0:6] seg;
    PDDW0204CDG PDDW0204CDG_OUT0(.OEN(1'b0),.I(seg[0]),.PAD(seg_o[0]),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0204CDG PDDW0204CDG_OUT1(.OEN(1'b0),.I(seg[1]),.PAD(seg_o[1]),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0204CDG PDDW0204CDG_OUT2(.OEN(1'b0),.I(seg[2]),.PAD(seg_o[2]),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0204CDG PDDW0204CDG_OUT3(.OEN(1'b0),.I(seg[3]),.PAD(seg_o[3]),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0204CDG PDDW0204CDG_OUT4(.OEN(1'b0),.I(seg[4]),.PAD(seg_o[4]),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0204CDG PDDW0204CDG_OUT5(.OEN(1'b0),.I(seg[5]),.PAD(seg_o[5]),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0204CDG PDDW0204CDG_OUT6(.OEN(1'b0),.I(seg[6]),.PAD(seg_o[6]),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));

    always @(posedge clk) begin
        if(!rstn) begin
            seg <= 0;
        end
        else begin
            case (d)
            4'h0: seg <= 7'b0000001;
            4'h1: seg <= 7'b1001111;
            4'h2: seg <= 7'b0010010;
            4'h3: seg <= 7'b0000110;
            4'h4: seg <= 7'b1001100;
            4'h5: seg <= 7'b0100100;
            4'h6: seg <= 7'b0100000;
            4'h7: seg <= 7'b0001111;
            4'h8: seg <= 7'b0000000;
            4'h9: seg <= 7'b0000100;
            default: seg <= 7'b1111110;
            endcase
        end
    end
endmodule
