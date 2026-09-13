module bram(
    input clk,      we,
    input [11:0]    addr,
    input [31:0]    wdin,
    input [3:0]     byte_en,
    output reg [31:0] rdout 

);

    reg [31:0] bram [0:4095];

    always @(posedge clk) begin
        if (we) begin
            bram[addr] <= wdin;
        end
        if (byte_en[0]) bram[addr][7:0]   <= wdin[7:0];
        if (byte_en[1]) bram[addr][15:8]  <= wdin[15:8];
        if (byte_en[2]) bram[addr][23:16] <= wdin[23:16];
        if (byte_en[3]) bram[addr][31:24] <= wdin[31:24];
        rdout <= bram[addr];
    end

endmodule


