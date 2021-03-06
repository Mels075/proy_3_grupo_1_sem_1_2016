`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:18:55 05/14/2016 
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
	 input interrupcion_paro,
	 output [7:0] TECLA,
	 output interrupcion
	 );
	 
	 wire tick;
	 wire [7:0] DATA;
	 wire [7:0] TECLA_SUELTA;
	 
	 Deteccion_tecla inst_detector(
    .clk_Nexys(CLK), .Reset(RST),
	 .byte_dato(DATA),	 
	 //.interrupcion_pb(interrupcion_paro),
	 .scan_done_tick(tick),
	 .tecla(TECLA_SUELTA)
	 );
	 
	 Receptor_dato inst_receptor(
    .clk_nexys(CLK), .reset(RST),
	 .ps2d(PS2D), .ps2c(PS2C),
	 .rx_done_tick(tick),
	 .dato(DATA)
	 );
	 
	 Decodificador_tecla inst_control_teclas(
    .reset(RST), .CLK_Nexys(CLK),
	 .TECLA_IN(TECLA_SUELTA),
	 .interrupt_paro(interrupcion_paro),
	 .TECLA_OUT(TECLA),
	 .interrupt(interrupcion)
	 );


endmodule
