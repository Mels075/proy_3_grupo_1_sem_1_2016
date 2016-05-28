`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:33:02 03/31/2016 
// Design Name: 
// Module Name:    Generador_RING 
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
module Generador_RING(
    input CLK_Ring, reset,
	 input wire fin_crono,
	 output reg band_parp
	 );

	 always @(posedge CLK_Ring, posedge reset)
	 begin
		if (reset)
		begin
			band_parp<=1'b0;
		end
		else
		begin
		if (fin_crono) band_parp<=~band_parp;
		else band_parp<=1'b0;
				
		end
	 end
endmodule
