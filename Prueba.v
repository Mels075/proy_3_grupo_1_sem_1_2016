`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:12:49 03/31/2016 
// Design Name: 
// Module Name:    Prueba 
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
module Prueba(
	input [2:0] SW,
	output reg [1:0] d_pg,
	output reg [2:0] p_cr, p_fe, p_ho,
	output reg CRONO_FIN, AMPM, FORMATO,
	output reg [7:0] HREL, MREL, SREL, DIA, MES, ANIO, HCRON, MCRON,SCRON, HRUN, MRUN, SRUN
    );
	 

	always @*
	begin
		if(SW==3'b001) 
			begin 
				d_pg=3;
				p_cr=0;
				p_fe=1;
				p_ho=1;
				CRONO_FIN=1;
				AMPM=1; 
				FORMATO=1;
				HREL=8'h11;
				MREL=8'h22; 
				SREL=8'h33;
				DIA=8'h44;
				MES=8'h55;
				ANIO=8'h66;
				HCRON=8'h77;
				MCRON=8'h88;
				SCRON=8'h99;
				HRUN=8'h00;
				MRUN=8'h01; 
				SRUN=8'h02;
			end
		else if(SW==3'b010) 
			begin 
				d_pg=2;
				p_cr=5;
				p_fe=1;
				p_ho=4;
				CRONO_FIN=0;
				AMPM=1; 
				FORMATO=0;
				HREL=8'h01;
				MREL=8'h12; 
				SREL=8'h93;
				DIA=8'h48;
				MES=8'h65;
				ANIO=8'h60;
				HCRON=8'h79;
				MCRON=8'h48;
				SCRON=8'h95;
				HRUN=8'h25;
				MRUN=8'h15; 
				SRUN=8'h99;
			end
		else if (SW==3'b100)
			begin
				d_pg=1;
				p_cr=0;				
				p_fe=1;
				p_ho=4;
				CRONO_FIN=0;
				AMPM=0; 
				FORMATO=1;
				HREL=8'h00;
				MREL=8'h08; 
				SREL=8'h93;
				DIA=8'h60;
				MES=8'h91;
				ANIO=8'h60;
				HCRON=8'h29;
				MCRON=8'h08;
				SCRON=8'h95;
				HRUN=8'h30;
				MRUN=8'h73; 
				SRUN=8'h08;
			end
			else if (SW==3'b101)
			begin
				d_pg=2;
				p_cr=1;				
				p_fe=3;
				p_ho=2;
				CRONO_FIN=0;
				AMPM=0; 
				FORMATO=1;
				HREL=8'h00;
				MREL=8'h08; 
				SREL=8'h93;
				DIA=8'h60;
				MES=8'h91;
				ANIO=8'h60;
				HCRON=8'h29;
				MCRON=8'h08;
				SCRON=8'h95;
				HRUN=8'h30;
				MRUN=8'h73; 
				SRUN=8'h08;
			end
			else if (SW==3'b111)
			begin
				d_pg=1;
				p_cr=3;				
				p_fe=2;
				p_ho=1;
				CRONO_FIN=0;
				AMPM=0; 
				FORMATO=1;
				HREL=8'h00;
				MREL=8'h08; 
				SREL=8'h93;
				DIA=8'h60;
				MES=8'h91;
				ANIO=8'h60;
				HCRON=8'h29;
				MCRON=8'h08;
				SCRON=8'h95;
				HRUN=8'h30;
				MRUN=8'h73; 
				SRUN=8'h08;
			end
		else
		begin 
				d_pg=0;
				p_cr=0;
				p_fe=1;
				p_ho=1;
				CRONO_FIN=0;
				AMPM=0; 
				FORMATO=0;
				HREL=8'h04;
				MREL=8'h08; 
				SREL=8'h33;
				DIA=8'h60;
				MES=8'h91;
				ANIO=8'h50;
				HCRON=8'h27;
				MCRON=8'h08;
				SCRON=8'h01;
				HRUN=8'h95;
				MRUN=8'h75; 
				SRUN=8'h35;
			end
	end
	 
endmodule
