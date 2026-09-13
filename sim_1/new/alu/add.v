module fadd (
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);
  assign sum  = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module add32_r (
    input [31:0] a,
    input [31:0] b,
    input cin,
    output sum[31:0],
    output cout
);
  wire [31:0] carry;
  fadd init (
      .a(a[0]),
      .b(b[0]),
      .cin(cin),
      .cout(carry[0]),
      .sum(sum[0])
  );
  genvar i;
  generate
    for (i = 1; i < 32; i = i + 1) begin : g_add
      fadd init (
          .a(a[i]),
          .b(b[i]),
          .cin(carry[i-1]),
          .cout(carry[i]),
          .sum(sum[i])
      );
    end
  endgenerate
  assign cout = carry[31];
endmodule


