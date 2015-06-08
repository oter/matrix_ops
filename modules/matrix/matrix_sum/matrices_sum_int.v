`timescale 1ns / 1ps

// Matrix:
// m = 4
// n = 3
// + +-----n-----+
// | |A11 A12 A13|
// m |A21 A22 A23|
// | |A31 A32 A33|
// | |A41 A42 A43|

// Input data:
// |-matrices_count-| 0
// |---matrix_a_0---| 1
// |---matrix_a_1---| 2
// |---..........---| ...
// |---matrix_a_N---| matrices_count - 1

// |---matrix_b_0---| matrices_count 
// |---matrix_b_1---| matrices_count + 1
// |---..........---| ...
// |---matrix_b_N---| 2 * matrices_count - 1
// 

module matrices_sum_int(i_clk, i_rst_n, i_push, i_data, i_pop, o_data, o_ready, o_res_avail);
	function integer clogb2;
		input [31:0] value;
		integer i;
		begin
			for(i = 0; 2**i < value; i = i + 1)
				clogb2 = i + 1;
		end
	endfunction	

	parameter DATA_WIDTH = 16;
	parameter BUFFER_SIZE = 256; // buffer for operands, number must be power of 2! 
	parameter REGS_WIDTH = 16;

	input i_clk;
	input i_rst_n;
	input i_push;
	input [DATA_WIDTH - 1 : 0] i_data;
	input i_pop;

	output [DATA_WIDTH - 1 : 0] o_data;
	output o_ready;
	output o_res_avail;

	reg ready; // ready register, 1 - result is ready and can be popped, 0 - device is busy

	assign o_ready = ready;

	reg signed [DATA_WIDTH - 1 : 0] buffer [0 : BUFFER_SIZE - 1];
	reg signed [DATA_WIDTH - 1 : 0] res_buffer [0 : BUFFER_SIZE / 2 - 1];
	reg signed [DATA_WIDTH - 1 : 0] res_out_buffer;
	reg [REGS_WIDTH - 1 : 0] matrices_count;
	reg [clogb2(BUFFER_SIZE) - 1 : 0] buffer_pointer; 
	reg [clogb2(BUFFER_SIZE) - 1 : 0] m_counter;
	reg [2 : 0] state;
	reg res_avail;

	assign o_data = res_out_buffer;
	assign o_res_avail = res_avail;

	localparam 	IDLE = 0, 
				LOAD_SIZE = 1, 
				LOAD_OPERANDS_1 = 2, 
				LOAD_OPERANDS_2 = 3, 
				PERFORM_CALC = 4;

	integer i;
	always @(posedge i_clk, negedge i_rst_n) begin
		if (!i_rst_n) begin // async reset
			m_counter <= 0;
			ready <= 1'b1;
			state <= IDLE;
			buffer_pointer <= 0;	
			matrices_count <= 0;
			res_out_buffer <= 0;
			res_avail <= 0;	
		end else begin
			case(state)
				IDLE : begin
					m_counter <= 0;
					ready <= 1'b1;
					if (i_pop && res_avail) begin
						res_out_buffer <= res_buffer[buffer_pointer];
						buffer_pointer <= buffer_pointer + 1'b1;
						if (buffer_pointer == matrices_count - 1) begin
							buffer_pointer <= 0;
							matrices_count <= 0;
							res_avail <= 0;
						end
					end
					if (i_push) begin
						state <= LOAD_SIZE;
					end	
				end

				LOAD_SIZE : begin
					ready <= 0'b0;
					if (i_push) begin
						state <= LOAD_OPERANDS_1;
						matrices_count <= i_data;
					end else begin
						state <= IDLE;
						res_avail <= 0;
						buffer_pointer <= 0;
					end
				end

				LOAD_OPERANDS_1 : begin
					ready <= 0'b0;
					if (i_push) begin
						if (m_counter < matrices_count) begin
							buffer[m_counter] <= i_data;
							if (m_counter == matrices_count - 1) begin
								m_counter <= 0;
								state <= LOAD_OPERANDS_2;
							end else begin
								m_counter <= m_counter + 1'b1;
							end
						end else begin
							state <= IDLE;
							res_avail <= 0;
							buffer_pointer <= 0;
						end
					end else begin
						state <= IDLE;
						res_avail <= 0;
						buffer_pointer <= 0;
					end
				end

				LOAD_OPERANDS_2 : begin
					ready <= 0'b0;
					if (i_push) begin
						if (m_counter < matrices_count) begin
							buffer[m_counter | (BUFFER_SIZE / 2)] <= i_data;
							if (m_counter == matrices_count - 1) begin
								state <= PERFORM_CALC;
							end else begin
								m_counter <= m_counter + 1'b1;
							end
						end else begin
							state <= IDLE;
							res_avail <= 0;
							buffer_pointer <= 0;
						end
					end else begin
						state <= IDLE;
						res_avail <= 0;
						buffer_pointer <= 0;
					end
				end

				PERFORM_CALC : begin
					state <= IDLE;
					ready <= 1'b1;
					res_avail <= 1'b1;
					for (i = 0; i < BUFFER_SIZE; i = i + 1) begin
						res_buffer[i] <= buffer[i] + buffer[i + BUFFER_SIZE / 2]; 
					end
				end
				default : begin
					state <= IDLE;
					res_avail <= 0;
					buffer_pointer <= 0;
				end
			endcase

		end
	end

endmodule