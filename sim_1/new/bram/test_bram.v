`timescale 1ns/1ps 
module test();
    

    reg [11:0] addr;
    reg [31:0] wdin;
    wire [31:0] rdout;
    reg clk = 0;
    reg we = 0;
    bram init(
        .addr(addr),
        .clk(clk),
        .we(we),
        .wdin(wdin),
        .rdout(rdout)
    );
    always #1 clk = ~clk;


    reg [3:0] state = 4'b0000;
    reg [11:0] addrs [0:3];
    initial begin
        addrs[0] = 12'b0;
        addrs[1] = 12'b1;
        addrs[2] = 12'b10;
        addrs[3] = 12'b11;
    end

    reg [31:0] tmp1,tmp2,tmp3,tmp4;
    always @(posedge clk) begin
        case (state)
            4'b1110: begin 
                addr <= addrs[0]; 
                state <= 4'b0000; 
            end
            4'b0000: begin addr <= addrs[0];
                we <= 1'b1;
                wdin <= 32'b1;
                state <= 4'b0001;
            end

            4'b0001: begin addr <= addrs[1];
                we <= 1'b1;
                wdin <= 32'b10;
                state <= 4'b0010;
            end

            4'b0010: begin addr <= addrs[2];
                we <= 1'b1;
                wdin <= 32'b11;
                state <= 4'b0011;
            end

            4'b0011: begin addr <= addrs[3];
                we <= 1'b1;
                wdin <= 32'b100;
                state <= 4'b1111;
            end
            4'b1111: begin we <= 0; addr <= addrs[0]; state <= 4'b0100; end
            4'b0100: begin 
                addr <= addrs[1]; 
                state <= 4'b0101;
            end            // wait — rdout not valid yet
            4'b0101: begin addr <= addrs[2];
                tmp1 = rdout;
                state <= 4'b0110;
            end
            4'b0110: begin addr <= addrs[3];
                tmp2 = rdout;
                state <= 4'b0111;
            end
            4'b0111: begin
                tmp3 = rdout;
                state <= 4'b1000;
            end
            4'b1000: begin
                tmp4 = rdout; 
            end
        endcase
    end

    initial begin
        #40;
        $display("mem read1: %b", tmp1);
        $display("mem read2: %b", tmp2);
        $display("mem read2: %b", tmp3);
        $display("mem read3: %b", tmp4);
        $finish;
    end

endmodule
