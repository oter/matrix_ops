module matrix_mult_vector (clk, i_calc, i_rst_n, i_matrix, i_vector, o_result, o_ready);

	parameter MATRIX_WIDTH = 5;
	parameter MATRIX_HEIGHT = 5;
	parameter DATA_WIDTH = 8;
	parameter MATRIX_WEIGHT = MATRIX_WIDTH*MATRIX_HEIGHT;
	
	parameter MATRIX_SIZE = MATRIX_WEIGHT*DATA_WIDTH;
	parameter VECTOR_SIZE = MATRIX_WIDTH*DATA_WIDTH;
	
	
	input clk;
	input i_rst_n;
	input i_calc;
	input [MATRIX_SIZE-1:0] i_matrix;
	input [VECTOR_SIZE-1:0] i_vector;
	output o_ready;
	output [MATRIX_SIZE-1:0] o_result;
	
	reg ready;
	reg [MATRIX_SIZE-1:0] result;
	
	assign o_ready = ready;
	assign o_result = result;
	
	genvar i;
	generate for(i=0; i<MATRIX_WEIGHT; i=i+1)
		assign o_result[i] = result[i];	
	endgenerate 
	
	integer j;
	integer k;
	integer index;
	always @(posedge clk, negedge i_rst_n) begin
		if(!i_rst_n) begin
			for(index = 0; index < MATRIX_SIZE; index = index+1)
				result[index] <= 0;
			ready <=0;	
		end else if(i_calc) begin
			for(j=0; j<MATRIX_WIDTH; j=j+1) begin
				for(k=0; k<MATRIX_HEIGHT; k=k+1) begin
					index = j*MATRIX_WIDTH+k;
					result[index*DATA_WIDTH+:DATA_WIDTH] = i_matrix[index*DATA_WIDTH+:DATA_WIDTH] * i_vector[k*DATA_WIDTH+:DATA_WIDTH];
				end	
			end
			ready <= 1;
		end else if(!i_calc && ready) 
			ready <= 0;
	end
endmodule