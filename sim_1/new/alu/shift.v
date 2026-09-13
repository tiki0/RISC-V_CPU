module shift_r (
    input  [31:0] a,
    input  [ 4:0] n,
    input is_s,
    output [31:0] out
);

    wire [31:0] s0,s1,s2,s3,s4;
    wire s_neg = is_s && a[31];

    assign s0 = n[0] ? { {1{s_neg}}, a[31:1]} : a;
    assign s1 = n[1] ? { {2{s_neg}}, s0[31:2]} : s0;
    assign s2 = n[2] ? { {4{s_neg}}, s1[31:4]} : s1;
    assign s3 = n[3] ? { {8{s_neg}}, s2[31:8]} : s2;
    assign s4 = n[4] ? { {16{s_neg}}, s3[31:16]} : s3;

    assign out = s4;

endmodule


module shift_l (
    input  [31:0] a,
    input  [ 4:0] n,
    output [31:0] out
);

    wire [31:0] s0,s1,s2,s3,s4;

    assign s0 = n[0] ? {a[30:0], 1'b0} : a;
    assign s1 = n[1] ? {s0[29:0], 2'b0} : s0;
    assign s2 = n[2] ? {s1[27:0], 4'b0} : s1;
    assign s3 = n[3] ? {s2[23:0], 8'b0} : s2;
    assign s4 = n[4] ? {s3[15:0], 16'b0} : s3;

    assign out = s4;

endmodule
