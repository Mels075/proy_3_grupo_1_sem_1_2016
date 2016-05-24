`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:11:04 05/23/2016 
// Design Name: 
// Module Name:    TEST 
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
module TEST(
	input [2:0] interruptor,
	input OROLOGIO, BEGINNING,
	output [7:0] color_out,
	output hsincroni, vsincroni
    );

	wire [7:0] Ah_oro, Am_oro, As_oro;
	wire [7:0] Agiorno, Amesse, Aagno;
	wire [7:0] Aora, Aminute, Asecondo;
	wire [7:0] AH_run, AM_run, AS_run;
	wire Afinale, Atempo, Aformatto;
	wire [1:0] Adireccion_prog;
	wire [2:0] Aprog_crono_dir, Aprog_fecha_dir, Aprog_hora_dir;
	
	Control_VGA inst_VGA(
	.reloj_nexys(OROLOGIO), .reset_total(BEGINNING),
	.direccion_prog(Adireccion_prog),
	.prog_crono_dir(Aprog_crono_dir), .prog_fecha_dir(Aprog_fecha_dir), .prog_hora_dir(Aprog_hora_dir),
	.finale(Afinale), .tempo(Atempo), .formatto(Aformatto),
	.h_oro(Ah_oro), .m_oro(Am_oro), .s_oro(As_oro),
	.giorno(Agiorno), .messe(Amesse), .agno(Aagno),
	.ora(Aora), .minute(Aminute), .secondo(Asecondo),
	.H_run(AH_run), .M_run(AM_run), .S_run(AS_run),
	.color_salida(color_out),
	.hsincro(hsincroni), .vsincro(vsincroni)
    );
	 
	Prueba inst_proof(
	.SW(interruptor),
	.d_pg(Adireccion_prog),
	.p_cr(Aprog_crono_dir), .p_fe(Aprog_fecha_dir), .p_ho(Aprog_hora_dir),
	.CRONO_FIN(Afinale), .AMPM(Atempo), .FORMATO(Aformatto),
	.HREL(Ah_oro), .MREL(Am_oro), .SREL(As_oro),
	.DIA(Agiorno), .MES(Amesse), .ANIO(Aagno), 
	.HCRON(Aora), .MCRON(Aminute),.SCRON(Asecondo), 
	.HRUN(AH_run), .MRUN(AM_run), .SRUN(AS_run)
    );


endmodule
