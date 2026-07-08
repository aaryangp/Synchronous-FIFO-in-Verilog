# ==========================================
# Post-Layout Timing Verification Script
# ==========================================

# 1. Load the physical LEF & DEF databases
read_lef "/home/aari/skywater-pdk-libs-sky130_fd_sc_hd/tech/sky130_fd_sc_hd__nom.tlef"
read_lef "/home/aari/OpenROAD-flow-scripts/flow/platforms/sky130hd/lef/sky130_fd_sc_hd_merged.lef"

read_verilog "/home/aari/verilog/fifo_synch_netlist.v"
read_def "synch_fifo_layout.def"

# 2. Read the timing models (.lib) and design constraints (.sdc)
read_liberty "/home/aari/skywater-pdk-libs-sky130_fd_sc_hd/timing/sky130_fd_sc_hd__tt_025C_1v80.lib"
link_design "synch_fifo_bram"
read_sdc "/home/aari/verilog/fifo_synch_constraints.sdc"

# 3. Propagate the actual clocks (enables true layout wire delay/skew calculation)
set_propagated_clock [all_clocks]

puts "\n========================================================"
puts "                CRITICAL PATH REPORT (SETUP)            "
puts "========================================================"
report_checks -path_delay max -fields {slew cap input_pin incr delay} -digits 3

puts "\n========================================================"
puts "                CRITICAL PATH REPORT (HOLD)             "
puts "========================================================"
report_checks -path_delay min -fields {slew cap input_pin incr delay} -digits 3

puts "\n========================================================"
puts "                SUMMARY TIMING METRICS                  "
puts "========================================================"
report_wns
report_tns

exit
