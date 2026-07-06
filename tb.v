`timescale 1ns / 1ps

module synch_fifo_bram_tb;

    // Define parameters for the test scenario
    parameter DBITS = 8;
    parameter DDEPTH = 4; // Small depth makes it very easy to trace full/empty loops

    // Testbench signals
    reg              clk;
    reg              rst_n;
    reg              wr_en;
    reg              rd_en;
    reg  [DBITS-1:0] data_in;
    wire             full;
    wire             empty;
    wire [DBITS-1:0] data_out;

    // Instantiate the Parameterized BRAM FIFO Module
    synch_fifo_bram #(
        .DATA_WIDTH(DBITS),
        .FIFO_DEPTH(DDEPTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .full(full),
        .empty(empty),
        .data_out(data_out)
    );

    // Clock Generation: 100MHz (10ns period)
    always #5 clk = ~clk;

    initial begin
        // 1. Initialize Inputs
        clk     = 0;
        rst_n   = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 8'd0;

        // 2. Apply and Release Reset
        #15;
        rst_n = 1; 
        #10;

        // 3. Write data sequentially until the FIFO fills up (Depth = 4)
        $display("[TIME %0t] --- Starting Writes ---", $time);
        
        // Write Item 1
        @(posedge clk);
        if (!full) begin wr_en = 1; data_in = 8'hAA; end
        // Write Item 2
        @(posedge clk);
        if (!full) begin wr_en = 1; data_in = 8'hBB; end
        // Write Item 3
        @(posedge clk);
        if (!full) begin wr_en = 1; data_in = 8'hCC; end
        // Write Item 4 (This should trigger the full flag right after)
        @(posedge clk);
        if (!full) begin wr_en = 1; data_in = 8'hDD; end
        
        // Turn off write enable on the next edge
        @(posedge clk);
        wr_en = 0;
        #1; // Brief settling step to print correct flag status
        if (full) $display("[TIME %0t] Success: FIFO is completely FULL!", $time);

        #20; // Idle for two cycles

        // 4. Read data sequentially until the FIFO empties
        $display("[TIME %0t] --- Starting Reads ---", $time);
        
        // Request Read 1
        @(posedge clk);
        if (!empty) rd_en = 1;
        
        // Loop to capture data and continue reading remaining elements
        repeat(3) begin
            @(posedge clk);
            #1; // Step over the edge to look at the newly updated stable data bus
            $display("[TIME %0t] Read out stable data: 8'h%h", $time, data_out);
        end
        
        // Final clock edge to finish reading the last item out
        @(posedge clk);
        rd_en = 0; // Turn off read enable
        #1;
        if (empty) $display("[TIME %0t] Success: FIFO is completely EMPTY!", $time);

        #30;
        $display("[TIME %0t] Simulation Finished.", $time);
        $finish;
    end

initial begin
  $dumpvars(0,synch_fifo_bram_tb);
  $dumpfile("tb.vcd");
  
end
  
endmodule
