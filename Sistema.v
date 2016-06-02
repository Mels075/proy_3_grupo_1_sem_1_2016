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
	 input [7:0]Data_in,
	 input PS2C,
	 input PS2D,
	 output [7:0]Data_out,
	 output wire [3:0]control_rtc,
	 output wire [7:0] color_salida,
	 output wire hsincro,
	 output wire vsincro, sound
    );
wire	[11:0]	address;
wire	[17:0]	instruction;
wire			bram_enable;
wire	[7:0]		port_id;
wire	[7:0]		out_port;
reg	[7:0]		in_port;
wire			write_strobe;
//wire			k_write_strobe;
//wire			read_strobe;
wire			interrupt;            //See note above
wire			interrupt_ack;
wire			kcpsm6_sleep;         //See note above
wire			kcpsm6_reset;         //See note above
wire PUP;
wire [7:0]ADOUT,datoext,AmPmformato,listoRTC;
reg reset;
wire [7:0] TECLA;

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
	.k_write_strobe 	(),
	.out_port 		(out_port),
	.read_strobe 	(),
	.in_port 		(in_port),
	.interrupt 		(interrupt),
	.interrupt_ack 	(interrupt_ack),
	.reset 		(kcpsm6_reset),
	.sleep		(kcpsm6_sleep),
	.clk 			(CLK)); 


ROM_inst #(
	.C_FAMILY		   ("S6"),   	//Family 'S6' or 'V6'
	.C_RAM_SIZE_KWORDS	(2),  	//Program size '1', '2' or '4'
	.C_JTAG_LOADER_ENABLE	(0))  	//Include JTAG Loader when set to '1' 
  program_rom (    				//Name to match your PSM file
 	.rdl 			(kcpsm6_reset),
	.enable 		(bram_enable),
	.address 		(address),
	.instruction 	(instruction),
	.clk 			(CLK));
	
	
rtcp inst_rtcp(.ADin(Data_in),.clock(CLK),.reset(reset),.writef(write_strobe),.id_port(port_id),.dpico(out_port),
	 				.ADout(ADOUT),.ad(control_rtc[0]),.wr(control_rtc[3]),.rd(control_rtc[2]),.cs(control_rtc[1]),
					.datoext(datoext),.AmPmFor(AmPmformato),.ready(listoRTC),.Pup(PUP)); 

Lector_teclado instance_teclado (
    .CLK(CLK), 
    .RST(reset), 
    .PS2D(PS2D), 
    .PS2C(PS2C), 
    .interrupcion_paro(interrupt_ack), 
    .TECLA(TECLA), 
    .interrupcion(interrupt)
    );

Control_VGA instance_VGA (
    .reloj_nexys(CLK), 
    .reset_total(reset), 
    .dato(out_port), 
    .id_port(port_id), 
    .write_strobe(write_strobe), 
    .color_salida(color_salida), 
    .hsincro(hsincro), 
    .vsincro(vsincro), .audio(sound)
    );

always @(posedge CLK)
begin
	case (port_id)
	8'h00:begin in_port[3:0]<=datoext[7:4]; in_port[7:4]<=4'h0; 
			end
	8'h01:begin in_port[3:0]<=datoext[3:0]; in_port[7:4]<=4'h0; end
	8'h02:in_port<=AmPmformato;
	8'h03:in_port<=listoRTC;
	8'h04:in_port<=TECLA;
	default in_port<=8'hff;
	endcase

	if (write_strobe==1 && port_id==8'hff)reset<=out_port[0];
end

assign Data_out = (~PUP) ? ADOUT : 8'hzz;
assign kcpsm6_sleep = 1'b0;

endmodule
