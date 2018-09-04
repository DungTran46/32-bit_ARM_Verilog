module dmem (
            input  logic        clk,
            input  logic        we,
			input  logic [3:0]  be,  //be[3] => byte enable on/off, be[2] => signed/unsigned, be[1:0] => address
            input  logic [31:0] a,
            input  logic [31:0] wd,
            output logic [31:0] rd
            );
            
  logic [7:0] RAM1[511:0];
  logic [7:0] RAM2[511:0];
  logic [7:0] RAM3[511:0];
  logic [7:0] RAM4[511:0];
  
  
 
 always_comb
		begin
		
		// Load operations occur when write enable = 0
		case(be)
			//LDR, read all bytes
			4'b0000: rd = {{RAM4[a[10:2]]}, {RAM3[a[10:2]]}, {RAM2[a[10:2]]}, {RAM1[a[10:2]]}};
				
			//LDRB
		
			4'b1000: rd = {24'b0, RAM1[a[10:2]]};
			4'b1001: rd = {24'b0, RAM2[a[10:2]]};
			4'b1010: rd = {24'b0, RAM3[a[10:2]]};
			4'b1011: rd = {24'b0, RAM4[a[10:2]]};
			
			//LDRH, lower-half
			4'b0011: rd = {16'b0, {RAM2[a[10:2]]},{RAM1[a[10:2]]}};
			
			// LDRSB
			4'b1100: rd = {{24{RAM1[a[10:2]][7]}}, {RAM1[a[10:2]]}};
			4'b1101: rd = {{24{RAM2[a[10:2]][7]}}, {RAM2[a[10:2]]}};
			4'b1110: rd = {{24{RAM3[a[10:2]][7]}}, {RAM3[a[10:2]]}};
			4'b1111: rd = {{24{RAM4[a[10:2]][7]}}, {RAM4[a[10:2]]}};
			
			//only difference between LDRSB AND LDRSH is op2 (bits 6:5)
			//maybe make byte enable = 0 
			//LDRSH
			4'b0100: rd = {{16{RAM2[a[10:2]][7]}},RAM2[a[10:2]],RAM1[a[10:2]]};
			
		endcase
	end
	
  always @(posedge clk)
		begin
	

		 //These will be when write enable = 1 for Store operations
		if(we) begin
			case(be)
			
			//STR, store all bytes
			4'b0000: begin	 
					 RAM1[a[10:2]] <= wd[7:0];
					 RAM2[a[10:2]] <= wd[15:8];
					 RAM3[a[10:2]] <= wd[23:16];
					 RAM4[a[10:2]] <= wd[31:24];
					end
			//STRB
			4'b1000: RAM1[a[10:2]] <= wd[7:0];
			4'b1001: RAM2[a[10:2]] <= wd[7:0];
			4'b1010: RAM3[a[10:2]] <= wd[7:0];
			4'b1011: RAM4[a[10:2]] <= wd[7:0];
			
			//STRH
			4'b0011: begin
					 RAM1[a[10:2]] <= wd[7:0];
					 RAM2[a[10:2]] <= wd[15:8];
					 end
			
			endcase
		end
	end
/*      
    
  initial
    begin
      // will read the memfile.data from sim directory and preloads the RAM array.
      $readmemh("memfile.dat", RAM1); // initialize memory
	  $readmemh("memfile.dat", RAM2);
	  $readmemh("memfile.dat", RAM3);
	  $readmemh("memfile.dat", RAM4);
	  
	   
    end      
      
*/
	
/*
	//this is for STR instructions
	logic we1 = we & (~be[0] & ~be[1]);    //be[1:0] = 00
	logic we2 = we & (be[0] & ~be[1]);		//be[1:0] = 01
	logic we3 = we & (~be[0] & be[1]);		//be[1:0] = 10
	logic we4 = we & (be[0] & be[1]);		//be[1:0] = 11
	
	
	
   SRAM1RW512x8 RAM1 (
			.A       ( a[10:2] ),   
			.CE      ( 1'b1   ),   
			.WEB     ( ~we1), //active high
			.OEB     ( we1),      //active low
			.CSB     ( 1'b0   ),
			.I       ( wd[7:0]     ),  //wd[7:0]
			.O       ( rd[7:0]     )		//rd[7:0]
			);
	SRAM1RW512x8 RAM2 (
			.A       ( a[10:2] ),   
			.CE      ( 1'b1   ),   
			.WEB     ( ~we2    ),
			.OEB     ( we2     ),
			.CSB     ( 1'b0   ),
			.I       ( wd[15:8]     ), //wd[15:8]
			.O       ( rd[15:8]     )		//rd[15:8]
			);
	SRAM1RW512x8 RAM3 (
			.A       ( a[10:2] ),   
			.CE      ( 1'b1   ),   
			.WEB     ( ~we3    ),
			.OEB     ( we3     ),
			.CSB     ( 1'b0   ),
			.I       ( wd[23:16]     ),  //wd[23:16]
			.O       ( rd[23:16]     )		//rd[23:16]
			);
	SRAM1RW512x8 RAM4 (
			.A       ( a[10:2] ),   
			.CE      ( 1'b1   ),   
			.WEB     ( ~we4    ),
			.OEB     ( we4     ),
			.CSB     ( 1'b0   ),
			.I       ( wd[31:24]     ), //wd[31:24]
			.O       ( rd[31:24]     )  //rd[31:24]
			);
*/


endmodule
