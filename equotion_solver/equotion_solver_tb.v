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
	reg stb;
	reg z_ack;


	divider divider_inst(	.input_a(a),
        						.input_b(b),
        						.input_stb(stb),
        						.output_z_ack(z_ack),
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
		stb = 0;
		z_ack = 0;
		rst_n = 0;
		#1;
		rst_n = 1;
		z_ack = 1;
		#2;
		stb = 1;
		a = 32'h3fa00000; // 1.25
		b = 32'h430ffba6;// 143.983000

		@(posedge z_stb);
		#5;
		$finish;

	end


	


endmodule