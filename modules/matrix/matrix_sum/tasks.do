vsim -gui -novopt matrix_sum.matrices_sum_int_tb

add wave -position insertpoint  \
sim:/matrices_sum_int_tb/matrices_sum_int_in/i_clk \
sim:/matrices_sum_int_tb/matrices_sum_int_in/i_rst_n \
sim:/matrices_sum_int_tb/matrices_sum_int_in/i_push \
sim:/matrices_sum_int_tb/matrices_sum_int_in/i_data \
sim:/matrices_sum_int_tb/matrices_sum_int_in/i_pop \
sim:/matrices_sum_int_tb/matrices_sum_int_in/o_data \
sim:/matrices_sum_int_tb/matrices_sum_int_in/o_ready \
sim:/matrices_sum_int_tb/matrices_sum_int_in/o_res_avail \
sim:/matrices_sum_int_tb/matrices_sum_int_in/ready \
sim:/matrices_sum_int_tb/matrices_sum_int_in/buffer \
sim:/matrices_sum_int_tb/matrices_sum_int_in/res_buffer \
sim:/matrices_sum_int_tb/matrices_sum_int_in/res_out_buffer \
sim:/matrices_sum_int_tb/matrices_sum_int_in/matrices_count \
sim:/matrices_sum_int_tb/matrices_sum_int_in/buffer_pointer \
sim:/matrices_sum_int_tb/matrices_sum_int_in/m_counter \
sim:/matrices_sum_int_tb/matrices_sum_int_in/state \
sim:/matrices_sum_int_tb/matrices_sum_int_in/res_avail

run -all