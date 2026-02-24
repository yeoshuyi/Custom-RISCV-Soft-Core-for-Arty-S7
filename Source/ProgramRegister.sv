module ProgramRegister(
    input logic clk,
    input logic [31:0] instr,
    input logic [31:0] write_back,
    input logic write_en,

    output logic [31:0] data_out_A,
    output logic [31:0] data_out_B
    );
    
    (* max_fanout = 30 *)
    logic [31:0] memory [31:0];
    wire [4:0] rs1 = instr[19:15];
    wire [4:0] rs2 = instr[24:20];
    wire [4:0] rd  = instr[11:7];

    assign data_out_A = (rs1 == 5'b0) ? 32'b0 : memory[rs1];
    assign data_out_B = (rs2 == 5'b0) ? 32'b0 : memory[rs2];

    always_ff @(posedge clk) begin
        if(write_en && (rd != 5'b0)) begin
            memory[rd] <= write_back;
        end
    end

    //For testbench init
    initial begin
        for (int i = 0; i < 32; i++) memory[i] = 32'b0;
    end

endmodule