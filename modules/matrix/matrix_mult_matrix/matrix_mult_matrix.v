
module matrix_mult_matrix (clk, i_calc, i_rst_n, i_matrix_1, i_matrix_2, o_result, o_ready);

	parameter FIRST_MATRIX_HEIGHT = 5;
	parameter BOTH_MATRIX_W_H = 5;
	parameter SECOND_MATRIX_WIDTH = 5;

	parameter DATA_WIDTH = 8;

	localparam FIRST_MATRIX_WEIGHT = FIRST_MATRIX_HEIGHT * BOTH_MATRIX_W_H;
	localparam SECOND_MATRIX_WEIGHT = SECOND_MATRIX_WIDTH * BOTH_MATRIX_W_H;
	localparam BUFFER_MATRIX_WEIGHT = FIRST_MATRIX_HEIGHT * SECOND_MATRIX_WIDTH * BOTH_MATRIX_W_H;
	localparam RESULT_MATRIX_WEIGHT = FIRST_MATRIX_HEIGHT * SECOND_MATRIX_WIDTH;
	localparam SUM_PROVIDER_WEIGHT = BUFFER_MATRIX_WEIGHT + RESULT_MATRIX_WEIGHT;
	
	localparam FIRST_MATRIX_SIZE = FIRST_MATRIX_WEIGHT * DATA_WIDTH;
	localparam SECOND_MATRIX_SIZE = SECOND_MATRIX_WEIGHT * DATA_WIDTH;
	localparam BUFFER_MATRIX_SIZE = BUFFER_MATRIX_WEIGHT * DATA_WIDTH;

	localparam RESULT_MATRIX_SIZE = RESULT_MATRIX_WEIGHT * DATA_WIDTH;
	
	input clk;
	input i_rst_n;
	input i_calc;
	input [FIRST_MATRIX_SIZE-1:0] i_matrix_1;
	input [SECOND_MATRIX_SIZE-1:0] i_matrix_2;
	output o_ready;
	output [RESULT_MATRIX_SIZE-1:0] o_result;
	
	reg ready;
	reg [DATA_WIDTH-1:0] buffer [0:BUFFER_MATRIX_WEIGHT-1];
	reg [2:0] state;

	assign o_ready = ready;

	wire [DATA_WIDTH-1:0] sum_provider [0:SUM_PROVIDER_WEIGHT-1];


	generate
		genvar m,n,l; 
		for(n = 0; n < FIRST_MATRIX_HEIGHT; n = n + 1) begin
			for (m = 0; m < SECOND_MATRIX_WIDTH; m = m + 1) begin
				localparam result_position = n*SECOND_MATRIX_WIDTH+m;
				localparam null_offset = (n*SECOND_MATRIX_WIDTH+m)*(BOTH_MATRIX_W_H+1); // оффсет на 0 в sum_provider'e. +1 из-за того, что для 2 элементов надо 3 ячейки(1я ноль)
				
				assign sum_provider[null_offset] = 0;
				for (l = 0; l<BOTH_MATRIX_W_H; l = l + 1 )
					assign sum_provider[null_offset+l+1] = sum_provider[null_offset+l]+buffer[BOTH_MATRIX_W_H*result_position+l];
				assign o_result[result_position*DATA_WIDTH+:DATA_WIDTH] = sum_provider[null_offset+BOTH_MATRIX_W_H];
			end
		end
	endgenerate

	integer i;
	integer j;
	integer k;
	integer buffer_offset;
	integer mult_1;
	integer mult_2;


	parameter IDLE = 0;
	parameter CALC = 1;
	always @(posedge clk, negedge i_rst_n) begin
		if(!i_rst_n) begin
			ready <= 0;
			state <= 0;
		end else begin
			case ( state ) 
				IDLE : begin
					if(i_calc)
						state <= CALC;
				end
				CALC : begin
					ready <= 0;
					for(i=0; i<FIRST_MATRIX_HEIGHT; i=i+1) begin:RUNNING_OVER_HEIGHT
						for(j=0; j<SECOND_MATRIX_WIDTH; j=j+1) begin:RUNNING_OVER_WIDTH
							buffer_offset = (i * FIRST_MATRIX_HEIGHT + j)*BOTH_MATRIX_W_H;
							for(k=0; k<BOTH_MATRIX_W_H; k = k+1) begin:MULTIPLYING_MATRIXES
								mult_1 = i_matrix_1[(BOTH_MATRIX_W_H*i+k)*DATA_WIDTH+:DATA_WIDTH];
								mult_2 = i_matrix_2[(SECOND_MATRIX_WIDTH*k+j)*DATA_WIDTH+:DATA_WIDTH];
								buffer[buffer_offset+k] <= mult_1 * mult_2;
							end
						end
					end	
					state <= IDLE;
					ready <= 1;
				end
			endcase
		end
	end
endmodule