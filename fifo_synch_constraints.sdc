############################################################
# Clock Definition
############################################################

create_clock -name clk -period 10 [get_ports clk]

############################################################
# Clock Uncertainty
############################################################

set_clock_uncertainty -setup 0.200 [get_clocks clk]
set_clock_uncertainty -hold  0.050 [get_clocks clk]

############################################################
# Clock Transition
############################################################

set_clock_transition 0.1 [get_clocks clk]

############################################################
# Input Delays
############################################################

set_false_path -from [get_ports rst_n]
set_input_delay 2 -clock clk [get_ports wr_en]
set_input_delay 2 -clock clk [get_ports rd_en]
set_input_delay 2 -clock clk [get_ports data_in[*]]

############################################################
# Output Delays
############################################################

set_output_delay 2 -clock clk [get_ports data_out[*]]
set_output_delay 2 -clock clk [get_ports full]
set_output_delay 2 -clock clk [get_ports empty]

############################################################
# Input Driving Cell
############################################################

#set_driving_cell \
#lib_cell BUF_X1 \
#[get_ports {rst_n wr_en rd_en data_in[*]}]

############################################################
# Output Load
############################################################

set_load 0.05 [get_ports {data_out[*] full empty}]
