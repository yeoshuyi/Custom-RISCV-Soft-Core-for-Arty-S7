module ImmediateGenerator(
    input logic [31:0] instr,

    output logic [31:0] imm_gen
    );

    localparam [6:0]immediate = 7'b0010011,
                    load =      7'b0000011,
                    store =     7'b0100011,
                    branch =    7'b1100011,
                    LUI =       7'b0110111,
                    JAL =       7'b1101111,
                    JALR =      7'b1100111;

    wire [6:0] op_code = instr[6:0];

    always_comb begin
        case (op_code)
			immediate,
            JALR,
            load: imm_gen = {{20{instr[31]}}, instr[31:20]};
            store: imm_gen = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            branch: imm_gen = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            LUI: imm_gen = {instr[31:12], 12'b0};
            JAL: imm_gen = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            default: imm_gen = 32'b0;
		endcase
    end

endmodule