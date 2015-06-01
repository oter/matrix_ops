`timescale 1ns/1ps

function integer log2;
	integer value;
	for (log2 = 0; value > 0; log2 = log2 + 1)
	value = value >> 1;
endfunction

// Target: Sum module

module io_buffer(i_clk, i_rst_n, i_push_cmd, i_pop_cmd, i_data, o_data);

	parameter DATA_WIDTH = 16;
	parameter STACK_SIZE = 256;

	localparam STACK_PTR_WIDTH = log2(DATA_WIDTH);

	input i_clk;
	input i_rst_n;
	input i_push_cmd;
	input i_pop_cmd;
	input [ DATA_WIDTH - 1 : 0 ] i_data;

	output [ DATA_WIDTH - 1 : 0 ] o_data;

	reg [ DATA_WIDTH - 1 : 0 ] stack [ 0 : STACK_SIZE - 1 ];
	reg [ STACK_PTR_WIDTH - 1 : 0 ] stack_pointer;
	reg [ DATA_WIDTH - 1 : 0 ] o_data_reg;

	assign o_data = o_data_reg;

	always @(posedge i_clk, negedge i_rst_n) begin
		if (i_rst_n) begin
			integer i;

			for (i = 0; i < STACK_SIZE; i = i + 1) begin
				stack <= 0;
			end
			o_data <= 0;
			stack_pointer <= 0;
			o_data_reg <= 0;
		end
		else if (i_push_cmd) begin
			stack_pointer <= stack_pointer + 1;
			stack[stack_pointer] <= i_data;
		end 
		else if (i_pop_cmd) begin
			stack_pointer <= stack_pointer - 1;
			o_data_reg <= stack[stack_pointer];		
		end
	end

endmodule