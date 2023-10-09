module UpDownCounterV1(KEY,SW,LEDR);
	input [17:0] SW;
	input [0:0] KEY;
	output [1:0] LEDR;
	
	UpDownCounterV1base UD(.reset(SW[17]), .Enable(SW[1]), .UpDown(SW[0]), .Clk(KEY[0]), .Taken(LEDR[0]), .Strong(LEDR[1])); 
endmodule
	
module UpDownCounterV1base(Clk,Enable, reset,UpDown,Taken,Strong);
	input Clk,reset,UpDown,Enable;
	output Taken, Strong;
	reg[1:0] S;
	
	wire[1:0] w;
	assign w[0] = ~S[1] & ~S[0] & Enable & UpDown | ~S[1] & S[0] & ~Enable | S[1] & ~S[0] & Enable & ~UpDown | S[1] & ~S[0] & Enable & UpDown | S[1] & S[0] & Enable & UpDown | S[1] & S[0] & ~Enable;
	assign w[1] = ~S[1] & S[0] & Enable & UpDown | S[1] & ~S[0] & ~Enable | S[1] & ~S[0] & Enable & UpDown | S[1] & S[0] & Enable & ~UpDown | S[1] & S[0] & Enable & UpDown | S[1] & S[0] & ~ Enable;
	
	
	always@(posedge Clk)
	begin
		if(reset)
			S <= 0;
		else
			S <= w;
		
	end
	
	assign Taken = S[1];
	assign Strong = S[1] ~^ S[0];
	
endmodule
	