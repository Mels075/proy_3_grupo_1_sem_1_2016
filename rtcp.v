`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:08:28 03/23/2016 
// Design Name: 
// Module Name:    
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
module rtcp(
    input [7:0] ADin,
	 input clock,
	 input reset,
	 input writef,
	 input [7:0]id_port,
	 input [7:0]dpico,
	 output reg [7:0] ADout,
    output reg ad,
    output reg wr,
    output reg rd,
    output reg cs,
	 output reg [7:0]datoext,
	 output reg [7:0]AmPmFor,
	 output reg [7:0]ready,
	 output reg Pup
    ); 
reg [7:0]funcion,datoW;

reg [5:0]cont;
reg [7:0]dir;


always @(posedge clock)
begin
	if (reset)
	begin
	ad<=1'h1;
	wr<=1'h1;
	rd<=1'h0;
	cs<=1'h1;
	ADout<=8'hff;
	cont<=0;
	AmPmFor<=0;
	datoext<=0;
	dir<=8'hff;
	Pup<=0;
	ready<=8'h00;
	datoW<=8'h00;
	end
	
	if (writef)
	begin
		case(id_port)
		8'h00:dir<=dpico;
		8'h01:funcion<=dpico;
		8'h02:datoW[7:4]<=dpico[3:0];
		8'h03:datoW[3:0]<=dpico[3:0];
		endcase
	end
	
	if (funcion==8'h01||funcion==8'h02) 
	begin
	if (cont==0)
	begin
	ready<=8'h00;
	ad<=1;
	wr<=1;
	rd<=1;
	cs<=1;
	Pup<=0;
	cont<=cont+1'b1;
	end
	else if (cont==1)
	begin
		ad<=0;
		cont<=cont+1'b1;
	end
	else if(cont==2)
		begin
		cs<=0;
		cont<=cont+1'b1;
		end
	else if (cont==3)
		begin
		wr<=0;
		cont<=cont+1'b1;
		end
	else if (cont==4)
		begin
		Pup<=0;
		ADout<=dir;
		cont<=cont+1'b1;
		end
	else if (cont==9)
		begin
		wr<=1;
		cont<=cont+1'b1;
		end
	else if (cont==10)
		begin
		cs<=1;
		cont<=cont+1'b1;
		end
	else if (cont==11)
		begin
		ad<=1;
		cont<=cont+1'b1;
		end
	else if (cont==13)
		begin
		ADout<=8'hff;
		if (funcion==8'h01)Pup<=1;
		cont<=cont+1'b1;
		end
	else if (cont==21)
		begin
		cs<=0;
		cont<=cont+1'b1;
		end
	else if (cont==22)
		begin
		if(funcion==8'h02)wr<=0;
		else rd<=0;
		cont<=cont+1'b1;
		end
	
	else if (cont==23&&funcion==8'h02)
		begin
		if (dir==8'h23)
		begin
			if (datoW[6:0]==7'h12&&AmPmFor[4]==0)ADout[6:0]<=00;
			else ADout[6:0]<=datoW[6:0];
			if (datoW[6:0]==7'h12&&AmPmFor[4]==1)ADout[7]<=0;
			else ADout[7]<=AmPmFor[4];
		end
	
		else ADout<=datoW;
		
		cont<=cont+1'b1;
		end
	
	else if (cont==28)
		begin
		if(funcion==8'h01)rd<=1;
		else if(funcion==8'h02)wr<=1;
		cont<=cont+1'b1;
		end
	
	else if (cont==29)
		begin
		if (funcion==8'h01)
		begin
			if (dir==8'h23)
				begin
					if (ADin[6:0]==7'h00&&AmPmFor[0]==1)datoext[6:0]<=7'h12;
					else datoext[6:0]<=ADin[6:0];
					datoext[7]<=0;
					if (ADin[6:0]==7'h12&&AmPmFor[0])AmPmFor[4]<=1;
					else AmPmFor[4]<=ADin[7];
				end
			else if (dir==8'h00)begin 
										AmPmFor[0]<=ADin[4];
										datoext<=ADin;
										end
			else datoext<=ADin;
		end
		cs<=1;
		cont<=cont+1'b1;
		end
	else if (cont==40)
		begin
		cont<=0;
		Pup<=0;
		funcion<=8'h00;
		ready<=8'hff;
		end
	else cont<=cont+1'b1;
	end

	else
	begin
	ADout<=8'hff;
	cs<=1'h1;
	ad<=1'h1;
	wr<=1'h1;
	rd<=1'h1;
	cont<=0;
	end
end
endmodule
