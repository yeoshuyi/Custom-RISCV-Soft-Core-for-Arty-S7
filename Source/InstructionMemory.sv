module InstructionMemory(
    input logic clk,
    input logic en_A,
    input logic [31:0] addr_A,
    input logic en_B,
    input logic write_en_B,
    input logic [31:0] addr_B,
    input logic [31:0] write_data_B,

    output logic [31:0] data_out_A
    );

    (* ram_style = "block" *)
    logic [31:0] memory [1023:0];
    
    //Port A read-only
    always_ff @(posedge clk) begin
        if(en_A) data_out_A <= memory[addr_A[11:2]];
    end

    //Port B write-only
    always_ff @(posedge clk) begin
        if(en_B) begin
            if(write_en_B) memory[addr_B[9:0]] <= write_data_B;
        end
    end

//    initial begin
//        $readmemh("program_code.mem", memory);
//    end

//Test
    initial begin
        memory[0] = 32'h00500113; // addi x2, x0, 5  (x2 = 5)
        memory[1] = 32'h00700193; // addi x3, x0, 7  (x3 = 7)
        memory[2] = 32'h00310233; // add  x4, x2, x3 (x4 = 12)
        memory[3] = 32'h0000006F; // jal  x0, 0      (Infinite loop)
    end

endmodule
