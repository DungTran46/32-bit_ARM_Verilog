module MemDP (input logic clk, reset,
			input logic [31:0]PCPlus4M,
			  input logic branchLinkM, PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
			  input logic [3:0] WA3M, beM,
			  input logic [31:0] WriteDataM, ALUresultE,
			  
			  //send MemWriteM to dmem
			  output logic PCSrcW, RegWriteW, MemtoRegW,
				//output sent to dmem
			  output logic [3:0] WA3W,
			  output logic [31:0] ALUOutM,
			  output logic [31:0] ReadDataM,
			  output logic [31:0]PCPlus4W,
			  output logic branchLinkW
			  );
	
	logic [31:0] ReadData;
	dmem dmem(clk, MemWriteM,beM, ALUresultE, WriteDataM,ReadData);
	
	MemToWB MemToWBReg(clk, reset, PCPlus4M, branchLinkM, PCSrcM, RegWriteM, MemtoRegM, ReadData,
					ALUresultE, WA3M,PCSrcW,RegWriteW,MemtoRegW, 
					ReadDataM, ALUOutM, WA3W, PCPlus4W, branchLinkW);


endmodule
