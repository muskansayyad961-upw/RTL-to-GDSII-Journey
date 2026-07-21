module fifo (
    input        wr_clk,
    input        rd_clk,
    input        wr_rst,
    input        rd_rst,
    input        wr_en,
    input        rd_en,
    input  [7:0] wr_data,
    output reg [7:0] rd_data,
    output reg       wr_full,
    output reg       rd_empty
);

    // 8-depth memory
    reg [7:0] mem [0:7];

    // 3-bit write and read pointers
    reg [2:0] wr_ptr = 0;
    reg [2:0] rd_ptr = 0;

    // Write logic
    always @(posedge wr_clk or posedge wr_rst) begin
        if (wr_rst) begin
            wr_ptr <= 3'd0;
        end
        else if (wr_en && !wr_full) begin
            mem[wr_ptr] <= wr_data;
            wr_ptr <= wr_ptr + 1'b1;
        end
    end

    // Read logic
    always @(posedge rd_clk or posedge rd_rst) begin
        if (rd_rst) begin
            rd_ptr <= 3'd0;
        end
        else if (rd_en && !rd_empty) begin
            rd_data <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1'b1;
        end
    end

    // Full and Empty flag logic
    always @(*) begin
        wr_full  = ((wr_ptr + 1) % 8 == rd_ptr);
        rd_empty = (wr_ptr == rd_ptr);
    end

endmodule
