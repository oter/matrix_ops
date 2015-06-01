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
	input [FIRST_MATRIX_SIZE-1:0] i_matrix;
	input [SECOND_MATRIX_SIZE-1:0] i_vector;
	output o_ready;
	output [RESULT_MATRIX_SIZE-1:0] o_result;
	
	reg ready;
	reg [RESULT_MATRIX_SIZE-1:0] result;
	reg [DATA_WIDTH-1:0] buffer [0:BUFFER_MATRIX_WEIGHT-1];
	reg [1:0] state;

	integer i;
	integer j;
	integer k;

	assign o_ready = ready;
	parameter IDLE = 0;
	parameter CALC = 1;
	parameter WAITING = 2;
	always @(posedge clk, negedge i_rst_n) begin
		if(!i_rst_n) begin
			ready <= 0;
			state <= 0;
			result <= 0;
		else begin
			case ( state ) 
				IDLE : begin
					
				end
			endcase
		end
	end
	
endmodule