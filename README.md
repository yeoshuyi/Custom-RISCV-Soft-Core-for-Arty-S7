# Custom RISCV (RV32I) Soft Core for Arty S7 FPGA

## Specifications
 - Development Board: Arty S7-25
 - FPGA: Spartan-7
 - Architecture: RISC-V
 - Standard: RV32I
 - RTL Language: SystemVerilog
 - Clock Speed: 50MHz / 100MHz (Target)

## Current Status
| Component | RTL Code (SysVerilog) | Testbench | Hardware Implemented |
| -- | -- | -- | -- |
| Program Counter | DONE | WIP | WIP |
| Instruction Mem | WIP | WIP | WIP |
| Controller / Decoder | WIP | WIP | WIP |
| Program Register | WIP | WIP | WIP |
| Immediate Generator | DONE | WIP | WIP |
| Arithmetic Logic Unit | DONE | WIP | WIP |
| Data Memory | WIP | WIP | WIP |
| TOP | WIP | WIP | WIP |

## Description
### TOP Module
>The rough architecture of the CPU is shown below.

![Architecture](./Pictures/RISCV_Sketch.png)
### Program Counter
The Program Counter either increments by 4 with each CLK cycle, or jumps to a specific address with J-type operations.
```systemverilog
always_comb begin
    next_address = jump_en ? jump : address + 32'd4;
end
```
### Instruction Memory
> WIPb
### Controller and Decoder
> WIP
### Program Register
> WIP
### Immediate Generator
The Immediate Generator produces a [31:0] result used for other calculations based on the opcode and corresponding imm instructions as shown below. List of instructions can be found at: https://msyksphinz-self.github.io/riscv-isadoc/
```systemverilog
immediate,
JALR,
load: imm_gen = {{20{instr[31]}}, instr[31:20]};
store: imm_gen = {{20{instr[31]}}, instr[31:25], instr[11:7]};
branch: imm_gen = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
LUI: imm_gen = {instr[31:12], 12'b0};
JAL: imm_gen = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
default: imm_gen = 32'b0;
```
### Arithmetic Logic Unit
The ALU uses a simple combinational circuit that executes based on the op_code produced by the controller. Basic operations include the following:
- ADD Sums A and B
- SUB Subtracts B from A
- SLL Shifts A left by B
- SLT Sets if A is less than B
- XOR Produces A ^ B
- SRL Shifts A right by B, inserting 1'b0
- SRA Shifts A right by B, inserting MSB of A
- OR Produces A + B
- AND Produces A.B
```systemverilog
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
```
### Data Memory
> WIP