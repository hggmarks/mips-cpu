module store_size_ss(
    input wire [1:0] sel,
    input wire[31:0] b,
    input wire[31:0] mdr,
    output reg[31:0] saida
);

    always @(*) begin
        case(sel)
        2'b10: saida <= {mdr[31:16], b[15:0]}; //sh -> halfworld
        2'b01: saida<= b; //sw -> tamanho normal
        2'b11: saida <= {mdr[31:8], b[7:0]};// sb -> byte mais valioso

        endcase
    end

endmodule