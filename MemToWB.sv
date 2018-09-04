module MemToWB (	input logic clk, reset,
			input logic[31:0]PCPlus4M,
			input logic branchLinkM,
			input logic PCSrcM,RegWriteM,MemtoRegM,
			input logic [31:0] ReadDataM, ALUOutM,
			input logic [3:0] WA3M,
			output logic PCSrcW, RegWriteW, MemtoRegW,
			output logic [31:0] ReadDataW, ALUOutW,
			output logic [3:0] WA3W,
			output logic[31:0]PCPlus4W,
			output logic branchLinkW
		);
			
	always_ff @(posedge clk, posedge reset) begin

	if (reset) begin 
		
		PCSrcW <= 0;
		RegWriteW <= 0;
		MemtoRegW <= 0;
		ReadDataW <= 0;
		ALUOutW <= 0;
		WA3W <= 0;
		PCPlus4W<=0;
		branchLinkW<=0;
	end else begin
		
		PCSrcW <= PCSrcM;
		RegWriteW <= RegWriteM;
		MemtoRegW <= MemtoRegM;
		ReadDataW <= ReadDataM;
		ALUOutW <= ALUOutM;
		WA3W <= WA3M;
		PCPlus4W<=PCPlus4M;
		branchLinkW<=branchLinkM;
	
	end
	
	
	end
	
endmodule
