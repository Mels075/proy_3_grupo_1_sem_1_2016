`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:41:13 05/14/2016 
// Design Name: 
// Module Name:    Deteccion_tecla 
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
module Deteccion_tecla(
    input clk_Nexys, Reset,
	 input [7:0] byte_dato,		 
	 input wire scan_done_tick,
	 output wire [7:0] tecla,
	 output reg got_done_tick
	 );
	 
	 localparam brk = 8'hf0;
	 localparam wait_break =1'b0, get_code=1'b1;
	 
	 reg estado_reg, estado_sig;
	 reg [7:0] tecla_out;
	 
	 always @(posedge clk_Nexys, posedge Reset)
	 if (Reset) estado_reg <= wait_break;
	 else estado_reg <= estado_sig;
	 
	 always @*
	 begin
		got_done_tick=1'b0;
		estado_sig=estado_reg;
		case (estado_reg)
			wait_break: if (scan_done_tick && byte_dato==brk) estado_sig = get_code;
			get_code: if (scan_done_tick)
							begin
								got_done_tick=1'b1;
								estado_sig = wait_break;
							end
		endcase
	 end
	 
	 always @(posedge got_done_tick)
		if (got_done_tick) tecla_out=byte_dato;
		
	 assign tecla=tecla_out;
	 	 
endmodule
