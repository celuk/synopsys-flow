// This file is part of https://github.com/celuk/synopsys-flow
// Copyright (C) 2024  Seyyid Hikmet Celik
//                     seyyid4091@gmail.com
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

`timescale 1ns / 1ps

module c0_soc(
    input clk_i,
    input rst_ni,

    output mem_uart_tx_o,
    input  mem_uart_rx_i,
 
    output uart_tx_o,
    input  uart_rx_i
    );

    wire clk;
    wire rst_n;
 
    wire mem_uart_tx;
    wire mem_uart_rx;
 
    wire uart_tx;
    wire uart_rx;
 
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

    // inputs
    PDDW0812CDG PDDW0812CDG_IN_CLK(.OEN(1'b1),.I(1'b0),.PAD(clk_i),.C(clk),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    PDDW0812CDG PDDW0812CDG_IN_RSTN(.OEN(1'b1),.I(1'b0),.PAD(rst_ni),.C(rst_n),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    PDDW0812CDG PDDW0812CDG_IN0(.OEN(1'b1),.I(1'b0),.PAD(mem_uart_rx_i),.C(mem_uart_rx),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    PDDW0812CDG PDDW0812CDG_IN1(.OEN(1'b1),.I(1'b0),.PAD(uart_rx_i),.C(uart_rx),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    
    // outputs
    PDDW0812CDG PDDW0812CDG_OUT0(.OEN(1'b0),.I(mem_uart_tx),.PAD(mem_uart_tx_o),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0812CDG PDDW0812CDG_OUT1(.OEN(1'b0),.I(uart_tx),.PAD(uart_tx_o),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));

    c0_top c0_top_inst(
        .clk(clk),
        .resetn(rst_n),

        .mem_tx_o(mem_uart_tx),
        .mem_rx_i(mem_uart_rx),

        .uart_tx_o(uart_tx),
        .uart_rx_i(uart_rx)
    );

endmodule
