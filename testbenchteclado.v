`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:40:38 05/24/2016
// Design Name:   Lector_teclado
// Module Name:   D:/Escritorio/Picoblaze/testbenchteclado.v
// Project Name:  Picoblaze
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Lector_teclado
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testbenchteclado;

	// Inputs
	reg CLK;
	reg RST;
	reg PS2D;
	reg PS2C;
	reg interrupcion_paro;

	// Outputs
	wire [7:0] TECLA;
	wire interrupcion;

	// Instantiate the Unit Under Test (UUT)
	Lector_teclado uut (
		.CLK(CLK), 
		.RST(RST), 
		.PS2D(PS2D), 
		.PS2C(PS2C), 
		.interrupcion_paro(interrupcion_paro), 
		.TECLA(TECLA), 
		.interrupcion(interrupcion)
	);

	initial begin
		// Initialize Inputs
		CLK = 0;
		RST = 1;
		PS2D = 0;
		PS2C = 0;
		interrupcion_paro = 0;

		// Wait 100 ns for global reset to finish
		#30;
		RST = 0;
      

	end
   always
	begin
		#5 CLK=!CLK;
	end
	always
	begin
		#50000 PS2C=!PS2C;
	end
	
endmodule

