module alu(
	input logic 	CarryIn,
    input logic [31:0] SrcA, SrcB,
    input logic [3:0] ALUControl,
    output logic [31:0] ALUResult,
    output logic [3:0] ALUFlags   // {Neg, Zero, Carry, Overflow}
    );

    always_comb 
    begin
        // Default values to be overwritten.
        // To prevent the accidental creation of latches when the values are not assigned
        ALUFlags[0] = 1'b0;
        ALUFlags[1] = 1'b0;
		ALUFlags[2] = 1'b0;
		ALUFlags[3] = 1'b0;
        ALUResult = 32'd0;
// For ALUControl[1:0],
    // Add 00
    // Sub 01
    // AND 10
    // OR  11
        case(ALUControl)
            4'b0000 :   // AND
            begin
                ALUResult = SrcA & SrcB;
                ALUFlags[1] = 1'b0;
                ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]= ~|ALUResult;
			end
			
			4'b0001:	//EOR exclusive or
			begin
				ALUResult = SrcA ^ SrcB;
                ALUFlags[1] = 1'b0;
                ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]= ~|ALUResult;
			end
				
			4'b0010 :   // SUB
			begin
                {ALUFlags[1],ALUResult} = SrcA - SrcB;
                if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else if (~SrcA[31] & SrcB[31] & ALUResult[31])
                    ALUFlags[0] = 1'b1;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]= ~|ALUResult;
            end
			
			4'b0011 :   // Reverse SUB
			begin
                {ALUFlags[1],ALUResult} = SrcB - SrcA;
                if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else if (~SrcA[31] & SrcB[31] & ALUResult[31])
                    ALUFlags[0] = 1'b1;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]= ~|ALUResult;

            end
            4'b0100 :   // Add
            begin
                {ALUFlags[1],ALUResult} = SrcA + SrcB;
                if (SrcA[31] & SrcB[31] & ~ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else if (~SrcA[31] & ~SrcB[31] & ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else
					ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]=~|ALUResult;
            end
			
            4'b0101 :   // Add with carry 
            begin
                {ALUFlags[1],ALUResult} = SrcA + SrcB + CarryIn;
                if (SrcA[31] & SrcB[31] & ~ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else if (~SrcA[31] & ~SrcB[31] & ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else
					ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]=~|ALUResult;
            end     
			
			4'b0110:	// Subtract with carry
			begin
                {ALUFlags[1],ALUResult} = SrcA - SrcB - ~CarryIn;
                if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else if (~SrcA[31] & SrcB[31] & ALUResult[31])
                    ALUFlags[0] = 1'b1;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]= ~|ALUResult;
            end	
			
			4'b0111:	// Reverse Subtract with carry
			begin
                {ALUFlags[1],ALUResult} = SrcB - SrcA - ~CarryIn;
                if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else if (~SrcA[31] & SrcB[31] & ALUResult[31])
                    ALUFlags[0] = 1'b1;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]= ~|ALUResult;
            end		
			4'b1000:	//Test
			begin
                ALUResult = SrcA & SrcB;
                ALUFlags[1] = 1'b0;
                ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]= ~|ALUResult;
			end
			
			4'b1001:	//Test Equivalence
			begin
				ALUResult = SrcA ^ SrcB;
                ALUFlags[1] = 1'b0;
                ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]= ~|ALUResult;
			end
			
			4'b1010:	//Compare
			begin
                {ALUFlags[1],ALUResult} = SrcA - SrcB;
                if (SrcA[31] & ~SrcB[31] & ~ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else if (~SrcA[31] & SrcB[31] & ALUResult[31])
                    ALUFlags[0] = 1'b1;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]= ~|ALUResult;
            end
			
			4'b1011:	//Compare negative
			begin
                {ALUFlags[1],ALUResult} = SrcA + SrcB;
                if (SrcA[31] & SrcB[31] & ~ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else if (~SrcA[31] & ~SrcB[31] & ALUResult[31])
                    ALUFlags[0] = 1'b1;
                else
					ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]=~|ALUResult;
            end
			
            4'b1100 :   // OR
            begin
                ALUResult = SrcA | SrcB;
                ALUFlags[1] = 1'b0;
                ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]=~|ALUResult;
            end
			4'b1101:	//MOV;
			begin
				ALUResult = SrcB;
				ALUFlags[1] = 1'b0;
                ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]=~|ALUResult;
			end
			4'b1110:	// BIC  bitwise clear
			begin
				ALUResult = SrcA & ~SrcB;
				ALUFlags[1] = 1'b0;
                ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]=~|ALUResult;
			end
			
			4'b1111:	//MVN
			begin
				ALUResult = ~SrcB;
				ALUFlags[1] = 1'b0;
                ALUFlags[0] = 1'b0;
				ALUFlags[3]=ALUResult[31];
				ALUFlags[2]=~|ALUResult;
			end			
			
            default :
            begin
                ALUResult 	= 32'd0;
                ALUFlags[1] = 1'b0;
                ALUFlags[0] = 1'b0;
				ALUFlags[2]	=1'b1;
				ALUFlags[3]	=1'b0;
            end
        endcase
    end

endmodule