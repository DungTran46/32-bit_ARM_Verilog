module DeToExe(	input logic clk, reset,
				input logic [31:0]PCPlus4D,
				input logic branchLinkD,
				input logic [1:0]opD,
				input logic [11:0]InstrOffesetD,// bit 6 and 5 of the instruction
				input logic [1:0]FlagWD,
				input logic	[3:0]condD,
				input logic PCSD, RegWD, MemWD, branchD, 
				input logic MemtoRegD, ALUSrcD, 
				input logic [3:0] ALUControlD,
				input logic [31:0] RD1D, RD2D, ExtimmD,
				input logic [3:0] writeAdressD,
				input logic [3:0] FlagsD,
				input logic [1:0] Funct20D,
				input logic ID, carryOut_ControlD,
				input logic [3:0] RA1D,RA2D,
				input logic FlushE,
				
				output logic [1:0]opE,
				output logic [11:0]InstrOffesetE,// bit 6 and 5 of the instruction
				output logic [1:0]FlagWE,
				output logic	[3:0]condE,
				output logic PCSE, RegWE, MemWE, branchE, 
				output logic MemtoRegE, ALUSrcE, 
				output logic [3:0] ALUControlE,
				output logic [31:0] RD1E, RD2E, ExtimmE,
				output logic [3:0] writeAdressE,
				output logic [3:0] FlagsE,
				output logic [1:0] Funct20E,
				output logic  IE, carryOut_ControlE,
				output logic [3:0] RA1E,RA2E,
				output logic [31:0] PCPlus4E,
				output logic branchLinkE
				);
				
	always_ff @(posedge clk, posedge reset)
	begin
		if (reset|FlushE) begin
			opE<=2'b0;
			InstrOffesetE <= 12'b0;// bit 6 and 5 of the instruction
			FlagWE <=2'b0;
			condE<= 4'b0;
			PCSE<=1'b0;
			RegWE<=1'b0;
			MemWE<=1'b0;
			branchE<=1'b0; 
			MemtoRegE<=1'b0;
			ALUSrcE<=1'b0;
			ALUControlE<=4'b0;
			RD1E<=32'b0;
			RD2E<=32'b0;
			ExtimmE<=32'b0;
			writeAdressE<=4'b0;
			FlagsE<=4'b0;
			Funct20E<=2'b0;
			IE=1'b0;
			carryOut_ControlE<=1'b0;
			RA1E<=0;
			RA2E<=0;
			PCPlus4E<=0;
			branchLinkE<=0;
		end
		else begin
			opE<=opD;
			InstrOffesetE <= InstrOffesetD;// bit 6 and 5 of the instruction
			FlagWE <=FlagWD;
			condE<= condD;
			PCSE<=PCSD;
			RegWE<=RegWD;
			MemWE<=MemWD;
			branchE<=branchD; 
			MemtoRegE<=MemtoRegD;
			ALUSrcE<=ALUSrcD;
			ALUControlE<=ALUControlD;
			RD1E<=RD1D;
			RD2E<=RD2D;
			ExtimmE<=ExtimmD;
			writeAdressE<=writeAdressD;
			FlagsE<=FlagsD;	
			Funct20E<=Funct20D;
			IE<=ID;
			carryOut_ControlE<=carryOut_ControlD;
			RA1E<=RA1D;
			RA2E<=RA2D;
			PCPlus4E<=PCPlus4D;
			branchLinkE<=branchLinkD;
		end
	end
endmodule
	