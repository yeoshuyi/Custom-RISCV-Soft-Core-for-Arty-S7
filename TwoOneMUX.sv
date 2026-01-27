module TwoOneMUX(
    input logic [31:0] data_in_A,
    input logic [31:0] data_in_B,
    input logic sel,

    output logic [31:0] data_out
    );

    always_comb data_out = sel ? data_in_B : data_in_A;
endmodule