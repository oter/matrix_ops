`timescale 1ns / 1ps

module equotion_solver_tb;

	parameter MATRIX_SIZE = 3;
	parameter DATA_WIDTH = 32;

	reg clk;
	reg rst_n;

	initial begin
		clk = 0;
		forever #1 clk = !clk;
	end

	reg [DATA_WIDTH - 1 : 0] a;
	reg [DATA_WIDTH - 1 : 0] b;
	wire [DATA_WIDTH - 1 : 0] result;
	wire z_stb;

	wire ack;
	reg calc_cmd;
	reg z_ack;

	reg [DATA_WIDTH - 1 : 0] matrix [0 : MATRIX_SIZE - 1][0 : MATRIX_SIZE];
	


	generate
		genvar id, jd;
		for (id = 0; id < MATRIX_SIZE; id = id + 1) begin : GEN_UNPACK_I
			for (jd = 0; jd < MATRIX_SIZE + 1; jd = jd + 1) begin : GEN_UNPACK_J
				assign matrix_unpacked = i_matrix[DATA_WIDTH * (id * (MATRIX_SIZE + 1) + jd) +: DATA_WIDTH];
																			// state and can accept operands
			end
		end
	endgenerate


	equotion_solver equotion_solver_inst(
		.i_clk(clk),
		.i_rst_n(rst_n),
		.i_calc_cmd(calc_cmd),

		.i_matrix(z_ack),
		.clk(clk),
		.rst_n(rst_n),
		.output_z(result),
		.output_z_stb(z_stb),
		.input_ack(ack));

	initial begin
		#10000;
		$display("Unexpected finish");
		$finish;
	end

	initial begin
		a = 0;
		b = 0;
		calc_cmd = 0;
		z_ack = 0;
		rst_n = 0;
		#2;
		calc_cmd = 1;
		a = 32'h3fa00000; // 1.25
		b = 32'h430ffba6;// 143.983000

		@(posedge z_stb);
		#5;
		$finish;

	end


	


endmodule