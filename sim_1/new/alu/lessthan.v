module lessthan(
    input [31:0] a,
    input [31:0] b,
    input signd,
    output reg lt
);

    wire [31:0] anew = { a[31] ^ signd, a[30:0]};
    wire [31:0] bnew = { b[31] ^ signd, b[30:0]};

    integer i;
    always @(*) begin
        lt = 1'b0;
        for (i = 0; i < 32; i = i + 1) begin
            if ( anew[i] != bnew[i] )
                lt = ~anew[i];
        end
    end
endmodule
