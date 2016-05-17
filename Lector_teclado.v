`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:18:55 05/16/2016 
// Design Name: 
// Module Name:    Lector_teclado 
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
module Lector_teclado(
    input CLK, RST, PS2D, PS2C,
	 output [7:0] TECLA
	 );
	 
	 wire tick;
	 wire START;
	 wire [7:0] DATA;
	 
	 Deteccion_tecla inst_detector(
    .clk_Nexys(CLK), .Reset(RST),
	 .byte_dato(DATA),		 
	 .scan_done_tick(tick),
	 .tecla(TECLA)
	 );
	 
	 Receptor_dato inst_receptor(
    .clk_nexys(CLK), .reset(RST),
	 .ps2d(PS2D), .ps2c(PS2C),
	 .rx_done_tick(tick),
	 .dato(DATA)
	 );


endmodule
