module shifter(input logic [11:0] src2, 
				input logic [1:0]op,
				input logic [31:0] RD1, //Rs	
				input logic [31:0] RD2,	//RD2
				input logic I,
				input logic carryIn,
				output logic [31:0] shift_operand,
				output logic carryOut);
				
	logic imm_isZero;
	logic [63:0] t;
	logic [30:0] ror;
	logic [63:0] t1;			
	logic [1:0]rs1;
	logic rs2;
	logic [4:0]rs3;
	logic rs_isZero, rs_isEQ32, rs_isLT32;
	logic [7:0]rs;
	logic [31:0]extend;
	logic [63:0] rotExtend;
	logic [3:0]rot;
	
	//use for immediate operation
	assign rs=RD1[7:0];
	assign rs1= rs[7:6];
	assign rs2= rs[5];
	assign rs3= rs[4:0];
	assign t1 = {RD2,RD2}>>rs3;
	
	//use for register operation
	assign rs_isZero= ~|rs;						//check if rs is zero
	assign rs_isEQ32= (~|rs1)&(rs2)&(~|rs3); 	//check if rs is equal to 32
	assign rs_isLT32= (~|rs1)&(~rs2)&(|rs3);	//checl if rs is less than 32
	assign ror=RD2>>1'b1;
	assign t={RD2,RD2}>>src2[11:7];
	assign imm_isZero=~|src2[11:7];
	
	//use for I =1 extend
	assign rot=src2[11:8]<<1'b1;
	assign rotExtend={RD2,RD2}>>rot;
	
	always_comb
	case(I)
		1'b0: 
		begin
			if(~src2[4]) begin 			//immediate operation
				case(src2[6:5])
					2'b00:	//LSL immediate
					begin
						if (imm_isZero) begin
							shift_operand=RD2;
							carryOut=carryIn;
						end else begin
							shift_operand= RD2 << src2[11:7];
							carryOut=RD2[32 - src2[11:7]];
						end
					end
					2'b01: //LSR immediate
					begin
						if (imm_isZero) begin
							shift_operand=32'b0;
							carryOut=RD2[31];
						end else begin
							shift_operand= RD2 >> src2[11:7];
							carryOut=RD2[src2[11:7] - 1];
						end
					end
					2'b10:	//ASR immediate
					begin
						if(imm_isZero) begin
							if (~RD2[31])begin
								shift_operand=32'b0;
								carryOut=RD2[31];
							end else begin
								shift_operand=32'hFFFFFFFF;
								carryOut=RD2[31];
							end
						end else begin
						shift_operand= RD2 >>>src2[11:7];
						carryOut=RD2[src2[11:7] - 1];
						end
					end
					2'b11:		//ROR,RRX immediate
					begin
						if (imm_isZero) begin 	//RRX
							shift_operand={carryIn,ror};
							carryOut=RD2[0];
						end else begin			//ROR
							shift_operand=t[31:0];
							carryOut=RD2[src2[11:7] - 1];
						end
					end
				endcase
			end else begin			//register operation
				case(src2[6:5])
					2'b00:		//LSL register
					begin
						if(rs_isZero) begin
							shift_operand=RD2;
							carryOut=carryIn;
						end else if(rs_isLT32) begin
							shift_operand=RD2 << rs;
							carryOut=RD2[32 - rs];
						end else if (rs_isEQ32) begin
							shift_operand=32'b0;
							carryOut=RD2[0];
						end else begin
							shift_operand=32'b0;
							carryOut=1'b0;
						end
					end
					2'b01: 		//LSR register
					begin
						if(rs_isZero) begin
							shift_operand=RD2;
							carryOut=carryIn;
						end else if(rs_isLT32) begin
							shift_operand=RD2 >> rs;
							carryOut=RD2[rs - 1];
						end else if (rs_isEQ32) begin
							shift_operand=32'b0;
							carryOut=RD2[31];
						end else begin
							shift_operand=32'b0;
							carryOut=1'b0;
						end
					end
					2'b10: 		//ASR register
					begin
						if(rs_isZero) begin
							shift_operand=RD2;
							carryOut=carryIn;
						end else if(rs_isLT32) begin
							shift_operand=RD2 >>> rs;
							carryOut=RD2[rs - 1];
						end else begin
							if (~RD2[31]) begin
								shift_operand=32'b0;
								carryOut=RD2[31];
							end else begin
								shift_operand=32'hFFFFFFFF;
								carryOut=RD2[31];
							end
						end
					end
					2'b11:		//ROR register
					begin
						if(rs_isZero) begin
							shift_operand=RD2;
							carryOut=carryIn;
						end else if (~|rs3) begin
							shift_operand=RD2;
							carryOut=RD2[31];
						end else begin
							shift_operand=t1[31:0];
							carryOut=RD2[rs3 -1];
						end
					end
				endcase
			end
		end
		1'b1:
		begin
			if(~|op)begin
				shift_operand=rotExtend[31:0];
				if (~|src2[7:0])	//immed_8 =0
					carryOut=carryIn;
				else
					carryOut=shift_operand[31];
				end else begin
					shift_operand=RD2;
					carryOut=carryIn;
			end
		end
	endcase
endmodule