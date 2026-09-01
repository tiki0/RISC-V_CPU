module opcode_wiring(
    input [3:0] alu_op,
    input [31:0] a,
    input [31:0] b,
    output [31:0] out
);

    reg [31:0] add_out;
    add32_r add(
        .a(a),
        .b(b),
        .cin(),
        .sum(add_out),
        .cout()
    );

    reg [31:0] sub_out;
    add32_r sub(
        .a(~a),
        .b(b),
        .cin(1'b1),
        .sum(sub_out),
        .cout()
    );

    reg [31:0] sll_out;
    shift_l sll(
        .a(a),
        .n(b),
        .out(sll_out)
    );

    reg [31:0] srl_out;
    shift_r srl(
        .a(a),
        .n(b),
        .is_s(1'b0),
        .out(srl_out)
    );

    reg [31:0] sra_out;
    shift_r sra(
        .a(a),
        .n(b),
        .is_s(1'b1),
        .out(sra_out)
    );

    reg [31:0] slt_out = {32'b0};
    lessthan slt (
        .a(a),
        .b(b),
        .signd(1'b1),
        .lt(slt_out[0])
    );

    reg [31:0] sltu_out = {32'b0};
    lessthan sltu (
        .a(a),
        .b(b),
        .signd(1'b0),
        .lt(sltu_out[0])
    );

    always @(*) begin
        case (alu_op) 
            4'b0000: begin // add
                out = add_out;
            end
            4'b0001: begin //sub
                out = sub_out;
            end
            4'b0010: begin // shift left
                out = sll_out;
            end
            4'b0011: begin //  set less than
                out = slt_out;
            end
            4'b0100: begin // set less than unsigned
                out = sltu_out;
            end
            4'b0101: begin // xor
                out = a ^ b;
            end
            4'b0110: begin // shift right logical
                out = srl_out;
            end
            4'b0111: begin // shift left arithmetic
                out = sra_out;
            end
            4'b1000: begin // or
                out = a | b;
            end
            4'b1001: begin // and
                out = a & b;
            end
            4'b1010: begin
            end
            4'b1011: begin
            end
            4'b1100: begin
            end
            4'b1101: begin
            end
            4'b1110: begin
            end
            4'b1111: begin
            end
            default: begin
            end
        endcase
    end

endmodule
