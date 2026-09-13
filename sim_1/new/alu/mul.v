module mul (
    input  [31:0] a,
    input  [31:0] b,
    output [31:0] out
);

  reg [31:0] tmp;
  genvar i;
  generate
    for (i = 0; i < 32; i = i + 1) 
    if (b[i]) 
      add32_r add (
          .a(a),
          .b(b),
          .cin(),
          .carry(),
          .sum()
      );
  endgenerate

endmodule
