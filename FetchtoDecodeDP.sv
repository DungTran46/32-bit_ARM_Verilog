module FetchtoDecodeDP( input logic clk, reset,
							input logic [31:0] ResultW, 
							input logic PCSrcW,
							input logic StallF,StallD,FlushD,
							input logic [31:0] ALUResultE,
							input logic BranchTakenE,
							output logic [31:0] PCPlus8D, InstrF, PCPlus4F
							);

	logic [31:0] PCNext,PCNext2,PCF,Instr;
	mux2 #(32) pcmux(PCPlus8D, ResultW, PCSrcW, PCNext);
	mux2 #(32) pc2mux(PCNext,ALUResultE,BranchTakenE,PCNext2);
	flopenr #(32) pcreg(clk, reset,~StallF, PCNext2, PCF);

	imem imem(PCF,Instr);
	adder #(32) pcadd1(PCF, 32'b100, PCPlus8D);
	WBToFetch WBToFetchReg(clk, reset, ~StallD, Instr, PCPlus8D, FlushD,InstrF, PCPlus4F);
	
endmodule