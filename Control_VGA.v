`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:33:06 05/22/2016 
// Design Name: 
// Module Name:    Control_VGA 
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
module Control_VGA(
	input reloj_nexys, reset_total, //handshake,
	input [1:0] direccion_prog,
	input [2:0] prog_crono_dir, prog_fecha_dir, prog_hora_dir,
	input finale, tempo, formatto,
	//input [7:0] h_oro_act, m_oro_act, s_oro_act, 
	//input [7:0] giorno_act, messe_act, agno_act, ora_act, minute_act, secondo_act,
	//input [7:0] h_run_act, m_run_act, s_run_act,
	input wire [7:0] h_oro, m_oro, s_oro,
	input wire [7:0] giorno, messe, agno,
	input wire [7:0] ora, minute, secondo,
	input wire [7:0] H_run, M_run, S_run,
	output [7:0] color_salida,
	output hsincro, vsincro
    );
	 
	 wire reloj_interno, reset_interno;
	 assign reloj_interno=reloj_nexys;
	 assign reset_interno=reset_total;
	 
	 wire PT, ON_VID;
	 wire [9:0] x_p, y_p;
	 wire [7:0] colour;
	 wire [7:0] rgb_next;
	 reg [7:0] rgb_reg;
	 wire medio_seg;
	 
	  
	/* HandShake inst_handshake(
	 .h_oro_a(h_oro_act), .m_oro_a(m_oro_act), .s_oro_a(s_oro_act), 
	 .giorno_a(giorno_act), .messe_a(messe_act), .agno_a(agno_act), 
	 .ora_a(ora_act), .minute_a(minute_act), .secondo_a(secondo_act),
	 .h_run_a(h_run_act), .m_run_a(m_run_act), .s_run_a(s_run_act),
	 .HS_flag(handshake), .reset(reset_interno), .reloj_nex(reloj_interno),
	 .h_oro_o(h_oro), .m_oro_o(m_oro), .s_oro_o(s_oro), 
	 .giorno_o(giorno), .messe_o(messe), .agno_o(agno),
	 .ora_o(ora), .minute_o(minute), .secondo_o(secondo), 
	 .h_run_o(H_run), .m_run_o(M_run), .s_run_o(S_run)
    );*/
	 
	  Contador inst_25MHz(
    .CLK_NX(reloj_interno),
	 .reset(reset_interno),
	 .pixel_rate(PT),
	 .clk_RING(medio_seg)
	 );
	 
	 Sincronizador inst_sync(
    .reset(reset_interno), .CLK_pix_rate(PT),
	 .h_sync(hsincro), .v_sync(vsincro), .video_on(ON_VID),
	 .pixel_x(x_p), .pixel_y(y_p)
	 );
	 
	 RGB_MUX inst_mux_color(
    .video_on(ON_VID),
	 .color(colour),
	 .RGB(rgb_next)
	 );
	 
	 VGA_b inst_deco_texto_fig(
    .clk_PARPADEO(medio_seg), .CLK_NEXYS(reloj_interno), .clk_VGA(PT),
	 .PIX_X(x_p), .PIX_Y(y_p),
	 .HORA(h_oro), .MIN(m_oro), .SEG(s_oro), 
	 .DIA(giorno), .MES(messe), .YEAR(agno), 
	 .HCRONO(ora), .MCRONO(minute), .SCRONO(secondo), 
	 .HCRONO_RUN(H_run), .MCRONO_RUN(M_run), .SCRONO_RUN(S_run),
	 .FIN_CRONO(finale), .AM_PM(tempo), .HFORMATO(formatto),
	 .DIR_P_CRONO(prog_crono_dir), .DIR_P_FECHA(prog_fecha_dir), .DIR_P_HORA(prog_hora_dir),			//indica la posición del cursor en la programación
	 .PROGRAMANDO_LUGAR(direccion_prog),					//indica que cosa el usuario desea programar o si no desea programar nada
	 .COLOUR(colour)
	 );
	 
	 always @(posedge reloj_interno, posedge reset_interno)
		 begin
			 if(reset_interno)
				rgb_reg<=7'hff;
			 else
			 begin
				if (PT)
					rgb_reg<=rgb_next;
			 end
		 end
		 assign color_salida=rgb_reg;

endmodule
