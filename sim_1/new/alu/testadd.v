module test();

    wire [31:0] a = 32'd53;
    wire [31:0] b = 32'd3041;
    wire [31:0] sum;

    add32_r add (
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(sum),
        .cout()
    );

    wire [31:0] c = 32'd12532;
    wire [31:0] d = 32'd91125;
    wire [31:0] sum2;

    add32_r add2 (
        .a(c),
        .b(d),
        .cin(1'b0),
        .sum(sum2),
        .cout()
    );

    initial begin
        #1;
        $display("a: %0d b: %0d sum: %0d", a,b,sum);
        $display("a: %0d b: %0d sum: %0d", c,d,sum2);
    end

endmodule
