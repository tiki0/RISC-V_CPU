module testcase (

);

wire [31:0] a = {8'b0, 3'b0,3'b0,2'b0,8'b0,8'b100};
wire [31:0] b = {8'b0, 3'b0,3'b0,2'b0,4'b0, 4'b1,8'b1};
wire [31:0] c = {8'b1, 3'b1,3'b0,2'b0,8'b0,8'b0};
wire [31:0] d = {8'b0, 3'b0,3'b1,2'b0,8'b1,8'b0};

wire [4:0] s0 = 5'b00001;
wire [4:0] s1 = 5'b00010;
wire [4:0] s2 = 5'b00101;
wire [4:0] s3 = 5'b01101;

wire [31:0] out0;
wire [31:0] out1;
wire [31:0] out2;
wire [31:0] out3;

shift_l shift0 (
    .a(a),
    .n(s0),
    .out(out0)
);
shift_l shift1 (
    .a(b),
    .n(s1),
    .out(out1)
);
shift_l shift2 (
    .a(c),
    .n(s2),
    .out(out2)
);
shift_l shift3 (
    .a(d),
    .n(s3),
    .out(out3)
);


initial begin
    #1;
    $display("in: %b shift: %b out: %b",a,s0,out0);
    $display("in: %b shift: %b out: %b",b,s1,out1);
    $display("in: %b shift: %b out: %b",c,s2,out2);
    $display("in: %b shift: %b out: %b",d,s3,out3);
end

endmodule

