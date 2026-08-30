module decoder (
    input [31:0] instr,
    input clk,
    output [31:0] out
);

    wire [6:0] opcode   = instr[6:0];
    wire [4:0] rd       = instr[11:7];
    wire [2:0] funct3   = instr[14:12];
    wire [4:0] rs1      = instr[19:15];
    wire [4:0] rs2      = instr[24:20];
    wire [6:0] funct7   = instr[31:25];

    always @(posedge clk) begin
        case (opcode)
            7'b0110011: begin // R-Type
                case (funct3)
                    3'b000: begin // add or sub
                        case (funct7)
                            7'b0000000: begin // add
                            end //add
                            7'b0100000: begin // sub
                        end //sub
                        default: begin
                        end
                        endcase
                    end // add or sub
                    3'b001: begin // sll
                    end // sll
                    3'b010: begin // slt
                    end // slt
                    3'b011: begin // sltu
                    end // sltu
                    3'b100: begin // xor
                    end // xor
                    3'b101: begin // srl or sra
                        case (funct7)
                            7'b0000000: begin // srl
                            end //srl
                            7'b0100000: begin // sra
                            end // sra
                            default: begin
                            end
                        endcase
                    end // srl or sra
                    3'b110: begin // or 
                    end // or
                    3'b111: begin // and
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
