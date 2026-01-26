module ALU(
    input logic [31:0] data_in_A,
    input logic [31:0] data_in_B,
    input logic [3:0] alu_control,
    
    output logic [31:0] data_out,
    output logic carry,
    output logic zero
    );

    localparam op_ADD = 4'b0000; //A + B
    localparam op_SUB = 4'b1000; //A - B
    localparam op_SLL = 4'b0001; //SHIFT A LEFT LOGICAL BY B
    localparam op_SLT = 4'b0010; //SET IF LESS A < B
    localparam op_SLTU = 4'b0011; //SET IF LESS UNSIGNED A < B
    localparam op_XOR = 4'b0100; //A ^ B 
    localparam op_SRL = 4'b0101; //SHIFT A RIGHT LOGICAL BY B
    localparam op_SRA = 4'b1101; //SHIFT A RIGHT ARITHMETHIC BY B
    localparam op_OR = 4'b0110; //A OR B
    localparam op_AND = 4'b0111; //A AND B

    logic [32:0] arith_total;

    always_comb begin
        data_out = 32'b0;

        case(alu_control):
            op_ADD: begin
                arith_total = {1'b0, data_in_A} + {1'b0, data_in_B};
                data_out = arit_total[31:0];
            end
            op_SUB: begin
                arith_total = {1'b0, data_in_A} - {1'b0, data_in_B};
                data_out = arit_total[31:0];
            end
            op_SLL: data_out = data_in_A << data_in_B[4:0];
            op_SLT: data_out = ($signed(data_in_A) < $signed(data_in_B)) ? 32'h00000001 : 32'b0;
            op_SLTU: data_out = (data_in_A < data_in_B) ? 32'h00000001 : 32'b0;
            op_XOR: data_out = data_in_A ^ data_in_B;
            op_SRL: data_out = data_in_A >> data_in_B[4:0];
            op_SRA: data_out = $signed(data_in_A) >>> data_in_B[4:0];
            op_OR: data_out = data_in_A | data_in_B;
            op_AND: data_out = data_in_A & data_in_B;
            default: data_out = 32'b0;
        endcase
    end

    assign zero = (data_out == 32'b0);
    assign carry = arith_total[32];
endmodule