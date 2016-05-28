`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:17:07 05/28/2016 
// Design Name: 
// Module Name:    HandShake 
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
module HandShake(
	 input clock, reset,
	 input [7:0] HANDSHAKE, 
	 input finale_P, tempo_P, formatto_P,			//finalcronometro, ampm, formato de hora 12 ó 24 h
	 input [7:0] h_oro_P, m_oro_P, s_oro_P,
	 input [7:0] giorno_P, messe_P, agno_P,
	 input [7:0] ora_P, minute_P, secondo_P,		//cronometro
	 input [7:0] H_run_P, M_run_P, S_run_P,	 
	 input [7:0] direccion_prog_P,											//lo que esta programando, se recibe el codigo de la tecla
	 input [2:0] dir_cursor_P,  //posicion del cursor
	 output reg finale, tempo, formatto,			//finalcronometro, ampm, formato de hora 12 ó 24 h
	 output reg [7:0] h_oro, m_oro, s_oro,
	 output reg [7:0] giorno, messe, agno,
	 output reg [7:0] ora, minute, secondo,		//cronometro
	 output reg [7:0] H_run, M_run, S_run,	 
	 output reg [7:0] direccion_prog,											//lo que esta programando, se recibe el codigo de la tecla
	 output reg [2:0] dir_cursor  //posicion del cursor
    );
	 
	 always @(posedge clock, posedge reset) 
	 begin
		if (reset)
		begin
			 finale <= 1'b0; tempo <= 1'b0; formatto <= 1'b0;
			 h_oro <= 8'h00; m_oro <= 8'h00; s_oro <= 8'h00;
			 giorno <= 8'h00; messe <= 8'h00; agno <= 8'h00;
			 ora <= 8'h00; minute <= 8'h00; secondo <= 8'h00;	
			 H_run <= 8'h00; M_run <= 8'h00; S_run <= 8'h00;	 
			 direccion_prog <= 8'h00;
			 dir_cursor <= 3'h0;
		end
		else if (HANDSHAKE==8'hff)
		begin
			 finale <= finale_P; tempo <= tempo_P; formatto <= formatto_P;
			 h_oro <= h_oro_P; m_oro <= m_oro_P; s_oro <= s_oro_P;
			 giorno <= giorno_P; messe <= messe_P; agno <= agno_P;
			 ora <= ora_P; minute <= minute_P; secondo <= secondo_P;	
			 H_run <= H_run_P; M_run <= M_run_P; S_run <= S_run_P;	 
			 direccion_prog <= direccion_prog_P;
			 dir_cursor <= dir_cursor_P;
		end
	 end
	 
endmodule
