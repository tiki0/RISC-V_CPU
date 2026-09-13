module test_decoder();


    input  [31:0] instr,
    output [4:0]  rs1,
    output [4:0]  rs2,
    output [4:0]  rd,
    output reg [3:0]  alu_op,
    output reg       reg_write,
    output reg       mem_write


    wire [31:0] instr [0:7];
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    reg  [3:0] alu_op;
    reg  mem_write;
    reg  reg_write;
    decoder decode(
        .instr(instr),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .alu_op(alu_op),
        .reg_write(reg_write),
        .mem_write(mem_write)
    );


endmodule
