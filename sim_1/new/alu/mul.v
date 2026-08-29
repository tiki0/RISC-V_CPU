module mul (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] out
);

  wire [31:0] sum [0:32];
  assign sum[0] = 32'b0;
  genvar i;
  generate
      for (i = 0; i < 32; i = i + 1) begin : mult


        wire [31:0] shifted;
        shift_l shift(
            .a(a),
            .n(i[4:0]),
            .out(shifted)
        );

        add32_r add(
            .a(sum[i]),
            .b(shifted & {32{b[i]}}),
            .cin(1'b0),
            .sum(sum[i+1]),
            .cout()
        );
    end

    assign out = sum[32];

  endgenerate
endmodule
