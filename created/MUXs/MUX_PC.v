module PC(
    input wire [2:0] sel,
    input wire[31:0] MenData,
    input wire[31:0] result,
    input wire[31:0] alu_out,
    input wire[31:0] pc_atual,
    input wire[31:0] ls,
    input wire[31:0] epc,
    output reg[31:0] saida
);

always @(*) begin
    case (sel)
        3'b000: saida = MenData;
        3'b001: saida = result;
        3'b010: saida = alu_out;
        3'b011: assign saida = pc_atual;
        3'b100: assign saida = ls;
        3'b101: assign saida = epc;
    endcase 
    end
endmodule