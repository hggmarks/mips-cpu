module shift_left_2_alu(
    input wire[31:0] data_in, // apos sign 16-32
    output wire[31:0] data_alu_b // vai pra segunda entrada da alu
);

    assign data_alu_b = data_in << 2; // desloca 2 bits para a esquerda

endmodule