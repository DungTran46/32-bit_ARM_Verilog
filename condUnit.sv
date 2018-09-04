module condUnit(input logic [3:0]oldFlags, ALUFlags,  // {Neg, Zero, Carry, Overflow}
				 input logic [3:0]Cond,
				 input logic [1:0]Op, FlagW,
				 input logic [1:0]InstructionOffset, // bit 6 and 5 of the instruction
				 input logic [1:0]ByteAddress,
				 input logic [1:0]Funct20,
				 output logic CondEx,
				 output logic [3:0]outputFlags,
				 output [3:0]be
				 );
	logic [1:0] FlagWrite;			 
	beControl bc(Op, InstructionOffset,ByteAddress, Funct20[0],Funct20[1],be);
	condcheck cc(Cond, oldFlags, CondEx);
	assign FlagWrite= FlagW & {2{CondEx}};
	mux2 #(2) NegZero(oldFlags[3:2], ALUFlags[3:2], FlagWrite[1], outputFlags[3:2]);
	mux2 #(2) CarryOverflow(oldFlags[1:0], ALUFlags[1:0], FlagWrite[0], outputFlags[1:0]);
endmodule


				 