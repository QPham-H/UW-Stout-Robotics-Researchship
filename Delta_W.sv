module Delta_W (input 			   in,
					 input 				label, Hw, Clk, Record_X, RST, Up_W, Get,
					 output 		[7:0] delta_w);
 
byte error, delw_int;
logic Xs_out;
logic [8000:0] Xout;
//logic [7:0] Xs, error;

assign error = label - Hw;
assign delta_w = delw_int;
// Combinational implementation: assign Xs = {8{Xout[0]}}; 
				// Since we're bit-wise ANDing to simulate multiplying by 0 or 1
// Combinational implementation: assign error = {8{Hw}} + {7'b0,label}; 

	always_ff @ (posedge Clk)
    begin
	 	 if (RST) //notice, this is a sychronous reset, which is recommended on the FPGA
				Xout <= 8001'd0;
		 else if (Record_X && Get)  // This is a shift right register
				Xout <= { in, Xout[8000:1] }; 
		 else if (Up_W)
				Xout <= {1'b0, Xout[8000:1]};
    end
	 
assign Xs_out = Xout[0];
assign delw_int = error * Xs_out; 
// Combinational implementation: delta_w = error & Xs;

endmodule
