`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:51:10 05/30/2016 
// Design Name: 
// Module Name:    PruebaTeclado 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PruebaTeclado(
	 input Ps2C, Ps2D, CLK_NEX, reset,
	 output reg [3:0] LEDS
	 );
	 
	 wire tick;
	 wire [7:0] DATA;
	 wire [7:0] TECLA_SUELTA;
	 
	 Deteccion_tecla inst_detector(
    .clk_Nexys(CLK_NEX), .Reset(reset),
	 .byte_dato(DATA),		 
	 .scan_done_tick(tick),
	 .tecla(TECLA_SUELTA)
	 );
	 
	 Receptor_dato inst_receptor(
    .clk_nexys(CLK_NEX), .reset(reset),
	 .ps2d(Ps2D), .ps2c(Ps2C),
	 .rx_done_tick(tick),
	 .dato(DATA)
	 );
	 
	 
	 always @(posedge CLK_NEX)
	 begin
		case (TECLA_SUELTA)
			8'h16: LEDS <= 4'h1;
			8'h1e: LEDS <= 4'h2;
			8'h26: LEDS <= 4'h3;
			8'h25: LEDS <= 4'h4;
			8'h2e: LEDS <= 4'h5;
			8'h36: LEDS <= 4'h6;
			8'h3d: LEDS <= 4'h7;
			8'h3e: LEDS <= 4'h8;
			8'h46: LEDS <= 4'h9;
			8'h45: LEDS <= 4'h0;
			default: LEDS <= 4'ha;
		endcase
	 end
	 
endmodule
