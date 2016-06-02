`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:17:49 05/23/2016 
// Design Name: 
// Module Name:    Decodificador_tecla 
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
module Decodificador_tecla(
    input reset, CLK_Nexys,
	 input [7:0] TECLA_IN,
	 input interrupt_paro,
	 output [7:0] TECLA_OUT,
	 output reg interrupt
	 );
	 
	 reg tecla_correcta;
	 reg [7:0] tecla_ant;
	 reg [7:0] tecla_sig;
	 
	 always @*
	 begin
		case (TECLA_IN)
			8'h03: tecla_correcta=1'b1; //F5
			8'h04: tecla_correcta=1'b1; //F3
			8'h05: tecla_correcta=1'b1; //F1
			8'h06: tecla_correcta=1'b1; //F2
			8'h0c: tecla_correcta=1'b1; //F4
			8'h16: tecla_correcta=1'b1; //1
			8'h1e: tecla_correcta=1'b1; //2
			8'h25: tecla_correcta=1'b1; //4
			8'h26: tecla_correcta=1'b1; //3
			8'h2e: tecla_correcta=1'b1; //5
			8'h36: tecla_correcta=1'b1; //6
			8'h3d: tecla_correcta=1'b1; //7
			8'h3e: tecla_correcta=1'b1; //8
			8'h45: tecla_correcta=1'b1; //0
			8'h46: tecla_correcta=1'b1; //9
			8'h6b: tecla_correcta=1'b1; //?
			8'h74: tecla_correcta=1'b1; //?
			8'h76: tecla_correcta=1'b1; //ESC
			default:  tecla_correcta=1'b0; 
		endcase
	 end
	 //Flip-Flop tipo D para ingresar el dato y mantenerlo un ciclo de reloj
	 always @(posedge CLK_Nexys)
	 begin
      if (reset) tecla_ant <= 8'h00;
      else tecla_ant <= TECLA_IN;
	 end
	 always @(posedge CLK_Nexys)
	 begin
	 	if (reset) tecla_sig <= 8'h00;
	 	else tecla_sig <= tecla_ant;
	 end
	 
	 always @ (posedge CLK_Nexys)
	 begin
		if (interrupt_paro) interrupt <= 1'b0;
		else if ((tecla_ant != tecla_sig) && tecla_correcta) interrupt <= 1'b1;  // Son diferentes para evitar que se manden interrupts a cada rato
	 end
	 
	 assign TECLA_OUT = tecla_ant;
	 
endmodule
