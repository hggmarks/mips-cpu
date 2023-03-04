module MUX_write_register(
    input wire[2:0] sel,
    input wire[31:0] instruction_1,
    input wire[31:0] instruction_2,
    input wire[31:0] instruction_3,
    output reg[31:0] saida
);

    always@(*) begin
        case(sel)
        3'b000: saida = instruction_2;
        3'b001: saida = instruction_1;
        3'b010: saida = instruction_3;
        3'b011: assign saida = 32'b00000000000000000000000000011111; // 31
        3'b100: assign saida = 32'b00000000000000000000000000011101; // 29
        endcase 
    end

endmodule