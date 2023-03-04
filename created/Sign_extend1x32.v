module Sign_extend1x32 (
    input wire data_1_bit,
    output wire[31:0] data_32_bit
);

assign data_32_bit = {{31{0'b1}}, data_1_bit};

endmodule