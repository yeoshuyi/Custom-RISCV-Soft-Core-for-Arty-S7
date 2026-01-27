module ControllerRISC(
    input logic [31:0] instr,

    output logic reg_write,
    output logic mem_write,
    output logic mem_read,
    output logic branch,
    output logic jump,
    output logic [3:0] alu_control,
    output logic alu_src,
    output logic result_sel
    );

    localparam [6:0]arithmetic = 7'b0110011,
                    immediate =  7'b0010011,
                    load =       7'b0000011,
                    store =      7'b0100011,
                    op_branch =     7'b1100011,
                    LUI =        7'b0110111,
                    JAL =        7'b1101111,
                    JALR =       7'b1100111;

    wire [6:0] op_code = instr[6:0];
    wire [3:0] funct3 = instr[14:12];
    wire funct7bit = instr[30];

    always_comb begin
        reg_write   = 1'b0;
        mem_write   = 1'b0;
        mem_read    = 1'b0;
        alu_src     = 1'b0;
        alu_control = 4'b0;
        branch      = 1'b0;
        jump        = 1'b0;
        result_sel  = 1'b0;

        case(op_code)
            arithmetic: begin
                reg_write = 1'b1;
                alu_src = 1'b0;
                alu_control = {funct7bit, funct3};
            end
            immediate: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                if (funct3 == 3'b101 || funct3 == 3'b001)
                    alu_control = {funct7bit, funct3};
                else
                    alu_control = {1'b0, funct3};
            end

            load: begin
                reg_write   = 1'b1;
                alu_src     = 1'b1;
                mem_read    = 1'b1;
                result_sel  = 1'b1;
                alu_control = 4'b0000;
            end

            store: begin
                mem_write = 1'b1;
                alu_src = 1'b1;
                alu_control = 4'b0000;
            end

            op_branch: begin
                branch = 1'b1;
                alu_src = 1'b0;
                alu_control = 4'b0000;
            end

            LUI: begin
                reg_write = 1'b1;
                alu_src = 1'b1;
                result_sel = 1'b0;
                alu_control = 4'b1111;
            end

            JAL: begin
                reg_write = 1'b1;
                jump = 1'b1;
                result_sel = 1'b0;
            end

            JALR: begin
                reg_write = 1'b1;
                jump = 1'b1;
                alu_src = 1'b1;
                alu_control 4'b0000;
            end
        endcase
    end
endmodule