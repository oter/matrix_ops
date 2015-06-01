

module equotion_solver(i_clk, i_rst_n, i_calc_cmd, i_matrix, o_roots, o_ready);

	parameter MATRIX_SIZE = 3;
	parameter DATA_WIDTH = 32;

	input i_clk;
	input i_rst_n;
	input i_calc_cmd;
	input [DATA_WIDTH * MATRIX_SIZE * (MATRIX_SIZE + 1) - 1 : 0] i_matrix;
	output [DATA_WIDTH * MATRIX_SIZE - 1 : 0] o_roots;
	output o_ready;

	reg ready;

	wire [DATA_WIDTH - 1 : 0] matrix [0 : MATRIX_SIZE - 1][0 : MATRIX_SIZE];
	reg [DATA_WIDTH - 1 : 0] matrix_buffer [0 : MATRIX_SIZE - 1][0 : MATRIX_SIZE];

	// Unpacking matrix
	generate
		genvar id;
		for (id = 0; id < MATRIX_SIZE; id = id + 1)
		begin:identifier
			
		end
	endgenerate


assign o_ready = ready;


endmodule