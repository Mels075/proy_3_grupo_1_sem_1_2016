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
	input reloj_nexys, reset_total, 
	input [7:0] dato, id_port,
	input write_strobe,
	output [7:0] color_salida,
	output hsincro, vsincro, audio
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
	 
	 reg tempo, formatto;
	 reg finale;
	 reg [7:0] h_oro, m_oro, s_oro;
	 reg [7:0] giorno, messe, agno;
	 reg [7:0] ora, minute, secondo;		
	 reg [7:0] H_run, M_run, S_run;	 
	 reg [7:0] direccion_prog;			
	 reg [2:0] dir_cursor;
	 
	 //wire THE_FLAG;
	 reg flag, flag_ant, flag_sig;
	 
	 // datos provisionales 
	 reg [7:0] handshake;
	 reg tempo_p, formatto_p;			//finalcronometro, ampm, formato de hora 12 ó 24 h
	 reg [7:0] h_oro_p, m_oro_p, s_oro_p;
	 reg [7:0] giorno_p, messe_p, agno_p;
	 reg [7:0] ora_p, minute_p, secondo_p;		//cronometro
	 reg [7:0] H_run_p, M_run_p, S_run_p;	 
	 reg [7:0] direccion_prog_p;											//lo que esta programando, se recibe el codigo de la tecla
	 reg [2:0] dir_cursor_p;  //posicion del cursor
	 
	 always @(posedge reloj_interno, posedge reset_interno)
	 begin
		if (reset_interno)
		begin
			handshake <= 8'h00;
			flag <= 0;
			tempo_p <= 1'b0; formatto_p <= 1'b0;
			h_oro_p <= 8'h00; m_oro_p <= 8'h00; s_oro_p <= 8'h00;
			giorno_p <= 8'h00; messe_p <= 8'h00; agno_p <= 8'h00;
			ora_p <= 8'h00; minute_p <= 8'h00; secondo_p <= 8'h00;   //cronometro
			H_run_p <= 8'h00; M_run_p <= 8'h00; S_run_p <= 8'h00;
			direccion_prog_p <= 8'h00;
			dir_cursor_p <= 3'h0;
		end
		else if (write_strobe)
			case(id_port)
				8'h04: agno_p[7:4] <= dato[3:0];
				8'h05: agno_p[3:0] <= dato[3:0];
				8'h06: messe_p[7:4] <= dato[3:0];
				8'h07: messe_p[3:0] <= dato[3:0];
				8'h08: giorno_p[7:4] <= dato[3:0];
				8'h09: giorno_p[3:0] <= dato[3:0];
				8'h0a: h_oro_p[7:4] <= dato[3:0];
				8'h0b: h_oro_p[3:0] <= dato[3:0];
				8'h0c: m_oro_p[7:4] <= dato[3:0];
				8'h0d: m_oro_p[3:0] <= dato[3:0];
				8'h0e: s_oro_p[7:4] <= dato[3:0];
				8'h0f: s_oro_p[3:0] <= dato[3:0];
				8'h10: H_run_p[7:4] <= dato[3:0];
				8'h11: H_run_p[3:0] <= dato[3:0];
				8'h12: M_run_p[7:4] <= dato[3:0];
				8'h13: M_run_p[3:0] <= dato[3:0];
				8'h14: S_run_p[7:4] <= dato[3:0];
				8'h15: S_run_p[3:0] <= dato[3:0];
				8'h16: begin tempo_p <= dato[4]; formatto_p <= dato[0]; end
				8'h17: dir_cursor_p <= dato[2:0];
				8'h18: direccion_prog_p <= dato;
				8'h19: handshake <= dato;
				8'h1a: ora_p[7:4] <= dato[3:0];
				8'h1b: ora_p[3:0] <= dato[3:0];
				8'h1c: minute_p[7:4] <= dato[3:0];
				8'h1d: minute_p[3:0] <= dato[3:0];
				8'h1e: secondo_p[7:4] <= dato[3:0];
				8'h1f: secondo_p[3:0] <= dato[3:0];
				8'h20: flag <= ~flag;
			endcase
	 end
	 
	 always @(negedge reloj_interno)
	 begin
      if (reset_interno) flag_ant <= 0;
      else flag_ant <= flag;
	 end
	 always @(negedge reloj_interno)
	 begin
      if (reset_interno) flag_sig <= 0;
      else flag_sig <= flag_ant;
	 end
	 
	 always @(posedge reloj_interno)
	 begin
		if (flag_sig != flag_ant) finale <= 1; 
		else finale <= 0;
	 end
	 
	 always @(posedge reloj_interno, posedge reset_interno) 
	 begin
		if (reset_interno)
		begin
			 tempo <= 1'b0; formatto <= 1'b0;
			 h_oro <= 8'h00; m_oro <= 8'h00; s_oro <= 8'h00;
			 giorno <= 8'h00; messe <= 8'h00; agno <= 8'h00;
			 ora <= 8'h00; minute <= 8'h00; secondo <= 8'h00;	
			 H_run <= 8'h00; M_run <= 8'h00; S_run <= 8'h00;	 
			 direccion_prog <= 8'h00;
			 dir_cursor <= 3'h0;
		end
		else if (handshake==8'hff)
		begin
			 tempo <= tempo_p; formatto <= formatto_p;
			 h_oro <= h_oro_p; m_oro <= m_oro_p; s_oro <= s_oro_p;
			 giorno <= giorno_p; messe <= messe_p; agno <= agno_p;
			 ora <= ora_p; minute <= minute_p; secondo <= secondo_p;	
			 H_run <= H_run_p; M_run <= M_run_p; S_run <= S_run_p;	 
			 direccion_prog <= direccion_prog_p;
			 dir_cursor <= dir_cursor_p;
		end
	 end
	 
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
	 
	 Audio inst_audio (
    .CLK_NexYs(reloj_interno), 
    .RST(reset_interno), 
    .FIN_CRONOM(finale), 
    .audio_clk(audio)
    );

	 
	 VGA_b inst_deco_texto_fig(
    .clk_PARPADEO(medio_seg), .CLK_NEXYS(reloj_interno), .clk_VGA(PT), .RESET(reset_interno),
	 .PIX_X(x_p), .PIX_Y(y_p),
	 .HORA(h_oro), .MIN(m_oro), .SEG(s_oro), 
	 .DIA(giorno), .MES(messe), .YEAR(agno), 
	 .HCRONO(ora), .MCRONO(minute), .SCRONO(secondo), 
	 .HCRONO_RUN(H_run), .MCRONO_RUN(M_run), .SCRONO_RUN(S_run),
	 .FIN_CRONO(finale), .AM_PM(tempo), .HFORMATO(formatto),
	 .DIR_CURSOR(dir_cursor), 		//indica la posición del cursor en la programación
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
