module sign_extend_8x32_MenData(
    input wire [7:0] dataIn, // vem do MenData
    output wire[31:0] dataOut // vai pro multiplexador que atualiza o pc
);

    assign dataOut = {{24{0'b1}}, dataIn};

endmodule