module controlUnit(input logic clk, reset,
						input logic [1:0] Op,
						input logic [5:0] Funct,
						input logic [3:0] Rd,
						input logic Instr_7,
						input logic Instr_4,
						output logic [1:0] FlagW,
						output logic PCS, RegW, MemW,
						output logic MemtoReg, ALUSrc, Branch,
						output logic [1:0] ImmSrc, 
						output logic [2:0]RegSrc, 
						output logic [3:0] ALUControl,
						output logic shRA1Control,
						output logic carryOut_Control 
					);
	logic [10:0] controls;
	logic ALUop;

	always_comb
		casex(Op)
		// Data-processing immediate
		2'b00: 
		begin
			//immediate data_processing
			if (Funct[5])
				case(Funct[4:1])
					//make sure TST TEQ CMN CMP CMN do not write to register(regW=0)
					4'b1000:	controls=11'b00000100001;//TST
					4'b1001:	controls=11'b00000100001;//TEQ
					4'b1010:	controls=11'b00000100001;//CMP
					4'b1011:	controls=11'b00000100001;//CMN
					default: 	controls=11'b00000101001;
				endcase
			// Extra memory operation or data_processing register
			else begin
				//if InstrOffset[7] & InstrOffset[4] == 1, implies extra memory
				if(Instr_7 & Instr_4) begin
					//if Funct[0]== 1, LDRH, LDRSB, LDRSH
					if(Funct[0]) begin
						//Immediate, doesn't matter what MemtoReg is when RegW = 0
						if (Funct[2]) controls = 11'b00011111000;
						
						//Register-shifted, RegSrc == 00 to pass in Rm through ALU
						else controls = 11'b00011011000;
						
					//if Funct[0]== 0, STRH
					end else begin
						//Immediate, doesn't matter what MemtoReg is when RegW = 0
						if (Funct[2]) controls = 11'b01011110100;
						
						//Register-shifted, RegSrc == 00 to pass in Rm through ALU
						else controls = 11'b00011000100;
					end
				end
				
				//if InstrOffset[7] & InstrOffset[4]==  0, implies Data-processing immediate
				else begin
					case(Funct[4:1])
					//make sure TST TEQ CMN CMP CMN do not write to register(regW=0)
					4'b1000:	controls=11'b00000000001;//TST
					4'b1001:	controls=11'b00000000001;//TEQ
					4'b1010:	controls=11'b00000000001;//CMP
					4'b1011:	controls=11'b00000000001;//CMN
					default: 	controls=11'b00000001001;
					endcase
				end				
			end
		end
		
		
		2'b01: 
		// LDR or LDRB
		if (Funct[0]) begin
				//Immediate
				if(~Funct[5]) controls = 11'b00001111000;
					//For register RegSrc[1:0] = 2'b00 and ALUSrc = 0, ImmSrc won't matter when ALUSrc = 0
					
				//Register-shifted
				else controls = 11'b00001011000;
			end
		
        // STR or STRB
        else begin
			//Immediate, doesn't matter what MemtoReg is when RegW = 0
			if (~Funct[5]) controls = 11'b01001110100;
		
			//Register-shifted, RegSrc == 00 to pass in Rm through ALU
			else controls = 11'b00001000100;
			
		end
		// B
		2'b10: 
			//BL
			if(Funct[4]) controls = 11'b10110101010;
			//B
			else controls=11'b00110100010;
		
		// Unimplemented
		default: controls = 11'bx;
	endcase
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg,
		RegW, MemW, Branch, ALUOp} = controls;	
	// ALU Decoder and shifter
	always_comb
	if (ALUOp) begin // which DP Instr?
		case(Funct[4:1])
			4'b0000:	// AND
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b0;
			end
			4'b0001:	//XOR
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b0;
			end
			4'b0010:	//SUB
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b1;
			end
			4'b0011:	//RSB
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b1;
			end
			4'b0100:	//ADD
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b1;
			end
			4'b0101: //ADC
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b1;
			end
			4'b0110: 	//SBC
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b1;
			end
			4'b0111:	//RSC
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b1;
			end
			4'b1000:	//TST
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b0;
			end
			4'b1001:	//TEQ
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b0;
			end
			4'b1010:	//CMP
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b1;
			end
			4'b1011:	//CMN
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b1;
			end
			4'b1100:	//OR
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b0;
			end
			4'b1101:	//MOV
			begin
				shRA1Control=1'b1;	
				carryOut_Control=1'b0;
			end
			4'b1110:	//BIC
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b0;
			end
			4'b1111:	//MVN
			begin
				shRA1Control=1'b0;
				carryOut_Control=1'b0;
			end
		endcase
		ALUControl=Funct[4:1];
		// update flags if S bit is 	set (C & V only for arith)
		FlagW[1] = Funct[0];
		FlagW[0] = Funct[0] &
		(ALUControl == 4'b0100 | ALUControl == 4'b0010);
	end else begin
		ALUControl = 4'b0100; // add for non-DP instructions
		shRA1Control=1'b0;
		FlagW = 2'b00; // don't update Flags
		carryOut_Control=1'b1;
	end
	// PC Logic
	assign PCS = (Rd == 4'b1111) & RegW;
endmodule			
	
		