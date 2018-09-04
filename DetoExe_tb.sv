module DetoExt_tb();
	logic clk, reset;
	logic [31:0]Instr,WD3;
	logic WE3;
	logic [3:0] A3;
	logic [31:0]PCPLUS4;
	logic [31:0]PCPLUS8;
	logic [3:0] Flags;
	
	logic [1:0]OpE;
	logic [11:0]InstrOffesetE;// bit 6 and 5 of the instruction
	logic [1:0]FlagWE;
	logic [3:0]condE;
	logic PCSE, RegWE, MemWE, branchE;
	logic MemtoRegE, ALUSrcE;
	logic [3:0] ALUControlE;
	logic [31:0] RD1E, RD2E, ExtimmE;
	logic [3:0] writeAdressE;
	logic [3:0] FlagsE;
	logic [1:0]Funct20E;
	logic IE;
	logic carryOut_ControlE;
	
DetoExeDatapath test(clk, reset, Instr,WD3,WE3,A3,PCPLUS4,PCPLUS8,Flags,
						OpE,InstrOffesetE,FlagWE,condE,PCSE,RegWE,MemWE,branchE,
						MemtoRegE,ALUSrcE,ALUControlE,RD1E,RD2E,ExtimmE, writeAdressE,
						FlagsE,Funct20E,IE,carryOut_ControlE);
						
	initial begin
		clk<=0;
		reset<=1;#10;
		reset<=0;
		clk=1;
		PCPLUS4=4;
		PCPLUS8=8;
		Instr<=32'hE04F000F;#10;
		clk=0;#10;
		clk=1;
		PCPLUS4=4;
		PCPLUS8=8;
		Instr<=32'hE2802005;#10;

		
		
	
	end
endmodule
	