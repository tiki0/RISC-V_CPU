module core(
    input clk,
    input rst
);


    wire [4:0]  rs1;        // Read register 1 addr
    wire [4:0]  rs2;        // Read register 2 addr
    wire [4:0]  rd;         // Register to write to
    wire [31:0] wdata;      // Data to write to reg
    wire [31:0] rd1;        // Read reg 1 out
    wire [31:0] rd2;        // Read reg 2 out
    wire [3:0]  alu_op;     // Alu op_code from decoder
    reg  [31:0] instr;      // Raw instruction into decoder
    wire [31:0] rdout;      // Ram read out
    //wire [31:0] ram_addr;   // Ram data write addr
    wire [31:0] wdin;       // Ram data write in
    wire        reg_write;  // Write to reg flag
    wire        mem_write;  // Write to ram flag
    wire        mem_read;   // Read ram flag
    wire [3:0]  byte_en;    // Bytes of ram to write to in word block
    wire        ext;        // Extend with 0 or 1, for I type instructions
    wire [31:0] imm;        // Immediate value for I type instructions
    wire        alu_src;    // Tell ALU to use immediate or reg flag
    wire        jalr;       // JALR instruction, need flag to change PC
    

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
        .mem_write(mem_write),
        .mem_read(mem_read),
        .ext(ext),
        .byte_en(byte_en),
        .jalr(jalr)
    );


    opcode_wiring alu(
        .alu_op(alu_op),
        .a(rd1),
        .b(rd2),
        .out(wdata)
    );

    bram instruction_ram(
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
