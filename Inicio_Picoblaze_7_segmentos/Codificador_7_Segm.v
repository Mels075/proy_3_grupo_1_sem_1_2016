`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 	TEC	
// Engineer: Melissa Fonseca Rodríguez
// 
// Create Date:    14:46:09 03/04/2016 
// Design Name: 	
// Module Name:    Codificador 7 segmentos 
// Project Name: DPWM
// Target Devices: Nexys3
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
module Codificador_7_Seg(
	 input [7:0] Disp,
	 input [7:0]id_port,
	 input wr_reg,
	 input reset,
	 input clk_d,
	 output reg [7:0] codificacion1,
	 output reg [3:0] digito1,
	 output reg [3:0] digito2
    );
	 reg [15:0] disp1;							
	 reg [15:0] disp2; 
	 reg [2:0] contador;
	 reg [3:0] num1;
	 reg [17:0] delay;
	 
	 
	 always @(posedge clk_d)
	 begin
		
	 if (reset==1)
	 begin 
		contador<=3'd0;
		delay<=18'd0;
		disp1<=16'd0;							
		disp2<=16'd0;
		codificacion1<=8'd0;
		digito1<=4'd0;
		digito2<=4'd0;

	 end
	 else
	 begin
			
		 if (wr_reg==1)
			case (id_port)
			8'h00:disp1[7:0]<=Disp;
			8'h01:disp1[15:8]<=Disp;
			8'h02:disp2[7:0]<=Disp;
			8'h03:disp2[15:8]<=Disp;
			endcase
		if (delay==0)
		begin
			case (contador)
			3'd0:begin
				num1<=disp1[3:0];
				digito1<=4'he;
				digito2<=4'hf;
				end
			3'd1:begin
				num1<=disp1[7:4];
				digito1<=4'hd;
				end
			3'd2:begin
				num1<=disp1[11:8];
				digito1<=4'hb;
				end
			3'd3:begin
				num1<=disp1[15:12];
				digito1<=4'h7;
				end	
			3'd4:begin
				num1<=disp2[3:0];
				digito1<=4'hf;
				digito2<=4'he;
				end	
			3'd5:begin
				num1<=disp2[7:4];
				digito2<=4'hd;
				end
			3'd6:begin
				num1<=disp2[11:8];
				digito2<=4'hb;
				end
			3'd7:begin
				num1<=disp2[15:12];
				digito2<=4'h7;
				end				
			endcase
		end
		
		if (delay==18'd1)
		begin
			case (num1)
				4'h0: codificacion1<=8'b10000001;
				4'h1: codificacion1<=8'b11001111;
				4'h2: codificacion1<=8'b10010010;
				4'h3: codificacion1<=8'b10000110;
				4'h4: codificacion1<=8'b11001100;
				4'h5: codificacion1<=8'b10100100;
				4'h6: codificacion1<=8'b10100000;
				4'h7: codificacion1<=8'b10001111;
				4'h8: codificacion1<=8'b10000000;
				4'h9: codificacion1<=8'b10001100;
				4'ha: codificacion1<=8'b10001000;
				4'hb: codificacion1<=8'b11100000;
				4'hc: codificacion1<=8'b10110001;
				4'hd: codificacion1<=8'b11000010;
				4'he: codificacion1<=8'b10110000;
				4'hf: codificacion1<=8'b10111000;
				endcase
		end
		if (delay==18'd100000000)
			begin
			delay<=18'd0;
			contador<=contador+3'd1;
			end
		
		else delay<=delay+18'd1;
	end
end
				
endmodule 