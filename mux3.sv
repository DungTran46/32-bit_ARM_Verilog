module mux3#(parameter WIDTH=8)
			(input logic [WIDTH-1:0] in0,in1,in2,
			input logic [1:0]control,
			output logic[WIDTH-1:0] out);
		
		always_comb
			case(control)
				2'b00: out=in0;
				2'b01: out=in1;
				2'b10: out=in2;
			endcase
endmodule
		
