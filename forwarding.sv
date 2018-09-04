module forwarding(input logic regWriteM,
				input logic regWriteW,
				input logic [3:0]RA1E,RA2E,WA3M,WA3W,
				output logic[1:0] forwardAE, forwardBE);
	logic Match_1E_M,Match_1E_W, Match_2E_M, Match_2E_W;	
	assign Match_1E_M=(RA1E==WA3M);
	assign Match_1E_W=(RA1E==WA3W);
	assign Match_2E_M=(RA2E==WA3M);
	assign Match_2E_W=(RA2E==WA3W);
	always_comb
		if (Match_1E_M&regWriteM) 		forwardAE=2'b10;
		else if (Match_1E_W&regWriteW) 	forwardAE=2'b01;
		else 							forwardAE=2'b00;
	always_comb
		if (Match_2E_M&regWriteM)		forwardBE=2'b10;
		else if(Match_2E_W&regWriteW)	forwardBE=2'b01;
		else							forwardBE=2'b00;
endmodule