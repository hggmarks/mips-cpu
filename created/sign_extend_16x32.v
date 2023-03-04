module sign_extend_16x32(
    input wire[15:0] dataIn, // vem do instruction
    output wire[31:0] dataOut // vai pra segunda entrada da alu
);

    assign dataOut = (dataIn[15]) ? {{16{1'b1}}, dataIn} : {{16{0'b1}}, dataIn}; // vai ver se o numero é positivo ou negativo e dependendo do resultado adiciona 0s ou 1s ate completar 32 bits

endmodule