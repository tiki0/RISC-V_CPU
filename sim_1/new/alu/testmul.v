module main();
    wire [31:0]a = 32'd30;
    wire [31:0]b = 32'd9;

    wire [31:0]out;

    mul test (
        .a(a),
        .b(b),
        .out(out)
    );

    initial begin
        #1;
        $display("a: %0d b: %0d out: %0d", a, b, out);
    end
endmodule
