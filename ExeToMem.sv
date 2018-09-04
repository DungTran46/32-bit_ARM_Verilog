module ExeToMem(input logic clk, reset,
				input logic [31:0] PCPlus4E,
				input logic branchLink,
				input logic [31:0]ALUResultE, WriteDataE, 
				input logic [3:0]WA3E,
				input logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE,
				input logic [3:0]beE,
				output logic [31:0]ALUResultM, WriteDataM, 
				output logic [3:0]WA3M,
				output logic PCSrcM, RegWriteM, MemtoRegM, MemWriteM,
				output logic [3:0]beM,
				output logic [31:0] PCPlus4M,
				output logic branchLinkM
				);
	always_ff @(posedge clk, posedge reset)
	begin
		if (reset) begin
			ALUResultM<=32'b0;
			WriteDataM<=32'b0;
			WA3M<=4'b0;
			PCSrcM<=1'b0;
			RegWriteM<=1'b0;
			MemtoRegM<=1'b0;
			MemWriteM<=1'b0;
			beM<=4'b0;
			PCPlus4M<=0;
			branchLinkM<=0;
		end else begin
			ALUResultM<=ALUResultE;
			WriteDataM<=WriteDataE;
			WA3M<=WA3E;
			PCSrcM<=PCSrcE;
			RegWriteM<=RegWriteE;
			MemtoRegM<=MemtoRegE;
			MemWriteM<=MemWriteE;
			beM<=beE;
			PCPlus4M<=PCPlus4E;
			branchLinkM<=branchLink;
		end
	end
endmodule