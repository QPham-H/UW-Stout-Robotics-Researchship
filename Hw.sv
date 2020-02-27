module Hw(	input [7:0] w,
				input 		x,
				input 		Clk, RST,
				input 		ComputeH, Get, 
				input 		RstSum,
				output [31:0] Z
				);

int runningSum, current;
byte product, w_int;

assign product = x * w_int; 
// Combinational implementation: product = w_int & {8{x}};
assign w_int = w;

	 always_ff @ (posedge Clk)
    begin
		if(ComputeH && Get)
			runningSum <= current;
		else if(RstSum || RST)
			runningSum <= 32'd0;
    end
	
	always_comb
	begin
		current = runningSum+product;
	end
	
assign Z = runningSum;

endmodule 