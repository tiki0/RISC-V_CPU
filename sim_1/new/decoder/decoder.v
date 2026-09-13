module decoder (
    input  [31:0]       instr,      // Raw instruction machine code
    output [4:0]        rs1,        // Reg 1
    output [4:0]        rs2,        // Reg 2
    output [4:0]        rd,         // Reg written to
    output reg [3:0]    alu_op,     // Alu operation (if any)
    output reg          reg_write,  // Reg write flag
    output reg          mem_write,  // Mem write flag
    output [31:0]       imm,        // For immediate ops
    output              alu_src,    // Flag to fetch from imm or reg
    output              mem_read,   // Read from memory
    output [3:0]        byte_en,
    output              ext,        // Extend with 0 or sign
    output              load,       // Load group flag
    output              jalr        // Special instruction needs flag
);

    assign      rd      = instr[11:7];
    assign      rs1     = instr[19:15];
    assign      rs2     = instr[24:20];
    wire [6:0]  opcode  = instr[6:0];
    wire [2:0]  funct3  = instr[14:12];
    wire [6:0]  funct7  = instr[31:25];
    assign      imm     = {{20{instr[31]}}, instr[31:20]};
    assign      jalr    = opcode == 7'b1100111; // Needy instruction eh?

    

    always @(*) begin
        case (opcode)
            7'b0110011: begin // R-Type
                alu_src = 1'b0;
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
            end // R- Type

            7'b0010011: begin // I-Type Group 1 & 2
                alu_src = 1;
                case (funct3)
                    3'b000: begin // addi
                        alu_op = 4'b0000;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // addi
                    3'b001: begin // slli
                        alu_op = 4'b0010;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // /slli
                    3'b010: begin // slti
                        alu_op = 4'b0011;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end //slti
                    3'b011: begin // sltiu
                        alu_op = 4'b0100;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // sltiu
                    3'b100: begin // xori
                        alu_op = 4'b0101;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // xori
                    3'b101: begin // srli or srai
                    case (funct7)
                        7'b0000000: begin //srli
                            alu_op = 4'b0110;
                            reg_write = 1'b1;
                            mem_write = 1'b0;
                        end //srli
                        7'b0100000: begin //srai
                            alu_op = 4'b0111;
                            reg_write = 1'b1;
                            mem_write = 1'b0;
                        end //srai
                        default: begin
                        end
                    endcase
                    end //srli or srai
                    3'b110: begin // ori
                        alu_op = 4'b1000;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // ori
                    3'b111: begin // andi
                        alu_op = 4'b1001;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end // andi
                    default: begin
                    end
                endcase
            end // I-Type Group 1 & 2
            
            7'b0000011: begin // I-Type Group 3
                alu_src = 1;
                case (funct3)
                    3'b000: begin // lb
                        alu_op = 4'b0000;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                        mem_read = 1'b1;
                        byte_en = 4'b0001;
                        ext = 1'b1;
                    end // lb
                    3'b001: begin // lh
                        alu_op = 4'b0000;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                        mem_read = 1'b1;
                        byte_en = 4'b0011;
                        ext = 1'b1;
                    end // lh
                    3'b010: begin // lw
                        alu_op = 4'b0000;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                        mem_read = 1'b1;
                        byte_en = 4'b1111;
                        ext = 1'b1;
                    end // lw
                    3'b100: begin // lbu
                        alu_op = 4'b0000;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                        mem_read = 1'b1;
                        byte_en = 4'b0001;
                        ext = 1'b0;
                    end // lbu
                    3'b101: begin // lhu
                        alu_op = 4'b0000;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                        mem_read = 1'b1;
                        byte_en = 4'b0011;
                        ext = 1'b0;
                    end // lhu
                    default: begin
                    end
                endcase
            end // I-Type Group 3

            7'b1100111: begin // I-Type Group 4 JALR
                alu_src = 1;
                case (funct3)
                    3'b000: begin //jalr
                        alu_op = 4'b0000;
                        reg_write = 1'b1;
                        mem_write = 1'b0;
                    end //jalr
                    default: begin
                    end
                endcase
            end // I-Type Group 4 JALR

            default: begin
            end
        endcase
    end

endmodule
