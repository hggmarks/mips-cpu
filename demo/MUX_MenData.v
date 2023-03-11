module MUX_MenData(
    input wire [2:0] sel,
    input wire[31:0] instruction,
    input wire[31:0] alu_out,
    input wire[31:0] result,
    output reg[31:0] saida
);

always @(*) begin
    case (sel)
        3'b000: saida = instruction;
        3'b001: saida = alu_out;
        3'b010: saida = result;
        3'b011: saida = 32'b00000000000000000000000011111101;
        3'b100: saida = 32'b00000000000000000000000011111110;
        3'b101: saida = 32'b00000000000000000000000011111111;
    endcase 
    end
endmodule