module sign_extend_8x32_pc(
    input wire [7:0] dataIn, // vem do pc
    output wire[31:0] dataOut // vai pro multiplexador que atualiza o pc
);

    assign dataOut = {{24{0'b1}}, dataIn};

endmodule