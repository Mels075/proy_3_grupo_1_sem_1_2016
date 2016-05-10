`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:09:36 05/07/2016 
// Design Name: 
// Module Name:    Sistema 
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
module Sistema(
    input CLK,
	 input rst,
	 input [7:0]sw1,
	 input [7:0]sw2,
	 output wire [7:0]segcode1,
	 output wire [3:0]digit1,digit2


    );
wire	[11:0]	address;
wire	[17:0]	instruction;
wire			bram_enable;
wire	[7:0]		port_id;
wire	[7:0]		out_port;
reg	[7:0]		in_port;
wire			write_strobe;
wire			k_write_strobe;
wire			read_strobe;
wire			interrupt;            //See note above
wire			interrupt_ack;
wire			kcpsm6_sleep;         //See note above
wire			kcpsm6_reset;         //See note above


kcpsm6 #(
	.interrupt_vector	(12'h3FF),
	.scratch_pad_memory_size(64),
	.hwbuild		(8'h00))
  processor (
	.address 		(address),
	.instruction 	(instruction),
	.bram_enable 	(bram_enable),
	.port_id 		(port_id),
	.write_strobe 	(write_strobe),
	.k_write_strobe 	(k_write_strobe),
	.out_port 		(out_port),
	.read_strobe 	(read_strobe),
	.in_port 		(in_port),
	.interrupt 		(interrupt),
	.interrupt_ack 	(interrupt_ack),
	.reset 		(kcpsm6_reset),
	.sleep		(kcpsm6_sleep),
	.clk 			(CLK)); 


prueba #(
	.C_FAMILY		   ("7S"),   	//Family 'S6' or 'V6'
	.C_RAM_SIZE_KWORDS	(2),  	//Program size '1', '2' or '4'
	.C_JTAG_LOADER_ENABLE	(1))  	//Include JTAG Loader when set to '1' 
  program_rom (    				//Name to match your PSM file
 	.rdl 			(kcpsm6_reset),
	.enable 		(bram_enable),
	.address 		(address),
	.instruction 	(instruction),
	.clk 			(CLK));
	
	
Codificador_7_Seg seven_segments(.Disp(out_port),.id_port(port_id),.wr_reg(write_strobe),.reset(rst),.clk_d(CLK),
									.codificacion1(segcode1),.digito1(digit1),.digito2(digit2)
									);

always @(posedge CLK)
begin
	
	if (read_strobe==1)
	begin
	case (port_id)
	8'h00:in_port<=sw1;
	8'h01:in_port<=sw2;
	default in_port<=sw1;
	endcase
	end

end

assign kcpsm6_sleep = 1'b0;
assign interrupt = 1'b0;
endmodule
