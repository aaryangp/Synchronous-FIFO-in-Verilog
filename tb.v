`include "synch_fifo.v"
`timescale 1ns/1ps

module tb_synch_fifo;

    // DUT signals
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;

    wire full;
    wire empty;
    wire [7:0] data_out;

    // Instantiate DUT
    synch_fifo dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .full(full),
        .empty(empty),
        .data_out(data_out)
    );

    // -------------------------
    // Clock generation (10 ns)
    // -------------------------
    always #5 clk = ~clk;

    // -------------------------
    // Test sequence
    // -------------------------
    initial begin
        // Init
        clk     = 0;
        rst     = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in= 8'd0;

        // Apply reset
        #10;
        rst = 1;

        // -------------------------
        // WRITE 5 values
        // -------------------------
        repeat (5) begin
            @(posedge clk);
            wr_en   = 1;
            data_in = $random;
        end

        @(posedge clk);
        wr_en = 0;


        // -------------------------
        // READ 3 values
        // -------------------------
        repeat (5) begin
            @(posedge clk);
            rd_en = 1;
        end

        @(posedge clk);
        rd_en = 0;

        // Finish simulation
        #40;
        $finish;
    end

    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0,tb_synch_fifo);
    end

endmodule
