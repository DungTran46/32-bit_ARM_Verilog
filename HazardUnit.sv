module HazardUnit(
		input logic regWriteM, regWriteW, 
		input logic [3:0] RA1E,RA2E,writeAddressM, WA3W,
		input logic MemtoRegE, Match_12D_E,PCWrPendingF, PCSrcW,BranchTakenE,		
		output logic StallF, StallD, FlushE,FlushD,
		output logic [1:0] forwardAE, forwardBE 
		);
	//receives Match signals from datapath
	//NEED TO DIFFERENTIATE CONDITIONS FOR DIFFERENT INSTRUCTIONS
	
	logic LDRstall;	


	//LDR
	assign LDRstall = (Match_12D_E & MemtoRegE);
	assign StallF = LDRstall;
	assign StallD = LDRstall|PCWrPendingF;
	assign FlushE = LDRstall|BranchTakenE;
	assign FlushD = PCWrPendingF|PCSrcW|BranchTakenE;
/*
	//Branch
	StallD = LDRstall;
	StallF = (LDRstall|PCWrPendingF);
	FlushE = LDRstall|BranchTakenE;
	FlushD = PCWrPendingF|PCSrcW|BranchTakenE;
	*/
forwarding fw(regWriteM,regWriteW,RA1E,RA2E,writeAddressM,WA3W,forwardAE,forwardBE);
endmodule

