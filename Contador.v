`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:09:38 03/27/2016 
// Design Name: 
// Module Name:    Contador 
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
module Contador(
    input CLK_NX,
	 input reset,
	 output reg pixel_rate,
	 output reg clk_RING
	 );
	 localparam cont_ring = 24'd12499999;
	 reg [0:0] cont;
	 reg [23:0] divisor;
	
	 //Para generar a partir de 100 MHz los 25 MHz que se utilizan en pantalla 640x480
	 //Además genera el clock para el parpadeo a 4Hz
	 
	 always @(posedge CLK_NX, posedge reset)
	 begin
		if (reset)
		begin
			pixel_rate=0;
			cont=0;
			divisor=24'd0;
			clk_RING=0;
			
			
		end
		
		else
		begin
			if(cont==1'd1)
			begin
				cont=1'd0;
				pixel_rate=~pixel_rate;
			end
			else cont=cont+1'd1;
			
			if(divisor==cont_ring)
			begin
				divisor=24'd0;
				clk_RING=~clk_RING;
			end
			else divisor=divisor+24'd1;
			
			
		end
	 end

endmodule
