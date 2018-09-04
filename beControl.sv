module beControl(input logic [1:0] Op, InstructionOffset,
				 input logic [1:0]ByteAddress,
				 input logic Funct_0,
				 input logic Funct_2,
				 output logic [3:0]be
				);


	always_comb
	casex(Op)
	2'b00:
		if(Funct_0) //if 1, load
			casex(InstructionOffset)
			//LDRH
			2'b01: begin
				be[3] = 1'b0; 
				be[2] = 1'b0;
				be[1] = 1'b1;
				be[0] = 1'b1;
			end
			//LDRSB
			2'b01: begin
				be[3] = 1'b1; 
				be[2] = 1'b1; //signed
				be[1] = ByteAddress[1];
				be[0] = ByteAddress[0];
			end
			2'b11: begin
				be[3] = 1'b0;
				be[2] = 1'b1;
				be[1] = 1'b0;
				be[0] = 1'b0;		
			end
			default: be = 4'bx;
			endcase
		else begin//STRH 
			be[3] = 1'b0; 
			be[2] = 1'b0;
			be[1] = 1'b1;
			be[0] = 1'b1;
		end
	2'b01:
		//LDRB
		if(Funct_0) begin
			be[3] = Funct_2;  
			be[2] = 1'b0; 
			if (~be[3]) begin
				be[1] = 1'b0;
				be[0] = 1'b0;
			end else begin
				be[1] = ByteAddress[1];
				be[0] = ByteAddress[0];
			end
		//STRB
		end else begin
			be[3] = Funct_2;
			be[2] = 1'b0;
			if (~be[3]) begin
				be[1] = 1'b0;
				be[0] = 1'b0;
			end else begin
				be[1] = ByteAddress[1];
				be[0] = ByteAddress[0];
			end		
		end
	default: be=4'bx;
	endcase
endmodule