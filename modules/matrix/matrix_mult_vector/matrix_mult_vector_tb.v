module matrix_mult_vector_tb;
	parameter DUMP = 1;
	parameter MATRIX_WIDTH = 2;
	parameter MATRIX_HEIGHT = 2;
	parameter DATA_WIDTH = 8;
	parameter MATRIX_WEIGHT = MATRIX_WIDTH*MATRIX_HEIGHT;

	parameter MATRIX_SIZE = MATRIX_WEIGHT*DATA_WIDTH;
	parameter VECTOR_SIZE = MATRIX_WIDTH*DATA_WIDTH;
	
	reg calculate = 0;
	reg clk = 0;
	reg reset_multiplier = 1;
	
	wire[8:0] res1;
	wire[8:0] res2;
	wire[8:0] res3;
	wire[8:0] res4;
	
	assign res1=result[0+:DATA_WIDTH];
	assign res2=result[DATA_WIDTH+:DATA_WIDTH];
	assign res3=result[DATA_WIDTH*2+:DATA_WIDTH];
	assign res4=result[DATA_WIDTH*3+:DATA_WIDTH];

	
	wire ready;
	wire [MATRIX_SIZE-1:0]result;
	
	reg [MATRIX_SIZE-1:0]matrix = {8'b10,8'b11,8'b110,8'b1110};
	reg [VECTOR_SIZE-1:0]vector = {8'b1010,8'b1110};
	
	initial begin
		if(DUMP) begin
			$dumpfile("out.vcd");
		  	$dumpvars(0,matrix_mult_vector_tb);
		end
	  	reset_multiplier <= 0;
	  	@(negedge clk);
		reset_multiplier <= 1;
	  	calculate <= 1;
	  	
		@(posedge clk)
		$finish;
		#10 $finish;
	end
	initial forever #1 clk = !clk;
	
	
	
	
	matrix_mult_vector  #(	.MATRIX_WIDTH(MATRIX_WIDTH), 
						 	.MATRIX_HEIGHT(MATRIX_HEIGHT), 
							.MATRIX_WEIGHT(MATRIX_WEIGHT),
							.DATA_WIDTH(DATA_WIDTH)
						)
									multiplier(.clk(clk), 
										.i_calc(calculate),
										.i_rst_n(reset_multiplier), 
										.i_matrix(matrix), 
										.i_vector(vector), 
										.o_result(result), 
										.o_ready(ready)
									);	
	initial $monitor("At time %d, clk = %h rst=%h result=%h ready=%h",$time, clk, reset_multiplier, result, ready);
endmodule