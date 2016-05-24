`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:40:06 03/27/2016 
// Design Name: 
// Module Name:    Sincronizador 
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
module Sincronizador(
    input reset, CLK_pix_rate,
	 output wire h_sync, v_sync, video_on,
	 output wire [9:0] pixel_x, pixel_y
	 );
	 //Parametros de la pantalla horizontales
	 localparam H_Disp=640;
	 localparam H_Front=48;
	 localparam H_Back=16;
	 localparam H_Ret=96;
	 //Parametros de la pantalla verticales
	 localparam V_Disp=480;
	 localparam V_Front=10;
	 localparam V_Back=33;
	 localparam V_Ret=2;
	 	
	 
	 reg [9:0] h_cont_reg, h_cont_sig;
	 reg [9:0] v_cont_reg, v_cont_sig;
	 
	 reg v_sync_reg, h_sync_reg;
	 wire v_sync_sig, h_sync_sig;
	 
	 wire h_fin, v_fin;
	 
	 always @(posedge CLK_pix_rate, posedge reset)
	 begin
		if (reset)
		begin
			v_cont_reg<=0;
			h_cont_reg<=0;
			v_sync_reg<=0;
			h_sync_reg<=0;
		end
		
		else
		begin
			v_cont_reg<=v_cont_sig;
			h_cont_reg<=h_cont_sig;
			v_sync_reg<=v_sync_sig;
			h_sync_reg<=h_sync_sig;
		end
	 end
	 
	 assign h_fin=(h_cont_reg==(H_Disp+H_Front+H_Back+H_Ret-1));
	 assign v_fin=(v_cont_reg==(V_Disp+V_Front+V_Back+V_Ret-1));
	 
	 //Contadores tanto de la línea como del pixel
	 always @*
	 begin
		if (h_fin)
			h_cont_sig=0;
			
		else
			h_cont_sig=h_cont_reg+10'd1;
	 end
	 
	 always @*
	 begin
		if(h_fin)
		begin
			if (v_fin)
				v_cont_sig=0;
			else
				v_cont_sig=v_cont_reg+10'd1;
		end
		
		else v_cont_sig=v_cont_reg;
	 end
	 
	 //Sincronización vertical y horizontal
	 assign h_sync_sig =(h_cont_reg>=(H_Disp+H_Back) && h_cont_reg<=(H_Disp+H_Back+H_Ret-1));
	 assign v_sync_sig =(v_cont_reg>=(V_Disp+V_Back) && v_cont_reg<=(V_Disp+V_Back+V_Ret-1));
	 
	 //Estado del vídeo
	 assign video_on = ((h_cont_reg<H_Disp) && (v_cont_reg<V_Disp));
	 
	 //Salidas
	 assign h_sync = ~h_sync_reg;
	 assign v_sync = ~v_sync_reg;
	 assign pixel_x = h_cont_reg;
	 assign pixel_y = v_cont_reg;
		 
endmodule
