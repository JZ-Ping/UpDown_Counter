module UpDownCounterV2(KEY,SW,LEDR);
	input [17:0] SW;
	input [0:0] KEY;
	output [1:0] LEDR;
	
	UpDownCounterV2base UD(.reset(SW[17]), .Enable(SW[1]), .UpDown(SW[0]), .Clk(KEY[0]), .Taken(LEDR[0]), .Strong(LEDR[1])); 
endmodule
	





module UpDownCounterV2base(reset, Enable,UpDown,Clk,Taken,Strong);
	input reset,Enable,UpDown,Clk;
	output Taken,Strong;
	
	reg[1:0] state;
	reg[1:0] count;
	reg Taken, Strong;
	
	parameter State0 = 2'b00;
	parameter State1 = 2'b01;
	parameter State2 = 2'b10;
	parameter State3 = 2'b11;
	
	always @*
	begin
		case(state)
				State0: if(Enable & UpDown)
								count <= State1;
						  else
								count <= State0;
				State1: if(Enable & ~UpDown)
								count <= State0;
						  else if(Enable & UpDown)
								count <= State2;
						  else
								count <= State1;
				State2: if(Enable & ~UpDown)
								count <= State1;
						  else if(Enable & UpDown)
								count <= State3;
						  else
								count <= State2;
				State3: if(Enable & ~UpDown)
								count <= State2;
						  else
								count <= State3;
	   endcase
		end
		
		
		
	always@(posedge Clk)
	begin
		if(reset)
			state <= 0;
		else
			state <= count;
	end
	
	
	always @*
	begin
		case(state)
			State0:begin
							Taken = 1'b0;
							Strong = 1'b1;
					 end
			State1:begin
							Taken = 1'b0;
							Strong = 1'b0;
					 end
			State2:begin
							Taken = 1'b1;
							Strong = 1'b0;
					 end
			State3:begin
							Taken = 1'b1;
							Strong = 1'b1;
					 end
	endcase
   end
	endmodule
	
					 