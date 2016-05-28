`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:37:31 05/17/2016 
// Design Name: 
// Module Name:    VGA_b 
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
	module VGA_b(
    input clk_PARPADEO, CLK_NEXYS, clk_VGA,
	 input [9:0] PIX_X, PIX_Y,
	 input [7:0] HORA, MIN, SEG, DIA, MES, YEAR, HCRONO, MCRONO, SCRONO, HCRONO_RUN, MCRONO_RUN, SCRONO_RUN,
	 input FIN_CRONO, AM_PM, HFORMATO,
	 input [2:0] DIR_CURSOR,			//indica la posición del cursor en la programación
	 input [7:0] PROGRAMANDO_LUGAR,					//indica que cosa el usuario desea programar o si no desea programar nada
	 output reg [7:0] COLOUR
	 );
	 // Se define el tamaño de cada imagen y la posición en la que van a estar
	 localparam imagenhoraT = 12'd3800;
	 localparam imagenhoraX = 7'd95;
	 localparam imagenhoraY = 6'd40;
	 localparam X_hora = 7'd85;
	 localparam Y_hora = 6'd48;
	 
	 localparam imagencronoT = 14'd10080;
	 localparam imagencronoX = 8'd252;
	 localparam imagencronoY = 6'd40;
	 localparam X_crono = 8'd194;
	 localparam Y_crono = 8'd192;
	 
	 localparam imagenfechaT = 12'd3844;
	 localparam imagenfechaX = 7'd124;
	 localparam imagenfechaY = 6'd31;
	 localparam X_fecha = 9'd434;
	 localparam Y_fecha = 6'd50;
	 
	 localparam imagenescT = 12'd2880;
	 localparam imagenescX = 7'd80;
	 localparam imagenescY = 6'd36;
	 localparam X_esc = 10'd524;
	 localparam Y_esc = 9'd360;
	 
	 localparam imagendespT = 12'd3960;
	 localparam imagendespX = 7'd90;
	 localparam imagendespY = 6'd44;
	 localparam X_desp = 9'd405;
	 localparam Y_desp = 9'd406;
	 
	 localparam imagenT_teclasfuncT = 13'd6885;
	 localparam imagenT_teclasfuncX = 8'd255;
	 localparam imagenT_teclasfuncY = 5'd27;
	 localparam X_T_teclasfunc = 5'd30;
	 localparam Y_T_teclasfunc = 9'd300;
	 
	 localparam imagenTX_teclasfuncT = 15'd20880;
	 localparam imagenTX_teclasfuncX = 8'd174;
	 localparam imagenTX_teclasfuncY = 7'd120;
	 localparam X_TX_teclasfunc = 5'd30;
	 localparam Y_TX_teclasfunc = 9'd330;
	 
	 //VARIABLES NECESARIAS PARA LAS IMAGENES (INDICES Y ARREGLOS)
	 wire [11:0] STATE_HORA;
	 wire [13:0] STATE_CRONO;
	 wire [11:0] STATE_FECHA;
	 wire [11:0] STATE_ESC;
	 wire [11:0] STATE_DESP;
	 wire [12:0] STATE_T_TECLASFUNC;
	 wire [14:0] STATE_TX_TECLASFUNC;
	 
	 reg [7:0] COLOUR_HORA [0:imagenhoraT-1];
	 reg [7:0] COLOUR_CRONO [0:imagencronoT-1];
	 reg [7:0] COLOUR_FECHA [0:imagenfechaT-1];
	 reg [7:0] COLOUR_ESC [0:imagenescT-1];
	 reg [7:0] COLOUR_DESP [0:imagendespT-1];
	 reg [7:0] COLOUR_T_TECLASFUNC [0:imagenT_teclasfuncT-1];
	 reg [7:0] COLOUR_TX_TECLASFUNC [0:imagenTX_teclasfuncT-1];
	 
	 //SE CREAN LAS VARIABLES NECESARIAS PARA LA ROM
	 reg [7:0] COLOUR_ROM;
	 reg [6:0] M, X_AP, U_FORMATO, D_FORMATO, RING_A, RING_B;
	 //Entradas de la ROM
	 wire [11:0] DIR_MEMO;		
	 wire [15:0] PALABRA;
	 wire fuente_bit;
	 // Utilizadas para indicar si se debe escribir según la posición
	 wire hora, formato_hora;
	 wire fecha, formato_fecha;
	 wire crono_set, crono_run, ring;    
	 //direcciones de las columnas y filas
	 reg [3:0] DIR_BIT;
	 wire [3:0] db_hora, db_formato_hora;
	 wire [3:0] db_fecha, db_formato_fecha;
	 wire [3:0] db_crono_set, db_crono_run, db_ring;
	 reg [4:0] DIR_FILA;
	 wire [4:0] df_hora, df_formato_hora;
	 wire [4:0] df_fecha, df_formato_fecha;
	 wire [4:0] df_crono_set, df_crono_run, df_ring;
	 //Para los caracteres
	 reg [6:0] CARACTER;
	 reg [6:0] caracter_hora, caracter_formato_hora;
	 reg [6:0] caracter_fecha, caracter_formato_fecha;
	 reg [6:0] caracter_crono_set, caracter_crono_run, caracter_ring;
	 
	 // INSTANCIA DE LA ROM PARA LAS LETRAS Y CREACIÓN DE LAS VARIABLES NECESARIAS
	 ROM_masres instancia_ROM_fuente(
	 .clk(CLK_NEXYS),
    .addr(DIR_MEMO),
    .data(PALABRA)
	 );
	 
	 //LEE LOS ARCHIVOS DE LAS IMAGENES
	 initial
	 begin
	 $readmemh ("hora.list", COLOUR_HORA);				//Lee el archivo de la imagen
	 $readmemh ("crono.list", COLOUR_CRONO);
	 $readmemh ("fecha.list", COLOUR_FECHA);
	 $readmemh ("esc.list", COLOUR_ESC);
	 $readmemh ("desp.list", COLOUR_DESP);
	 $readmemh ("T_teclasfunc.list", COLOUR_T_TECLASFUNC);
	 $readmemh ("TX_teclasfunc.list", COLOUR_TX_TECLASFUNC);
	 end
	 
	 //CREA LOS INDICES PARA CADA IMAGEN
	 assign STATE_HORA = ((PIX_X-X_hora)*imagenhoraY)+PIX_Y-Y_hora;
	 assign STATE_CRONO = (PIX_X-X_crono)*imagencronoY+PIX_Y-Y_crono;
	 assign STATE_FECHA = (PIX_X-X_fecha)*imagenfechaY+PIX_Y-Y_fecha;
	 assign STATE_ESC = (PIX_X-X_esc)*imagenescY+PIX_Y-Y_esc;
	 assign STATE_DESP = (PIX_X-X_desp)*imagendespY+PIX_Y-Y_desp;
	 assign STATE_T_TECLASFUNC = (PIX_X-X_T_teclasfunc)*imagenT_teclasfuncY+PIX_Y-Y_T_teclasfunc;
	 assign STATE_TX_TECLASFUNC = (PIX_X-X_TX_teclasfunc)*imagenTX_teclasfuncY+PIX_Y-Y_TX_teclasfunc;
	 
	 
//**********************************************************************************************************************
	 always@(posedge clk_VGA)		//SELECCIONA EL COLOR QUE VA A LA SALIDA DEL MODULO Y POR TANTO EL COLOR DE LA PANTALLA
	 begin
		if (PIX_X>=X_hora && PIX_X<X_hora+imagenhoraX && PIX_Y>=Y_hora && PIX_Y<Y_hora+imagenhoraY)
				COLOUR <= COLOUR_HORA[{STATE_HORA}];
		else if (PIX_X>=X_crono && PIX_X<X_crono+imagencronoX && PIX_Y>=Y_crono && PIX_Y<Y_crono+imagencronoY)
				COLOUR <= COLOUR_CRONO[{STATE_CRONO}];
		else if (PIX_X>=X_fecha && PIX_X<X_fecha+imagenfechaX && PIX_Y>=Y_fecha && PIX_Y<Y_fecha+imagenfechaY)
				COLOUR <= COLOUR_FECHA[{STATE_FECHA}];
	   else if (PIX_X>=X_esc && PIX_X<X_esc+imagenescX && PIX_Y>=Y_esc && PIX_Y<Y_esc+imagenescY)
				COLOUR <= COLOUR_ESC[{STATE_ESC}];
	   else if (PIX_X>=X_desp && PIX_X<X_desp+imagendespX && PIX_Y>=Y_desp && PIX_Y<Y_desp+imagendespY)
				COLOUR <= COLOUR_DESP[{STATE_DESP}];
		else if (PIX_X>=X_T_teclasfunc && PIX_X<X_T_teclasfunc+imagenT_teclasfuncX && PIX_Y>=Y_T_teclasfunc && PIX_Y<Y_T_teclasfunc+imagenT_teclasfuncY)
				COLOUR <= COLOUR_T_TECLASFUNC[{STATE_T_TECLASFUNC}];
		else if (PIX_X>=X_TX_teclasfunc && PIX_X<X_TX_teclasfunc+imagenTX_teclasfuncX && PIX_Y>=Y_TX_teclasfunc && PIX_Y<Y_TX_teclasfunc+imagenTX_teclasfuncY)
				COLOUR <= COLOUR_TX_TECLASFUNC[{STATE_TX_TECLASFUNC}]; 
		else COLOUR <= COLOUR_ROM;
	 end
	 
	 //TODAS LAS LETRAS Y NUMEROS SE TRABAJAN EN TAMAÑO 16X32
	 //ESTA PARTE SIGUIENTE CORRESPONDE A LA LÓGICA PARA USAR LA ROM
	 assign hora = (80<=PIX_X)&&(PIX_X<256) && (96<=PIX_Y)&&(PIX_Y<128);
	 assign db_hora = PIX_X[3:0];
	 assign df_hora = PIX_Y[4:0];
	 always @*
	 begin
		 if (HFORMATO)							//formato 12h
			begin
				M = 7'h63;							//m
				if (AM_PM) X_AP = 7'h64;		//p
				else X_AP = 7'h61;				//a
			end
		else
			begin
				M = 7'h00;							//
				X_AP = 7'h00;						//
			end
		case (PIX_X[7:4])
			4'h5: caracter_hora = {3'b011,HORA[7:4]};
			4'h6: caracter_hora = {3'b011,HORA[3:0]};
			4'h7: caracter_hora = 7'h3a;
			4'h8: caracter_hora = {3'b011,MIN[7:4]};
			4'h9: caracter_hora = {3'b011,MIN[3:0]};
			4'ha: caracter_hora = 7'h3a;
			4'hb: caracter_hora = {3'b011,SEG[7:4]};
			4'hc: caracter_hora = {3'b011,SEG[3:0]};
			4'he: caracter_hora = X_AP;
			4'hf: caracter_hora = M;
			default: caracter_hora = 7'h00;
		endcase
	 end
	 
	 assign formato_hora = (112<=PIX_X)&&(PIX_X<160) && (128<=PIX_Y)&&(PIX_Y<160);
	 assign db_formato_hora = PIX_X[3:0];
	 assign df_formato_hora = PIX_Y[4:0];
	 always @*
	 begin
		if (HFORMATO)					//formato 12h
		begin
			U_FORMATO = {3'b011,4'd1};
			D_FORMATO = {3'b011,4'd2};
		end
		else								//formato 24h
		begin
			U_FORMATO = {3'b011,4'd2};
			D_FORMATO = {3'b011,4'd4};
		end
		case (PIX_X[7:4])
			4'h7: caracter_formato_hora = U_FORMATO;
			4'h8: caracter_formato_hora = D_FORMATO;
			4'h9: caracter_formato_hora = 7'h62;
			default: caracter_formato_hora = 7'h00;
		endcase
	 end
	 
	 assign fecha = (432<=PIX_X)&&(PIX_X<560) && (96<=PIX_Y)&&(PIX_Y<128);
	 assign db_fecha = PIX_X[3:0];
	 assign df_fecha = PIX_Y[4:0]; 
	 always @*
	 begin
		case (PIX_X[7:4])
			4'hb: caracter_fecha = {3'b011,DIA[7:4]};
			4'hc: caracter_fecha = {3'b011,DIA[3:0]};
			4'hd: caracter_fecha = 7'h3d;
			4'he: caracter_fecha = {3'b011,MES[7:4]};
			4'hf: caracter_fecha = {3'b011,MES[3:0]};
			4'h0: caracter_fecha = 7'h3d;
			4'h1: caracter_fecha = {3'b011,YEAR[7:4]};
			4'h2: caracter_fecha = {3'b011,YEAR[3:0]};
			default: caracter_fecha = 7'h00;
		endcase
	 end
	 
	 assign formato_fecha = (432<=PIX_X)&&(PIX_X<560) && (128<=PIX_Y)&&(PIX_Y<160);
	 assign db_formato_fecha = PIX_X[3:0];
	 assign df_formato_fecha = PIX_Y[4:0]; 
	 always @*
	 begin
		case (PIX_X[7:4])
			4'hb: caracter_formato_fecha = 7'h65;
			4'hc: caracter_formato_fecha = 7'h65;
			4'hd: caracter_formato_fecha = 7'h3d;
			4'he: caracter_formato_fecha = 7'h63;
			4'hf: caracter_formato_fecha = 7'h63;
			4'h0: caracter_formato_fecha = 7'h3d;
			4'h1: caracter_formato_fecha = 7'h61;
			4'h2: caracter_formato_fecha = 7'h61;
			default: caracter_formato_fecha = 7'h00;
		endcase
	 end
	 
	 assign crono_set = (128<=PIX_X)&&(PIX_X<256) && (246<=PIX_Y)&&(PIX_Y<278);
	 assign db_crono_set = PIX_X[3:0];
	 assign df_crono_set = PIX_Y[4:0] + 5'b01010; 
	 always @*
	 begin
		case (PIX_X[6:4])
			3'h0: caracter_crono_set = {3'b011,HCRONO[7:4]};		//decenas
			3'h1: caracter_crono_set = {3'b011,HCRONO[3:0]};		//unidades
			3'h2: caracter_crono_set = 7'h3a;
			3'h3: caracter_crono_set = {3'b011,MCRONO[7:4]};
			3'h4: caracter_crono_set = {3'b011,MCRONO[3:0]};
			3'h5: caracter_crono_set = 7'h3a;
			3'h6: caracter_crono_set = {3'b011,SCRONO[7:4]};
			3'h7: caracter_crono_set = {3'b011,SCRONO[3:0]};
		endcase
	 end
	 
	 assign crono_run = (384<=PIX_X)&&(PIX_X<512) && (246<=PIX_Y)&&(PIX_Y<278);
	 assign db_crono_run = PIX_X[3:0];
	 assign df_crono_run = PIX_Y[4:0] + 5'b01010; 
	 always @*
	 begin
		case (PIX_X[6:4])
			3'h0: caracter_crono_run = {3'b011,HCRONO_RUN[7:4]};
			3'h1: caracter_crono_run = {3'b011,HCRONO_RUN[3:0]};
			3'h2: caracter_crono_run = 7'h3a;
			3'h3: caracter_crono_run = {3'b011,MCRONO_RUN[7:4]};
			3'h4: caracter_crono_run = {3'b011,MCRONO_RUN[3:0]};
			3'h5: caracter_crono_run = 7'h3a;
			3'h6: caracter_crono_run = {3'b011,SCRONO_RUN[7:4]};
			3'h7: caracter_crono_run = {3'b011,SCRONO_RUN[3:0]};
		endcase
	 end
	 
	 assign ring = (304<=PIX_X)&&(PIX_X<336) && (246<=PIX_Y)&&(PIX_Y<278);
	 assign db_ring = PIX_X[3:0];
	 assign df_ring = PIX_Y[4:0] + 5'b01010;
	 always @*
	 begin
		case (FIN_CRONO)
			1'b0: begin RING_A = 7'h00; RING_B = 7'h00; end
			1'b1: begin RING_A = 7'h3b; RING_B = 7'h3c; end
		endcase
		case (PIX_X[4])
			1'b0: caracter_ring = RING_B;
			1'b1: caracter_ring = RING_A;
		endcase
	 end
	 
	//************************************************************************************
	 always@*
	 begin
		COLOUR_ROM = 8'h49;					//COLOR DE FONDO
		if (hora)
			begin CARACTER = caracter_hora; DIR_FILA = df_hora; DIR_BIT=db_hora;
				if (PROGRAMANDO_LUGAR==8'h05)														//Se esta programando hora
				begin
					if (~clk_PARPADEO)
					begin
						if ((DIR_CURSOR==0 && PIX_X[7:4]==4'h5) || (DIR_CURSOR==1 && PIX_X[7:4]==4'h6) ||
							 (DIR_CURSOR==2 && PIX_X[7:4]==4'h8) || (DIR_CURSOR==3 && PIX_X[7:4]==4'h9) ||
							 (DIR_CURSOR==4 && PIX_X[7:4]==4'hb) || (DIR_CURSOR==5 && PIX_X[7:4]==4'hc)) COLOUR_ROM = 8'h49;
						else if (fuente_bit) COLOUR_ROM = 8'h14;
					end
					else if (clk_PARPADEO && fuente_bit) COLOUR_ROM = 8'h14;
				end
				else if (fuente_bit && PROGRAMANDO_LUGAR!=8'h05) COLOUR_ROM = 8'h14;
			end
			
		else if (formato_hora)
			begin CARACTER = caracter_formato_hora; DIR_FILA = df_formato_hora; DIR_BIT=db_formato_hora;
				if (fuente_bit) COLOUR_ROM = 8'h14;
			end
			
		else if (fecha)
			begin CARACTER = caracter_fecha; DIR_FILA = df_fecha; DIR_BIT=db_fecha;
				if (PROGRAMANDO_LUGAR==8'h06)														//se esta programando fecha
				begin
					if (~clk_PARPADEO)
					begin
						if ((DIR_CURSOR==0 && PIX_X[7:4]==4'hb) || (DIR_CURSOR==1 && PIX_X[7:4]==4'hc) ||
							 (DIR_CURSOR==2 && PIX_X[7:4]==4'he) || (DIR_CURSOR==3 && PIX_X[7:4]==4'hf) ||
							 (DIR_CURSOR==4 && PIX_X[7:4]==4'h1) || (DIR_CURSOR==5 && PIX_X[7:4]==4'h2)) COLOUR_ROM = 8'h49;
						else if (fuente_bit) COLOUR_ROM = 8'h14;
					end
					else if (clk_PARPADEO && fuente_bit) COLOUR_ROM = 8'h14;
				end
				else if (fuente_bit && PROGRAMANDO_LUGAR!=8'h06) COLOUR_ROM = 8'h14;
			end
			
		else if (formato_fecha)
			begin CARACTER = caracter_formato_fecha; DIR_FILA = df_formato_fecha; DIR_BIT=db_formato_fecha;
				if (fuente_bit) COLOUR_ROM = 8'h14;
			end
			
		else if (crono_set)
			begin CARACTER = caracter_crono_set; DIR_FILA = df_crono_set; DIR_BIT=db_crono_set;
				if (PROGRAMANDO_LUGAR==8'h04)														// se esta programando cronometro
				begin
					if (~clk_PARPADEO)
					begin
						if ((DIR_CURSOR==0 && PIX_X[6:4]==3'h0) || (DIR_CURSOR==1 && PIX_X[6:4]==3'h1) ||
							 (DIR_CURSOR==2 && PIX_X[6:4]==3'h3) || (DIR_CURSOR==3 && PIX_X[6:4]==3'h4) ||
							 (DIR_CURSOR==4 && PIX_X[6:4]==3'h6) || (DIR_CURSOR==5 && PIX_X[6:4]==3'h7)) COLOUR_ROM = 8'h49;
						else if (fuente_bit) COLOUR_ROM = 8'h14;
					end
					else if (clk_PARPADEO && fuente_bit) COLOUR_ROM = 8'h14;
				end
				else if (fuente_bit && PROGRAMANDO_LUGAR!=8'h04) COLOUR_ROM = 8'h14;
			end
			
		else if (crono_run)
			begin CARACTER = caracter_crono_run; DIR_FILA = df_crono_run; DIR_BIT=db_crono_run;
				if (fuente_bit) COLOUR_ROM = 8'h14;
			end
			
		else if (ring)
			begin CARACTER = caracter_ring; DIR_FILA = df_ring; DIR_BIT=db_ring;
				if (~clk_PARPADEO) COLOUR_ROM = 8'h49;
				else if (fuente_bit) COLOUR_ROM = 8'he0;
			end
		else 
			begin CARACTER = 7'h00; DIR_FILA = 5'h00; DIR_BIT=4'h0;
			end
	 end

	 
	 
	 assign DIR_MEMO={CARACTER,DIR_FILA};
	 assign fuente_bit=PALABRA[~DIR_BIT];
endmodule
