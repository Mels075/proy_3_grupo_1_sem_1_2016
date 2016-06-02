`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:28:17 05/14/2016 
// Design Name: 
// Module Name:    Receptor_dato 
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
module Receptor_dato(
    input wire clk_nexys, reset,
	 input wire ps2d, ps2c,
	 output reg rx_done_tick,
	 output [7:0] dato
	 );
	 
	 localparam [1:0] idle = 2'b00, 
	 dps = 2'b01, load = 2'b10;
	 
	 reg [1:0] estado_reg, estado_sig;
	 reg [7:0] filtro_reg;
	 wire [7:0] filtro_sig;
	 reg f_ps2c_reg;
	 wire f_ps2c_sig;
	 reg [3:0] n_reg, n_sig;
	 reg [10:0] b_reg, b_sig;
	 wire fall_edge;
	 
	 always@(posedge clk_nexys, posedge reset)
	 begin
		if (reset)
		begin
			filtro_reg<=0;
			f_ps2c_reg<=0;
			//FSMD
			estado_reg<=idle;
			n_reg<=0;
			b_reg<=0;
		end
		else 
		begin
			filtro_reg<=filtro_sig;
			f_ps2c_reg<=f_ps2c_sig;
			//FSMD
			estado_reg <= estado_sig;
			n_reg <= n_sig;
			b_reg <= b_sig;
		end
	 end
	 
	 assign filtro_sig={ps2c,filtro_reg[7:1]};
	 assign f_ps2c_sig = (filtro_reg==8'b11111111) ? 1'b1 : (filtro_reg==8'b00000000) ? 1'b0 : f_ps2c_reg;
	 assign fall_edge= f_ps2c_reg & ~f_ps2c_sig;
	 
	 always @*
	 begin
		estado_sig = estado_reg;
		rx_done_tick = 1'b0;
		n_sig = n_reg;
		b_sig [10:0]= b_reg[10:0];
		case (estado_reg)
			idle: if (fall_edge)
					begin
						b_sig={ps2d,b_reg[10:1]};
						n_sig = 4'b1001;
						estado_sig = dps;
					end
			dps:  if (fall_edge)
					begin
						b_sig = {ps2d, b_reg[10:1]};
						if (n_reg==0) estado_sig=load;
						else n_sig = n_reg - 4'b0001;
					end
			load: begin
						estado_sig = idle;
						rx_done_tick = 1'b1;
					end
		endcase
	 end
	 
	 assign dato= b_reg[8:1];
	 
endmodule
