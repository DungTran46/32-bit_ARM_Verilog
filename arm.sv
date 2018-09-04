module top(input logic clk, reset,
			output logic [31:0] DataAdr,WriteData,
			output logic MemWrite);

	logic [31:0]ResultW;
	logic PCSrcW,PCSrcD;
	logic [31:0] PCPlus8D, InstrF, PCPlus4F;

	 logic [3:0] Flags;
	 logic [1:0]OpE;
	 logic [11:0]InstrOffesetE;// bit 6 and 5 of the instruction
	 logic [1:0]FlagWE;
	 logic [3:0]condE;
	 logic PCSE, RegWE, MemWE, branchE;
	 logic MemtoRegE, ALUSrcE;
	 logic [3:0] ALUControlE;
	 logic [31:0] RD1E, RD2E, ExtimmE;
	 logic [3:0] writeAdressE;
	 logic [3:0] FlagsE;
	 logic [1:0]Funct20E;
	 logic IE;
	 logic carryOut_ControlE;
	 
	logic [31:0]ALUResultM, WriteDataM;
	logic [3:0]writeAddressM;
	logic PCSrcM, RegWriteM, MemtoRegM, MemWriteM;
	logic [3:0]beM;
	
	logic RegWriteW, MemtoRegW;
	//output sent to dmem
	logic [3:0] WA3W;	
	logic [31:0] ALUOutW;
	logic [31:0] ReadDataW, ALUResultE;
	logic [3:0] RA1D,RA2D,RA1E,RA2E;
	
	logic [1:0] ForwardAE, ForwardBE;
	logic StallF, StallD, FlushE,FlushD;
	logic Match_12D_E;
	logic PCWrPendingF, BranchTakenE;
	logic [31:0] PCPlus4E, PCPlus4M, PCPlus4W;
	logic branchLinkE, branchLinkM, branchLinkW;
	logic [3:0] WA3;
	
	FetchtoDecodeDP FetchToDecode(clk,reset,ResultW, PCSrcW,StallF,StallD,FlushD,ALUResultE, BranchTakenE, PCPlus8D,InstrF,PCPlus4F );
	DetoExeDatapath DeToExe(clk, reset, InstrF, ResultW, RegWriteW, WA3,PCPlus4F,PCPlus8D,Flags,FlushE,
							OpE, InstrOffesetE, FlagWE, condE, PCSE, RegWE, MemWE,
							branchE, MemtoRegE, ALUSrcE, ALUControlE, RD1E, RD2E, ExtimmE,
							writeAdressE, FlagsE, Funct20E, IE, carryOut_ControlE,RA1D,RA2D,RA1E,RA2E,PCSrcD,PCPlus4E,branchLinkE);
	ExeToMemDatapath ExeToMem(clk,reset,PCPlus4E, branchLinkE, ForwardAE, ForwardBE, ALUResultM, ResultW, OpE, InstrOffesetE,FlagWE,condE, PCSE, RegWE,
								MemWE, branchE, MemtoRegE, ALUSrcE, ALUControlE,
								RD1E, RD2E, ExtimmE, writeAdressE, FlagsE, Funct20E, IE, carryOut_ControlE,
								Flags, ALUResultM, WriteDataM, writeAddressM, PCSrcM, RegWriteM,
								MemtoRegM, MemWriteM, beM,BranchTakenE,ALUResultE, PCPlus4M, branchLinkM);
	MemDP MemtoWB(clk,reset, PCPlus4M, branchLinkM, PCSrcM, RegWriteM, MemtoRegM, MemWriteM,writeAddressM, beM, WriteDataM, ALUResultM,
			PCSrcW, RegWriteW, MemtoRegW, WA3W, ALUOutW, ReadDataW, PCPlus4W, branchLinkW);
	
	
	WriteDP writeBack(PCPlus4W, branchLinkW, MemtoRegW, ALUOutW, ReadDataW, ResultW);
	mux2 #(4) WA3mux(WA3W, 4'b1110, branchLinkW, WA3 );
	assign Match_12D_E = (RA1D == writeAdressE)|(RA2D==writeAdressE);
	assign PCWrPendingF = PCSrcD|PCSE|PCSrcM;
	
	HazardUnit hazunit(RegWriteM,RegWriteW,RA1E,RA2E, writeAddressM, WA3W, MemtoRegE,Match_12D_E,PCWrPendingF, PCSrcW,BranchTakenE, StallF,StallD,FlushE,FlushD, ForwardAE, ForwardBE);
	
	assign DataAdr=ALUOutW;
	assign MemWrite=MemWriteM;
	assign WriteData=WriteDataM;
	
	
			
							
	
	
endmodule
