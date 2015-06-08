module matrix_mult_matrix_tb;
	parameter DUMP = 1;

	parameter FIRST_MATRIX_HEIGHT = 2;
	parameter BOTH_MATRIX_W_H = 2;
	parameter SECOND_MATRIX_WIDTH = 2;

	parameter DATA_WIDTH = 8;

	localparam FIRST_MATRIX_WEIGHT = FIRST_MATRIX_HEIGHT * BOTH_MATRIX_W_H;
	localparam SECOND_MATRIX_WEIGHT = SECOND_MATRIX_WIDTH * BOTH_MATRIX_W_H;

	localparam FIRST_MATRIX_SIZE = FIRST_MATRIX_WEIGHT * DATA_WIDTH;
	localparam SECOND_MATRIX_SIZE = SECOND_MATRIX_WEIGHT * DATA_WIDTH;
	localparam RESULT_MATRIX_SIZE = FIRST_MATRIX_HEIGHT * SECOND_MATRIX_WIDTH * DATA_WIDTH;
	
	reg calculate = 0;
	reg clk = 0;
	reg reset_multiplier = 1;
	

	wire ready;
	wire [RESULT_MATRIX_SIZE-1:0]result;
	
	reg [FIRST_MATRIX_SIZE-1:0] matrix1 = {8'd1, 8'd2, 8'd3, 8'd4};
	reg [SECOND_MATRIX_SIZE-1:0] matrix2 = {8'd5, 8'd6, 8'd7, 8'd8};
	wire [DATA_WIDTH-1:0] test1;
	wire [DATA_WIDTH-1:0] test2;
	wire [DATA_WIDTH-1:0] test3;
	wire [DATA_WIDTH-1:0] test4;
	assign test1 = result[0+:DATA_WIDTH];
	assign test2= result[DATA_WIDTH+:DATA_WIDTH];
	assign test3 = result[DATA_WIDTH*2+:DATA_WIDTH];
	assign test4 = result[DATA_WIDTH*3+:DATA_WIDTH];
	initial begin
		$dumpfile("out.vcd");
	  	$dumpvars(0,matrix_mult_matrix_tb);
	  	reset_multiplier <= 0;
	  	@(negedge clk);
		reset_multiplier <= 1;
	  	calculate <= 1;
	  	#1 calculate <= 0;
		#100 $finish;
	end
	initial forever #1 clk = !clk;
	
	
	
	
	matrix_mult_matrix  #(	.FIRST_MATRIX_HEIGHT(FIRST_MATRIX_HEIGHT), 
						 	.BOTH_MATRIX_W_H(BOTH_MATRIX_W_H), 
							.SECOND_MATRIX_WIDTH(SECOND_MATRIX_WIDTH),
							.DATA_WIDTH(DATA_WIDTH)
						)
									multiplier(.clk(clk), 
										.i_calc(calculate),
										.i_rst_n(reset_multiplier), 
										.i_matrix_1(matrix1), 
										.i_matrix_2(matrix2), 
										.o_result(result), 
										.o_ready(ready)
									);	
	// initial $monitor("At time %d, clk = %h rst=%h result=%h ready=%h",$time, clk, reset_multiplier, result, ready);
endmodule