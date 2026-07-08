# 1. Load the Nangate Library
read_liberty /home/aari/verilog/sky130_fd_sc_hd__tt_025C_1v80.lib

# 2. Read your Synthesized Netlist (use your flattened file name)
read_verilog fifo_synch_netlist.v

# 3. Link the design to the top module
link_design synch_fifo_bram

# 4. Read the constraints we just made
read_sdc fifo_synch_constraints.sdc

# 5. Generate the Timing Reports
puts "\n--- STARTING TIMING ANALYSIS ---"
report_checks -path_delay max -format full
report_checks -path_delay min -format full
puts "--- ANALYSIS COMPLETE ---"


# --- STARTING POWER ANALYSIS ---
puts "\n--- POWER REPORT ---"

# Vectorless power estimation (estimates power based on clock frequency)
report_power

puts "--- ANALYSIS COMPLETE ---"

exit
