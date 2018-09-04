module WriteDP (input logic[31:0] PCPlus4W,
				input logic branchLinkW,
				input logic MemtoRegW,
				input logic [31:0] ALUOutW, ReadDataW,
				output [31:0] ResultW
				);

	logic [31:0] result;
	
	mux2 #(32) wbmux(ALUOutW,ReadDataW,MemtoRegW, result);
	mux2 #(32) wb2mux(result,PCPlus4W, branchLinkW, ResultW);
	
endmodule
