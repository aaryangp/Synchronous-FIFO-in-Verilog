module synch_fifo(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [7:0] data_in,
    output full,
    output empty,
    output reg [7:0] data_out
);

reg [7:0] memory [0:7];
reg [3:0] wr_ptr, rd_ptr;   // extra MSB
integer i;

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        for (i = 0; i < 8; i = i + 1)
            memory[i] <= 8'd0;

        wr_ptr   <= 4'd0;
        rd_ptr   <= 4'd0;
        data_out <= 8'd0;
    end
    else begin
        // WRITE
        if (wr_en) begin
            memory[wr_ptr[2:0]] <= data_in;
            wr_ptr <= wr_ptr + 1'b1;
        end

        // READ
        if (rd_en) begin
            data_out <= memory[rd_ptr[2:0]];
            rd_ptr <= rd_ptr + 1'b1;
        end
    end
end

assign empty = (wr_ptr == rd_ptr);

assign full  = (wr_ptr[3] != rd_ptr[3]) &&
               (wr_ptr[2:0] == rd_ptr[2:0]);

endmodule
