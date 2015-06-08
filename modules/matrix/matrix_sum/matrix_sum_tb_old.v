`timescale 1ns/1ps

// Matrix:
// m = 4
// n = 3
// + +-----n-----+
// | |A11 A12 A13|
// m |A21 A22 A23|
// | |A31 A32 A33|
// | |A41 A42 A43|


module matrices_sum_tb;

	parameter MATRICES_COUNT = 5;
	parameter MATRIX_SIZE_M = 3;
	parameter MATRIX_SIZE_N = 2;
	parameter DATA_WIDTH = 16;

	localparam SIZE_BLOCK = MATRIX_SIZE_M * MATRIX_SIZE_N * DATA_WIDTH;

	reg clk;
	reg rst_n;
	reg calc_cmd;
	reg [SIZE_BLOCK - 1 : 0] matrices_a  = {16'b10, 16'b01, 16'b11, 16'b11, 16'b01, 16'b0};
	reg [SIZE_BLOCK - 1 : 0] matrices_b  = {16'b10, 16'b01, 16'b11, 16'b11, 16'b01, 16'b0};
	wire [SIZE_BLOCK - 1 : 0] matrices;
	wire [DATA_WIDTH - 1 : 0] matrices_unpacked[0 : MATRIX_SIZE_M - 1][0 : MATRIX_SIZE_N - 1];
	wire ready;

	

	matrix_sum #(	.MATRIX_SIZE_M(MATRIX_SIZE_M),
					.MATRIX_SIZE_N(MATRIX_SIZE_N), 
					.DATA_WIDTH(DATA_WIDTH)) 

			matrix_sum_instance(.i_clk(clk),
								.i_rst_n(rst_n),
								.i_calc_cmd(calc_cmd),
								.i_matrix_a(matrices_a),
								.i_matrix_b(matrices_b),
								.o_matrix(matrices),
								.o_ready(ready)
								);
	// Clock generation
	initial begin
		clk = 0;
		forever #1 clk = !clk;
	end

	// 
	initial begin
		calc_cmd = 0;
		rst_n = 0;
		@(posedge clk);
		rst_n = 1;
		@(posedge clk);
		calc_cmd = 1;
		@(posedge ready);
		$finish; 
	end

endmodule