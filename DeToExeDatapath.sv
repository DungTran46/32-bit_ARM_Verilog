module DetoExeDatapath(	input logic clk, reset,
						input logic [31:0]Instr,WD3,
						input logic WE3,
						input logic [3:0] A3,
						input logic [31:0]PCPLUS4,
						input logic [31:0]PCPLUS8,
						input logic [3:0] Flags,
						input logic FlushE,
						output logic [1:0]OpE,
						output logic [11:0]InstrOffesetE,// bit 6 and 5 of the instruction
						output logic [1:0]FlagWE,
						output logic [3:0]condE,
						output logic PCSE, RegWE, MemWE, branchE, 
						output logic MemtoRegE, ALUSrcE, 
						output logic [3:0] ALUControlE,
						output logic [31:0] RD1E, RD2E, ExtimmE,
						output logic [3:0] writeAdressE,
						output logic [3:0] FlagsE,
						output logic [1:0]Funct20E,
						output logic IE,
						output logic carryOut_ControlE,
						output logic [3:0] RA1D,RA2D,RA1E,RA2E,
						output logic PCS,
						output logic [31:0] PCPLUS4E,
						output logic branchLinkE
						);
						
	logic [1:0] ImmSrc;
	logic [2:0]RegSrc;
	logic shRA1Control;
	logic [1:0] FlagW;
	logic RegW, MemW;
	logic MemtoReg, ALUSrc, branch;
	logic [3:0] ALUControl;
	logic newcarryOut_Control;
	logic [3:0] RA1, RA2, shiftRA1;
	logic [31:0] RD1, RD2, ExtImm;
	logic [1:0] temp;
	assign temp= {Instr[22],Instr[20]};

	controlUnit c(	clk, reset, Instr[27:26],Instr[25:20], Instr[15:12], Instr[7],
					Instr[4],FlagW,PCS, RegW, MemW, MemtoReg, ALUSrc,
					branch, ImmSrc, RegSrc, ALUControl, shRA1Control,
					newcarryOut_Control
				);
				
	mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], shiftRA1);
	mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
	mux2 #(4) ra1Shiftmux(shiftRA1,Instr[11:8],shRA1Control,RA1);
	//mux2 #(4) wa3mux(A3,4'b1110, RegSrc[2],WA3);
	
	//For Stall, need to output for hazard unit
	assign RA1D = RA1;
	assign RA2D = RA2;
	
	//register file
	regfile rf(~clk, WE3, RA1, RA2,
				A3, WD3, PCPLUS8,
				RD1, RD2);
	extend ext(Instr[23:0], ImmSrc, ExtImm);
	
	//Pileline register
	DeToExe DtoE(clk, reset, PCPLUS4, RegSrc[2], Instr[27:26], Instr[11:0], FlagW, Instr[31:28], PCS,
					RegW, MemW, branch, MemtoReg, ALUSrc, ALUControl, RD1,RD2,
					ExtImm, Instr[15:12], Flags, temp, Instr[25], newcarryOut_Control, RA1, RA2, FlushE,
					OpE, InstrOffesetE, FlagWE, condE, PCSE, RegWE, MemWE, branchE,
					MemtoRegE, ALUSrcE, ALUControlE, RD1E, RD2E, ExtimmE,
					writeAdressE, FlagsE, Funct20E, IE, carryOut_ControlE,RA1E,RA2E, PCPLUS4E,branchLinkE
				);
endmodule
	
