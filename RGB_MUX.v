`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:59:21 03/29/2016 
// Design Name: 
// Module Name:    RGB_MUX 
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
module RGB_MUX(
    input video_on,
	 input [7:0] color,
	 output reg [7:0] RGB
	 );
	 always @*
	 begin
	 if (video_on)
		RGB=color;
	 else
		RGB=7'h00;
	end
endmodule
