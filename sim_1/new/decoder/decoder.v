module decoder (
    input  [31:0] instr,
    output [4:0]  rs1,
    output [4:0]  rs2,
    output [4:0]  rd,
    output reg [3:0]  alu_op,
    output reg       reg_write,
    output reg       mem_write
);

    assign      rd      = instr[11:7];
    assign      rs1     = instr[19:15];
    assign      rs2     = instr[24:20];
    wire [6:0] opcode   = instr[6:0];
    wire [2:0] funct3   = instr[14:12];
    wire [6:0] funct7   = instr[31:25];


    always @(*) begin
        case (opcode)
            7'b0110011: begin // R-Type
                case (funct3)
                    3'b000: begin // add or sub
                        case (funct7)
                            7'b0000000: begin // add
                                alu_op = 4'b0000;
                                reg_write = 1'b1;
                                mem_write = 1'b0;
                            end //add
                            7'b0100000: begin // sub
                                alu_op = 4'b0001;
                                reg_write = 1'b1;
                                mem_write = 1'b0;
                        end //sub
                        default: begin
                        end
                        endcase
                    end // add or sub
                    3'b001: begin // sll
                        alu_op = 4'b0010;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // sll
                    3'b010: begin // slt
                        alu_op = 4'b0011;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // slt
                    3'b011: begin // sltu
                        alu_op = 4'b0100;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // sltu
                    3'b100: begin // xor
                        alu_op = 4'b0101;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // xor
                    3'b101: begin // srl or sra
                        case (funct7)
                            7'b0000000: begin // srl   
                                alu_op = 4'b0110;
                                reg_write = 1'b1;
                                mem_write = 1'b0;
                            end //srl
                            7'b0100000: begin // sra
                                alu_op = 4'b0111;
                                reg_write = 1'b1;
                                mem_write = 1'b0;
                            end // sra
                            default: begin
                            end
                        endcase
                    end // srl or sra
                    3'b110: begin // or
                        alu_op = 4'b1000;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // or
                    3'b111: begin // and
                        alu_op = 4'b1001;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // and
                    default: begin
                    end
                endcase
            end
            // more opcodes
            default: begin
            end
        endcase // R-Type
    end

endmodule
