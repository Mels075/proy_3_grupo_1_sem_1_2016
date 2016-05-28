`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:05:27 05/24/2016
// Design Name:   Deteccion_tecla
// Module Name:   D:/Escritorio/Picoblaze/Test_detector.v
// Project Name:  Picoblaze
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Deteccion_tecla
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Test_detector;

	// Inputs
	reg clk_Nexys;
	reg Reset;
	reg [7:0] byte_dato;
	reg scan_done_tick;

	// Outputs
	wire [7:0] tecla;
	wire got_done_tick;

	// Instantiate the Unit Under Test (UUT)
	Deteccion_tecla uut (
		.clk_Nexys(clk_Nexys), 
		.Reset(Reset), 
		.byte_dato(byte_dato), 
		.scan_done_tick(scan_done_tick), 
		.tecla(tecla), 
		.got_done_tick(got_done_tick)
	);

	initial begin
		// Initialize Inputs
		clk_Nexys = 0;
		Reset = 1;
		byte_dato = 8'h00;
		scan_done_tick = 1;

		// Wait 100 ns for global reset to finish
		#30;
		Reset = 0;
		#30
		byte_dato = 8'hf0;
		#10
		byte_dato = 8'h1c;
		#10
		byte_dato = 8'hf0;
		scan_done_tick = 0;
		#30
		scan_done_tick = 1;
		#5
		byte_dato = 8'he3;
		
        
		// Add stimulus here

	end
	
	always
	begin
		#5 CLK=!CLK;
	end
	
endmodule

