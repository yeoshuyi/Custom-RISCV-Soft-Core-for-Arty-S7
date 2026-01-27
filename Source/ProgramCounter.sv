module ProgramCounter(
    input logic reset,
    input logic clk,
    input logic [31:0] jump,
    input logic jump_en,

    output logic [31:0] address
    );

    logic [31:0] next_address;

    always_ff @(posedge clk or posedge reset) begin
        if(reset)  address <= 32'b0
        else address <= next_address;
    end

    always_comb begin
        next_address = jump_en ? jump : address + 32'd4;
    end
endmodule