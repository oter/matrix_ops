`timescale 1ns / 1ps


// Target: Sum module

module io_shift_buffer(i_clk, i_rst_n, i_shift_extern, i_load, 
	i_data_extern, i_data, o_data_extern, o_data);

	parameter DATA_WIDTH = 16;	// global bus width
	parameter FIFO_SIZE = 256; // reserved number of elements in fifo

	input i_clk;				// input clock
	input i_rst_n;				// input async negative reset
	input i_shift_extern;		// input shifts fifo
	input i_load;				// input load signal, rewrites stored values with data fom i_data
	input [DATA_WIDTH - 1 : 0] i_data_extern; // 
	input [FIFO_SIZE * DATA_WIDTH - 1 : 0] i_data;

	output [DATA_WIDTH - 1 : 0] o_data_extern;
	output [FIFO_SIZE * DATA_WIDTH - 1 : 0] o_data;

	reg [DATA_WIDTH - 1 : 0] fifo [0 : FIFO_SIZE - 1];


	// assign o_data
	generate
		genvar i;
		for (i = 0; i < FIFO_SIZE; i = i + 1) begin : O_DATA_GEN
			assign o_data[i * DATA_WIDTH +: DATA_WIDTH] = fifo[i];
		end
	endgenerate

	// assign o_data_extern
	assign o_data_extern = fifo[FIFO_SIZE - 1];

	always @(posedge i_clk, negedge i_rst_n) begin
		if (!i_rst_n) begin
			integer i;

			for (i = 0; i < FIFO_SIZE; i = i + 1) begin
				fifo[i] <= 0;
			end
		end else if (i_shift_extern) begin
			integer i;

			for (i = 0; i < FIFO_SIZE - 1; i = i + 1) begin
				fifo[i + 1] <= fifo[i];
			end
		end else if (i_load) begin
			fifo <= i_data;
		end
	end

endmodule