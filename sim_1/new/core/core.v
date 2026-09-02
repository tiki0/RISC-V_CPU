module core(
    input clk,
    input rst
);


    wire [4:0]  rs1;
    wire [4:0]  rs2;
    wire [4:0]  rd;
    wire [31:0] wdata;
    wire [31:0] rd1;
    wire [31:0] rd2;
    wire [3:0] alu_op;
    reg  [31:0] instr;
    wire [31:0] rdout;
    wire [31:0] wdin;
    wire        reg_write, mem_write;

    assign instr = rdout;

    registers regs(
        .clk(clk),
        .we(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wdata(wdata),
        .rd1(rd1),
        .rd2(rd2)
    );

    decoder decdr(
        .instr(instr),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .mem_write(mem_write)
    );


    opcode_wiring alu(
        .alu_op(alu_op),
        .a(rd1),
        .b(rd2),
        .out(wdata)
    );

    bram ram(
        .clk(clk),
        .we(1'b0),
        .addr(pc),
        .wdin(32'b0),
        .rdout(rdout)
    );

    reg [31:0] pc = 32'b0;
    always @(posedge clk) begin
        instr <= rdout;
        pc <= pc + 1;
    end

endmodule
