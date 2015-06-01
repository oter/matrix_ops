

module equotion_solver(i_clk, i_rst_n, i_calc_cmd, i_matrix, o_roots, o_ready);

	parameter MATRIX_SIZE = 3;
	parameter DATA_WIDTH = 32;

	input i_clk;
	input i_rst_n;
	input i_calc_cmd;
	input [DATA_WIDTH * MATRIX_SIZE * (MATRIX_SIZE + 1) - 1 : 0] i_matrix;
	output [DATA_WIDTH * MATRIX_SIZE - 1 : 0] o_roots;
	output o_ready;

	wire [DATA_WIDTH - 1 : 0] matrix_unpacked [0 : MATRIX_SIZE - 1][0 : MATRIX_SIZE];

	reg ready;

	reg [DATA_WIDTH - 1 : 0] matrix [0 : MATRIX_SIZE - 1][0 : MATRIX_SIZE];
	reg [DATA_WIDTH - 1 : 0] matrix_buffer [0 : MATRIX_SIZE - 1][0 : MATRIX_SIZE];


	reg [MATRIX_SIZE - 1 : 0] divs_mask;
	wire results_ready_stb [0 : MATRIX_SIZE * (MATRIX_SIZE + 1) - 1];
	wire results_ready_ack [0 : MATRIX_SIZE * (MATRIX_SIZE + 1) - 1];
	wire [DATA_WIDTH - 1 : 0] row_dividers [0 : MATRIX_SIZE - 1];
	wire [DATA_WIDTH - 1 : 0] matrix_div_result [0 : MATRIX_SIZE - 1][0 : MATRIX_SIZE];
	reg divisors_stb;
	reg divisors_z_ack;
	wire divisors_stb;
	wire divisors_ack;

	assign divisors_stb = results_ready_stb == {1'b1 {MATRIX_SIZE * (MATRIX_SIZE + 1)}};
	assign divisors_ack = results_ready_ack == {1'b1 {MATRIX_SIZE * (MATRIX_SIZE + 1)}};


	// Unpacking matrix and generating divisors
	generate
		genvar id, jd;
		for (id = 0; id < MATRIX_SIZE; id = id + 1) begin : GEN_UNPACK_I
			for (jd = 0; jd < MATRIX_SIZE + 1; jd = jd + 1) begin : GEN_UNPACK_J
				assign matrix_unpacked[id][jd] = i_matrix[DATA_WIDTH * (id * (MATRIX_SIZE + 1) + jd) +: DATA_WIDTH];
				divider divider_insts(
					.input_a(matrix_unpacked[id][jd]), 		// input, dividend
        			.input_b(row_dividers[id]), 			// input, divisor
        			.input_stb(divisors_stb), 				// input, initiates division
        			.output_z_ack(divisors_z_ack), 			// input, allows writing RESULT to output buffer
        			.clk(i_clk), 							// input, clock
        			.rst_n(i_rst_n), 						// input, neg async reset
        			.output_z(matrix_div_result[id][jd]),	// output, result
        			.output_z_stb(results_ready_stb[(id * (MATRIX_SIZE + 1) + jd)]),// output, indicates that RESULT is ready
        																			// and it can be passed to output buffer
        			.input_ack(results_ready_ack[(id * (MATRIX_SIZE + 1) + jd)]));	// output, indicates that module is in IDLE 
																					// state and can accept operands
			end
		end
	endgenerate


	
	reg [2 : 0] state;

	parameter IDLE = 0, DIV_WAIT = 1, DIV_ACCEPT = 2, DIV_WRITE_BUFFER = 3;
	integer i, j;
	always @(posedge clk or negedge i_rst_n) begin
		if (!i_rst_n) begin
			divs_mask <= {1'b1{MATRIX_SIZE - 1}};
			state <= IDLE;
			divisors_stb <= 0;

		end
		else begin
			case(state)
				IDLE:
				begin
					divisors_stb <= 0;
					divs_mask <= {1'b1{MATRIX_SIZE - 1}};
					if (i_calc_cmd) 
						state <= DIV_WAIT;
				end


				DIV_WAIT:
				begin
					divisors_stb <= 1; //  Initiate division
					if (divisors_stb)
						state <= DIV_WRITE;
				end
				
				DIV_ACCEPT:
				begin
					if (divisors_ack)
						state <= DIV_WRITE_BUFFER;
				end

				DIV_WRITE_BUFFER:
				begin
					state <= IDLE;
					for(i = 0; i < MATRIX_SIZE; i = i + 1) begin
						for (j = 0; j < MATRIX_SIZE + 1; j = j + 1) begin
							matrix_buffer[i][j] <= matrix_div_result[i][j];
						end
					end

				end
				

			endcase

			
		end
	end


assign o_ready = ready;


endmodule