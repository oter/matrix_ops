module matrix_mult_matrix (clk, i_calc, i_rst_n, i_matrix_1, i_matrix_2, o_result, o_ready);

	parameter FIRST_MATRIX_HEIGHT = 5;
	parameter BOTH_MATRIX_W_H = 5;
	parameter SECOND_MATRIX_WIDTH = 5;

	parameter DATA_WIDTH = 8;

	parameter FIRST_MATRIX_WEIGHT = FIRST_MATRIX_HEIGHT * BOTH_MATRIX_W_H;
	parameter SECOND_MATRIX_WEIGHT = SECOND_MATRIX_WIDTH * BOTH_MATRIX_W_H;
	parameter BUFFER_MATRIX_WEIGHT = FIRST_MATRIX_HEIGHT * SECOND_MATRIX_WIDTH * BOTH_MATRIX_W_H;
	
	parameter FIRST_MATRIX_SIZE = FIRST_MATRIX_WEIGHT * DATA_WIDTH;
	parameter SECOND_MATRIX_SIZE = SECOND_MATRIX_WEIGHT * DATA_WIDTH;
	parameter BUFFER_MATRIX_SIZE = BUFFER_MATRIX_WEIGHT * DATA_WIDTH;

	parameter RESULT_MATRIX_SIZE = FIRST_MATRIX_HEIGHT * SECOND_MATRIX_WIDTH * DATA_WIDTH;
	
	input clk;
	input i_rst_n;
	input i_calc;
	input [FIRST_MATRIX_SIZE-1:0] i_matrix_1;
	input [SECOND_MATRIX_SIZE-1:0] i_matrix_2;
	output o_ready;
	output [RESULT_MATRIX_SIZE-1:0] o_result;
	
	reg ready;
	reg [RESULT_MATRIX_SIZE-1:0] result;
	reg [DATA_WIDTH-1:0] buffer [0:FIRST_MATRIX_HEIGHT-1][0:SECOND_MATRIX_WIDTH-1][0:BOTH_MATRIX_W_H-1];
	reg [2:0] state;

	assign o_ready = ready;
	assign o_result = result;





	wire [DATA_WIDTH-1:0] sum_provider [0:FIRST_MATRIX_HEIGHT-1][0:SECOND_MATRIX_WIDTH-1][0:BOTH_MATRIX_W_H];
	
	initial begin
		buffer =	{
						{
							{
								
							}
						}
					}
	end

	
	generate
		genvar l,m,n;
		for(m = 0; m < SECOND_MATRIX_WIDTH; m = m + 1) begin
			for(n = 0; n < FIRST_MATRIX_HEIGHT; n = n + 1) begin
				assign sum_provider[m][n][0] = 0;
				for (l = 0; l < BOTH_MATRIX_W_H; l = l + 1) begin:SUM
					assign sum_provider[l+1] = sum_provider[l]+buffer[m][n][l];
				end
			end
		end
	endgenerate



	// integer i;
	// integer j;
	// integer k;


	// parameter IDLE = 0;
	// parameter CALC = 1;
	// parameter FLUSH = 2;
	// always @(posedge clk, negedge i_rst_n) begin
	// 	if(!i_rst_n) begin
	// 		ready <= 0;
	// 		state <= 0;
	// 		result <= 0;
	// 	end else begin
	// 		case ( state ) 
	// 			IDLE : begin
	// 				if(i_calc)
	// 					state <= CALC;
	// 			end
	// 			CALC : begin
	// 				ready <= 0;

	// 				state <= FLUSH;
	// 			end
	// 			FLUSH : begin
	// 				for(i=0; i<FIRST_MATRIX_HEIGHT; i=i+1) begin
	// 					for(j=0; j<SECOND_MATRIX_WIDTH; i=i+1) begin
	// 						result[(i*FIRST_MATRIX_HEIGHT+j) * DATA_WIDTH+:8] <= bufer[i][j];
	// 					end
	// 				end
	// 				state <= IDLE;
	// 				ready <= 1;
	// 			end
	// 		endcase
	// 	end
	// end
	
endmodule