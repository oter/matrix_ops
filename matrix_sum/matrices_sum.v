`timescale 1ns / 1ps

// Matrix:
// m = 4
// n = 3
// + +-----n-----+
// | |A11 A12 A13|
// m |A21 A22 A23|
// | |A31 A32 A33|
// | |A41 A42 A43|

module matrices_sum(i_clk, i_rst_n, i_calc_cmd, i_matrices_a, i_matrices_b, o_matrices, o_ready);
	parameter MATRICES_COUNT = 5;
	parameter MATRIX_SIZE_M = 4;
	parameter MATRIX_SIZE_N = 3;
	parameter DATA_WIDTH = 16;
	localparam BLOCK_SIZE = MATRIX_SIZE_M * MATRIX_SIZE_N * DATA_WIDTH;

	input i_clk;
	input i_rst_n;
	input i_calc_cmd;
	
	input [BLOCK_SIZE * MATRICES_COUNT - 1 : 0] i_matrices_a; // Matrices A
	input [BLOCK_SIZE * MATRICES_COUNT - 1 : 0] i_matrices_b; // Matrices B
	output [BLOCK_SIZE * MATRICES_COUNT - 1 : 0] o_matrices; // Output matrices A + B

	output o_ready;

	wire [MATRICES_COUNT - 1 : 0] readys;
	wire [MATRICES_COUNT - 1 : 0] READY_RES;

	assign READY_RES = {1'b1{MATRICES_COUNT}};

	assign o_ready = (READY_RES == readys ? 1'b1 : 1'b0);

	// Assign results
	generate
		genvar i;
		for (i = 0; i < MATRICES_COUNT; i = i + 1) begin : GEN_MATRICES
			matrix_sum #(	.MATRIX_SIZE_M(MATRIX_SIZE_M),
							.MATRIX_SIZE_N(MATRIX_SIZE_N),
							.DATA_WIDTH(DATA_WIDTH))

			matrix_sum_instance(.i_clk(i_clk),
								.i_rst_n(i_rst_n),
								.i_calc_cmd(i_calc_cmd),
								.i_matrix_a(i_matrices_a[i * BLOCK_SIZE +: BLOCK_SIZE]),
								.i_matrix_b(i_matrices_b[i * BLOCK_SIZE +: BLOCK_SIZE]),
								.o_matrix(o_matrices[i * BLOCK_SIZE +: BLOCK_SIZE]),
								.o_ready(readys[i])
								);
		end
	endgenerate

endmodule