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
	 //input interrupcion_pb,
	 input wire scan_done_tick,
	 output wire [7:0] tecla
	 );
	 
	 localparam brk = 8'hf0;
	 localparam wait_break =1'b0, get_code=1'b1;
	
	 reg estado_reg, estado_sig;
	 reg [7:0] tecla_out;
	 reg [7:0] tecla_save;
	 
	 always @(posedge clk_Nexys, posedge Reset)
	 if (Reset) estado_reg <= wait_break;
	 else begin estado_reg <= estado_sig; tecla_save <= tecla_out; end
	 
	 always @*
	 begin
	 estado_sig = estado_reg;
	 tecla_out = tecla_save;
		case (estado_reg)
			wait_break: if (scan_done_tick && byte_dato==brk) begin tecla_out = byte_dato; estado_sig = get_code; end
			get_code:	if (scan_done_tick)
							begin
								tecla_out = byte_dato;
								estado_sig = wait_break;
							end
		endcase
	 end
	 //assign tecla = (~interrupcion_pb) ? tecla_out : 8'h00;
	 assign tecla = tecla_out;
		
	 	 
endmodule
