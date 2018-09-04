module ExeToMemDatapath(input logic clk, reset,
						input logic [31:0] PCPlus4E,
						input logic branchLinkE,
						input logic [1:0]hazardmuxControlA,hazardmuxControlB,
						input logic [31:0] forward_ALUResultM,forward_ResultW,
						input logic [1:0]OpE,
						input logic [11:0]InstrOffesetE,
						input logic [1:0]FlagWE,
						input logic [3:0]condE,
						input logic PCSE, RegWE, MemWE, branchE, 
						input logic MemtoRegE, ALUSrcE, 
						input logic [3:0] ALUControlE,
						input logic [31:0] RD1E, RD2E, ExtimmE,
						input logic [3:0] WA3E,
						input logic [3:0] FlagsE,
						input logic [1:0]Funct20E,
						input logic IE,carryOut_ControlE,
						output logic [3:0]outputFlags,
						output logic [31:0]ALUResultM, WriteDataM, 
						output logic [3:0]WA3M,
						output logic PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
						output logic [3:0]beM,
						output logic Branch,
						output logic [31:0] ALUResult, PCPlus4M,
						output logic branchLinkM
						);
						
	logic [31:0]shifterSrcB, shift_operand,SrcA, SrcB;
	logic shifterCarryout, newCarryout ,condEx;
	logic [3:0]ALUFlags,newFlags, be;
	logic PCSrc, MemWrite, RegWrite,branchLink;
	
	assign newFlags={ALUFlags[3:2], newCarryout, ALUFlags[0]};
	assign Branch= branchE & condEx;
	assign PCSrc= (condEx & PCSE);
	assign RegWrite= RegWE & condEx;
	assign MemWrite= MemWE & condEx;
	assign branchLink=branchLinkE&condEx;
	mux3 #(32) harzardMux1(RD1E, forward_ResultW, forward_ALUResultM, hazardmuxControlA, SrcA);
	mux3 #(32) harzardMux2(RD2E,  forward_ResultW, forward_ALUResultM,hazardmuxControlB, SrcB);
	mux2 #(32) shifterSrcBMux(SrcB, ExtimmE, ALUSrcE, shifterSrcB);		
	shifter sh(InstrOffesetE, OpE, SrcA, shifterSrcB, IE, FlagsE[1], 
				shift_operand, shifterCarryout);
	alu alu(FlagsE[1], SrcA, shift_operand, ALUControlE, ALUResult,ALUFlags);
	mux2 #(1) carryoutMux(shifterCarryout,ALUFlags[1], carryOut_ControlE, newCarryout);
	
	condUnit cu(FlagsE, newFlags, condE, OpE, FlagWE, InstrOffesetE[6:5], ALUResult[1:0],
				Funct20E, condEx, outputFlags, be);
				
	ExeToMem EtoM(clk, reset, PCPlus4E, branchLink, ALUResult, SrcB, WA3E, PCSrc, RegWrite, MemtoRegE, MemWrite,
					be, ALUResultM, WriteDataM, WA3M, PCSrcM, RegWriteM, MemtoRegM, MemWriteM, beM, PCPlus4M, branchLinkM);
				
endmodule