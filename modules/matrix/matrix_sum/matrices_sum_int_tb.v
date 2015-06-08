`timescale 1ns / 1ps

// Matrix:
// m = 4
// n = 3
// + +-----n-----+
// | |A11 A12 A13|
// m |A21 A22 A23|
// | |A31 A32 A33|
// | |A41 A42 A43|


module matrices_sum_int_tb;

	parameter DATA_WIDTH = 16;
	parameter BUFFER_SIZE = 256; // buffer for operands, number must be power of 2! 
	parameter REGS_WIDTH = 16;
	localparam MATRICES_SIZE = 6;
	localparam SIZE_BLOCK = MATRICES_SIZE * DATA_WIDTH;

	reg clk;
	reg rst_n;
	reg push;
	reg pop;
	reg [SIZE_BLOCK - 1 : 0] matrices_a  = {16'b10, 16'b01, 16'b11, 16'b11, 16'b01, 16'b0};
	reg [SIZE_BLOCK - 1 : 0] matrices_b  = {16'b10, 16'b01, 16'b11, 16'b11, 16'b01, 16'b0};
	reg [DATA_WIDTH - 1 : 0] results [0 : MATRICES_SIZE - 1];
	wire ready;
	reg [DATA_WIDTH - 1 : 0] data;
	wire [DATA_WIDTH - 1 : 0] o_data;
	wire res_avail;

	

	matrices_sum_int #(	.DATA_WIDTH(DATA_WIDTH),
						.BUFFER_SIZE(BUFFER_SIZE), 
						.REGS_WIDTH(REGS_WIDTH)) 

			matrices_sum_int_in(.i_clk(clk),
								.i_rst_n(rst_n),
								.i_push(push),
								.i_data(data),
								.i_pop(pop),
								.o_data(o_data),
								.o_ready(ready),
								.o_res_avail(res_avail)
								);
	task reset_device;
		begin
			rst_n = 0;
			@(posedge clk);
			@(posedge clk);
			rst_n = 1;
		end
	endtask

	integer i;
	task push_matrices;
		begin
			push <= 1;
			rst_n <= 1;
			@(posedge clk); // initiate load
			data <= MATRICES_SIZE;
			@(posedge clk); // load number of all elements in matrices
			for (i = 0; i < MATRICES_SIZE; i = i + 1) begin
				data <= matrices_a[i * DATA_WIDTH +: DATA_WIDTH];
				@(posedge clk);
			end

			for (i = 0; i < MATRICES_SIZE; i = i + 1) begin
				data <= matrices_b[i * DATA_WIDTH +: DATA_WIDTH];
				@(posedge clk);
			end
			push <= 0;
		end
	endtask

	integer counter;
	task pop_results;
		begin
			if (!ready) begin
				@(posedge res_avail);
			end
			counter <= 0;
			pop <= 1;
			@(posedge clk);
			while (res_avail == 1'b1) begin
				@(posedge clk);
				results[MATRICES_SIZE - counter - 1] <= o_data;
				counter <= counter + 1;
			end
		end
	endtask

	initial begin // initialization
		push <= 0;
		pop <= 0;
	end


	// Clock generation
	initial begin
		clk <= 0;
		forever #1 clk <= !clk;
	end

	// 
	initial begin
		reset_device;
		push_matrices;
		pop_results;
		
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		//@(posedge ready);
		$finish; 
	end

endmodule