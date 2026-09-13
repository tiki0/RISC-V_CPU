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


    always @(*) begin
        case (alu_op) 
            4'b0000: begin
                out = add_out;
            end
            4'b0001: begin
                out = sub_out;
            end
            4'b0010: begin
                out = sll_out;
            end
            4'b0011: begin
            end
            4'b0100: begin
                out = a ^ b;
            end
            4'b0101: begin
            end
            4'b0110: begin
            end
            4'b0111: begin
            end
            4'b1000: begin
            end
            4'b1001: begin
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
