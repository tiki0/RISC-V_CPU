module bram(
    input clk, we,
    input [11:0] addr,
    input [31:0] wdin,
    output reg [31:0] rdout 

);

    reg [31:0] bram [0:4095];

    always @(posedge clk) begin
        if (we) begin
            bram[addr] <= wdin;
        end
        rdout <= bram[addr];
    end

endmodule


