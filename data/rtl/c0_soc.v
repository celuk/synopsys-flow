module c0_soc(
    //inout VDD,
    //inout VDD_I,
    //inout VSS,
    //inout           VDD, //CORE 1.8V
    //inout           VDDPST, //PAD 3.3V
    //inout           VSS,
    //inout VDDH,
    
    input clk_i,
    input rst_ni,

   output mem_uart_tx_o,
   input  mem_uart_rx_i,

   output uart_tx_o,
   input  uart_rx_i,

   //output spi_cs_o,
   //output spi_sck_o,
   //output spi_mosi_o,
   //input  spi_miso_i

   output qspi_cs_o,
   output qspi_sck_o,
   inout [0:0] qspi_data_io
    );

    //PVDD1CDG PVDD1CDG_CONN(.VDD());
    //PVDD2CDG PVDD2CDG_CONN(.VDDPST());
    //PVSS3CDG PVSS3CDG_CONN(.VSS());


    wire clk;
    wire rst_n;

   wire mem_uart_tx;
   wire  mem_uart_rx;

   wire uart_tx;
   wire  uart_rx;

   wire spi_cs;
   wire spi_sck;
   wire spi_mosi;
   wire  spi_miso;

    PVDD2POC VDD2POC ( .VDDPST() );
    PVDD2CDG VDDPST_0 ( .VDDPST() );
    PVDD2CDG VDDPST_1 ( .VDDPST() );
    PVDD1CDG VDD_0 ( .VDD() );
    PVDD1CDG VDD_1 ( .VDD() );
    PVSS3CDG VSS_0 ( .VSS() );
    PVSS3CDG VSS_1 ( .VSS() );

    // inputs
    PDDW0204CDG PDDW0204CDG_IN_CLK(.OEN(1'b1),.I(1'b0),.PAD(clk_i),.C(clk),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    PDDW0204CDG PDDW0204CDG_IN_RSTN(.OEN(1'b1),.I(1'b0),.PAD(rst_ni),.C(rst_n),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    PDDW0204CDG PDDW0204CDG_IN0(.OEN(1'b1),.I(1'b0),.PAD(mem_uart_rx_i),.C(mem_uart_rx),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    PDDW0204CDG PDDW0204CDG_IN1(.OEN(1'b1),.I(1'b0),.PAD(uart_rx_i),.C(uart_rx),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    

    // outputs
    PDDW0204CDG PDDW0204CDG_OUT0(.OEN(1'b0),.I(mem_uart_tx),.PAD(mem_uart_tx_o),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0204CDG PDDW0204CDG_OUT1(.OEN(1'b0),.I(uart_tx),.PAD(uart_tx_o),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0204CDG PDDW0204CDG_OUT2(.OEN(1'b0),.I(spi_cs),.PAD(qspi_cs_o),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    PDDW0204CDG PDDW0204CDG_OUT3(.OEN(1'b0),.I(spi_sck),.PAD(qspi_sck_o),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));
    

    //PDDW0204CDG PDDW0204CDG_IN_D3(.OEN(1'b1),.I(1'b0),.PAD(spi_miso_i),.C(spi_miso),.DS(1'b0),.PE(1'b0),.IE(1'b1));
    //PDDW0204CDG PDDW0204CDG_OUT_SEG4(.OEN(1'b0),.I(spi_mosi),.PAD(spi_mosi_o),.C(),.DS(1'b1),.PE(1'b0),.IE(1'b0));

wire [1:0] qspi_out_mod = {uart_rx_i, mem_uart_rx_i};

wire [3:0] qspi_miso = {spi_miso, spi_miso, spi_miso, spi_miso};
wire [3:0] qspi_mosi = {spi_mosi, spi_mosi, spi_mosi, spi_mosi};

    PDDW0204CDG PDDW0204CDG_OUT4(.OEN(~|qspi_out_mod),.I(qspi_mosi[0]),.PAD(qspi_data_io[0]),.C(qspi_miso[0]),.DS(|qspi_out_mod),.PE(1'b0),.IE(~|qspi_out_mod));
    //PDDW0204CDG PDDW0204CDG_INOUT2(.OEN(~qspi_out_mod[1]),.I(qspi_mosi[1]),.PAD(qspi_data_io[1]),.C(qspi_miso[1]),.DS(qspi_out_mod[1]),.PE(1'b0),.IE(~qspi_out_mod[1]));
    //PDDW0204CDG PDDW0204CDG_INOUT3(.OEN(~&qspi_out_mod),.I(qspi_mosi[2]),.PAD(qspi_data_io[2]),.C(qspi_miso[2]),.DS(&qspi_out_mod),.PE(1'b0),.IE(~&qspi_out_mod));
    //PDDW0204CDG PDDW0204CDG_INOUT4(.OEN(~&qspi_out_mod),.I(qspi_mosi[3]),.PAD(qspi_data_io[3]),.C(qspi_miso[3]),.DS(&qspi_out_mod),.PE(1'b0),.IE(~&qspi_out_mod));

    c0_top c0_top_inst(
        .clk_i(clk),
        .rst_ni(rst_n),

    .mem_uart_tx_o(mem_uart_tx),
    .mem_uart_rx_i(mem_uart_rx),

    .uart_tx_o(uart_tx),
    .uart_rx_i(uart_rx),

    .spi_cs_o(spi_cs),
    .spi_sck_o(spi_sck),
    .spi_mosi_o(spi_mosi),
    .spi_miso_i(spi_miso)
    );

endmodule
