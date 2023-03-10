module MUX_write_register(
    input wire[2:0] sel,
    input wire[4:0] instruction_1,
    input wire[4:0] instruction_2,
    input wire[4:0] instruction_3,
    output reg[4:0] saida
);

    always@(*) begin
        case(sel)
            3'b000: saida = instruction_2;
            3'b001: saida = instruction_1;
            3'b010: saida = instruction_3;
            3'b011: saida = 5'b11111; // 31
            3'b100: saida = 5'b11101; // 29
        endcase 
    end

endmodule