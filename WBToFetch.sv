module WBToFetch(input logic clk, reset,StallD,
				input logic [31:0] InstrF,PCPlus4F,
				input logic FlushD,
				output logic [31:0] InstrD,PCPlus4D
				);


		
	always_ff @(posedge clk, posedge reset) begin
	if (reset|FlushD) begin
	InstrD <= 0;
	PCPlus4D<=0;
	end else if(StallD) begin 
	InstrD <= InstrF;
    PCPlus4D<=PCPlus4F;
	end

	end

endmodule
