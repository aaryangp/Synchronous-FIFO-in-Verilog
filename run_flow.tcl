# ==============================================================================
# OpenROAD Automated PnR Flow Script for Synchronous FIFO
# ==============================================================================

# 1. Load Technology and Cell Library Geometries (LEF)
read_lef /home/aari/skywater-pdk-libs-sky130_fd_sc_hd/tech/sky130_fd_sc_hd__nom.tlef
read_lef /home/aari/OpenROAD-flow-scripts/tools/OpenROAD/test/sky130hd/sky130_fd_sc_hd_merged.lef

# 2. Load Cell Timing and Power Characteristics (Liberty)
read_liberty /home/aari/verilog/sky130_fd_sc_hd__tt_025C_1v80.lib

# 3. Read Synthesized Gate-Level Netlist
# (Double-check that this path matches where your actual .v file lives!)
read_verilog /home/aari/verilog/fifo_synch_netlist.v

# 4. Link Design Hierarchy (Matches your top-level module name)
link_design synch_fifo_bram

# 5. Initialize Physical Canvas Floorplan
initialize_floorplan -die_area {0 0 150 150} -core_area {15 15 135 135} -site unithd

# 6. Initialize Routing Tracks (Crucial for Pin Placement and Routing)
make_tracks

# 7. Assign I/O Pins Along Design Edges
place_pins -hor_layer met3 -ver_layer met2

# 8. Define Timing Constraints (Declares 'clk' pin as a true clock for CTS)
create_clock -name my_clk -period 10.0 [get_ports clk]

# 9. Global Placement (Group standard cells by density optimization)
global_placement -density 0.70

# 10. Legalize Placement (Snap cells cleanly onto layout rows)
detailed_placement

# 11. Clock Tree Synthesis (With safety overrides for open-source library tables)
set_wire_rc -layer met2
catch { clock_tree_synthesis -root_buf sky130_fd_sc_hd__clkbuf_16 -buf_list sky130_fd_sc_hd__clkbuf_4 }

# 12. Global Routing (Map rough signal interconnect routes)
global_route

# 13. Detailed Routing (Generate physical metal tracks and vias)
detailed_route
