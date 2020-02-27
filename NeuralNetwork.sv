module NeuralNetwork( input Clk,
							 input RST, 				// For Reseting, from KEYS
							 input Train,				// for training, from KEYS
							 input New_frame,
							 input XFull,				// Indicates we have all inputs
							 output ComputeH,			// Signal to compute SUM wi*xi
							 output upRule,				// signal for wi <- wi + dw
							 output classify
							 );			

enum logic [2:0] {Reset, CalcHw, UpdateRule, Classify, Wait} curr_state, next_state;
int Counter_DW;		// counter for wi <- wi + dw
int Counter_DW_in;
logic ComputeH_in, StoreX_in, upRule_in, classify_in;

assign ComputeH = ComputeH_in;
assign upRule = upRule_in;

	always_ff @(posedge Clk)
	begin
		if(RST)
			begin
				curr_state <= Reset;
				Counter_DW <= 8000;
			end
		else
			begin
				curr_state <= next_state;
				Counter_DW <= Counter_DW_in;
			end
	end
	
//////////// STATE LOGIC ////////////////	
	always_comb
	begin
		next_state = curr_state;
		unique case (curr_state)
			Reset:	if(Train)
							next_state = Wait;
			Wait:		if(New_frame)
								next_state = CalcHw;
			CalcHw: 		if(XFull)
								next_state = Classify;
			Classify:	begin
								if(Train)
									next_state = UpdateRule;
								else
									next_state = Wait;
							end
			UpdateRule:	if(Counter_DW == 0)
								next_state = Wait;
		endcase
	end
	
/////////////// STATES ////////////////
	always_comb // @ (Train, XFull, curr_state)
	begin
	classify_in = 1'b0;
	upRule_in = 1'b0;
	ComputeH_in = 1'b0;
	Counter_DW_in = 32'd8000;
		case(curr_state)
			Reset:
							begin
							end
			Wait:			begin
							end
			CalcHw:		begin
							ComputeH_in = 1'b1;
							end
			Classify:	begin 
							classify_in = 1'b1;
							end
			UpdateRule:	begin
								Counter_DW_in = Counter_DW - 32'd1;
								upRule_in = 1'b1;
							end
		endcase
	end		

assign classify = classify_in;	
							
endmodule 	