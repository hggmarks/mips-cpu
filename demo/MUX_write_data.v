module MUX_write_data(
    input wire [2:0] sel,

    input wire[31:0] shift_reg,
    input wire[31:0] lo,
    input wire[31:0] hi,
    input wire[31:0] load_size,
    input wire[31:0] sign_extend,
    input wire[31:0] alu_out,
    output reg[31:0] saida
);

always @(*) begin
    case (sel)
        3'b000: saida = 32'b00000000000000000000000011100011;
        3'b001: saida = shift_reg;
        3'b010: saida = lo;
        3'b011: saida = hi;
        3'b100: saida = load_size;
        3'b101: saida = sign_extend;
        3'b110: saida = alu_out;
    endcase 
    end
endmodule