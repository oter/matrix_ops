`timescale 1ns / 1ps

// Matrix:
// m = 4
// n = 3
// + +-----n-----+
// | |A11 A12 A13|
// m |A21 A22 A23|
// | |A31 A32 A33|
// | |A41 A42 A43|

module matrix_sum(i_clk, i_rst_n, i_calc_cmd, i_matrix_a, i_matrix_b, o_matrix, o_ready);

	parameter MATRIX_SIZE_M = 4;
	parameter MATRIX_SIZE_N = 3;
	parameter DATA_WIDTH = 16;
	localparam SIZE_BLOCK = MATRIX_SIZE_M * MATRIX_SIZE_N * DATA_WIDTH;

	input i_clk;
	input i_rst_n;
	input i_calc_cmd; // Sum command
	input [SIZE_BLOCK - 1 : 0] i_matrix_a; // Matrix A
	input [SIZE_BLOCK - 1 : 0] i_matrix_b; // Matrix B

	output [SIZE_BLOCK - 1 : 0] o_matrix; // Output amtrix A + B
	output o_ready; // Output state


	reg [DATA_WIDTH - 1 : 0] result_buffer [0 : MATRIX_SIZE_M * MATRIX_SIZE_N - 1];


	// Assign results
	generate
		genvar ai;
		for (ai = 0; ai < MATRIX_SIZE_M * MATRIX_SIZE_N; ai = ai + 1) begin : ASSIGN_RESULT
			assign o_matrix[ai * DATA_WIDTH +: DATA_WIDTH] = result_buffer[ai];
		end
	endgenerate

	// Assign output state
	reg ready;
	assign o_ready = ready;

	integer i, j;
		// Main calculations
	always @(posedge i_clk, negedge i_rst_n) begin : ALWAYS_LOGIC
		if (!i_rst_n) begin : RESET_LOGIC
			// reset result buffer
			for (i = 0; i < MATRIX_SIZE_M * MATRIX_SIZE_N; i = i + 1) begin : RESET_BUFFER_LOGIC
				result_buffer[i] <= 0;
			end
			// reset ready signal
			ready <= 1'b0;
		end else if (i_calc_cmd) begin : CALC_LOGIC
			ready <= 1'b1;
			for (i = 0; i < MATRIX_SIZE_M * MATRIX_SIZE_N; i = i + 1) begin : CALC_BUFFER_LOGIC
				result_buffer[i] <= i_matrix_a[i * DATA_WIDTH +: DATA_WIDTH] +
									i_matrix_b[i * DATA_WIDTH +: DATA_WIDTH];
			end
		end else if (!i_calc_cmd && ready) begin
			ready <= 1'b0;
		end
	end

endmodule