module DataMemory(
    input logic clk,
    input logic [31:0]addr,
    input logic write_en,
    input logic [31:0] write_data,
    input logic mem_read,

    output logic [31:0] data_out
    );

    (* ram_style = "block" *)
    logic [31:0] memory [1023:0];
    
    always_ff @(posedge clk) begin
        if(mem_read) data_out <= memory[addr[11:2]];
        if(write_en) memory[addr[11:2]] <= write_data;
    end
    
    initial begin
        for (int i = 0; i < 64; i++) begin
            memory[i] = 32'b0;
        end

        // Hardcode some test data
        memory[0] = 32'd100;      // Value 100 at address 0x0
        memory[1] = 32'hDEADBEEF; // Hex value at address 0x4
        memory[2] = 32'hCAFEBABE; // Hex value at address 0x8
        memory[10] = 32'd50;      // Value 50 at address 0x28 (10 * 4)
    end
endmodule