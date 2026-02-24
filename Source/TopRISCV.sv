`timescale 1ns / 1ps

module TopRISCV(
    input logic reset,
    input logic ddr_clock,
    
    output logic [31:0] write_back_toPR
    );
    
    wire clk;
    
    wire [31:0] jump_addr;
    wire jump_enable;
    wire [31:0] pc_address;
    
    wire [31:0] instr;
    
    wire reg_write;
    wire mem_write;
    wire mem_read;
    wire jump;
    wire branch;
    wire [3:0] alu_control;
    wire alu_src;
    wire result_sel;
    
    //wire write_back_toPR;
    wire [31:0] rd1;
    wire [31:0] rd2;
    
    wire [31:0] imm_gen;
    
    wire [31:0] alu_rd2;
    wire [31:0] alu_out;
    wire zero;
    wire carry;
    
    wire [31:0] mem_out;
    
    ClkGen ClkGen_i
    (
        .clk_out1_0(clk),
        .ddr_clock(ddr_clock),
        .reset(reset)
    );
    
    ProgramCounter ProgramCounterModule
    (
        .reset(reset),
        .clk(clk),
        .jump(imm_gen),
        .jump_en(jump_enable),
        .address(pc_address)
    );
    
    InstructionMemory InstructionMemoryModule
    (
        .clk(clk),
        .en_A(1'b1),
        .addr_A(pc_address),
        .en_B(1'b0),
        .write_en_B(1'b0),
        .data_out_A(instr)
    );
    
    ControllerRISC ControllerRISCModule
    (
        .instr(instr),
        .reg_write(reg_write),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .branch(branch),
        .jump(jump),
        .alu_control(alu_control),
        .alu_src(alu_src),
        .result_sel(result_sel)
    );
    
    ProgramRegister ProgramRegisterModule
    (
        .clk(clk),
        .instr(instr),
        .write_back(write_back_toPR),
        .write_en(reg_write),
        .data_out_A(rd1),
        .data_out_B(rd2)
    );
    
    ImmediateGenerator ImmediateGeneratorModule
    (
        .instr(instr),
        .imm_gen(imm_gen)
    );
    
    TwoOneMUX ALUSelectModule
    (
        .data_in_A(rd2),
        .data_in_B(imm_gen),
        .sel(alu_src),
        .data_out(alu_rd2)
    );
    
    ALU ALUModule
    (
        .data_in_A(rd1),
        .data_in_B(alu_rd2),
        .alu_control(alu_control),
        .data_out(alu_out),
        .zero(zero),
        .carry(carry)
    );

    DataMemory DataMemoryModule
    (
        .clk(clk),
        .addr(alu_out),
        .write_en(mem_write),
        .mem_read(mem_read),
        .write_data(rd2),
        .data_out(mem_out)
    );
    
    TwoOneMUX MemorySelectModule
    (
        .data_in_A(alu_out),
        .data_in_B(mem_out),
        .sel(result_sel),
        .data_out(write_back_toPR)
    );
    
    assign jump_enable = jump | (branch & zero);
endmodule   