`timescale 1ns/1ps

module io_buffer_tb;

parameter DATA_WIDTH = 16;
parameter STACK_SIZE = 256;

reg clk;
reg rst_n;
reg push_cmd;
reg pop_cmd;
reg [ DATA_WIDTH - 1 : 0 ] i_stack_data;
wire [ DATA_WIDTH - 1 : 0 ] o_stack_data;

reg [ DATA_WIDTH - 1 : 0 ] stack_test [ STACK_SIZE - 1 : 0 ];

// io_buffer instance
io_buffer #(.DATA_WIDTH(DATA_WIDTH),
			.STACK_SIZE(STACK_SIZE)
			) 						 io_buffer_inst(.i_clk(clk), 
													.i_rst_n(rst_n),
													.i_push_cmd(push_cmd), 
													.i_pop_cmd(pop_cmd), 
													.i_data(i_stack_data), 
													.o_data(o_stack_data)
													);

initial begin
	forever #1 clk <= !clk;
end

task fill_stack_test;
	integer i;
	for (i = 0; i < STACK_SIZE; i = i + 1) begin
		stack_test[i] = $random;
	end
endtask


task stack_push;
	input [ DATA_WIDTH - 1 : 0 ] i_data;
	@negedge clk;
	i_push_cmd <= 1'b1;
	i_stack_data <= i_data;
	@posedge clk;
endtask

task stack_pop;
	output [ DATA_WIDTH - 1 : 0 ] o_data;
	i_pop_cmd <= 1'b1;
	@posedge clk;
	o_data <= o_stack_data;
endtask

initial begin
	fill_stack_test;
	clk <= 0;
	rst_n <= 0;
	push_cmd <= 0;
	pop_cmd <= 0;
	i_stack_data <= 0;

	@posedge clk;
end

endmodule