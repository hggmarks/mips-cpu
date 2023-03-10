module load_size_ls(
    input wire [1:0] sel,
    input wire [31:0] mdr,
    output reg [31:0] saida
);

always @(*) begin
        case (sel)
            2'b01: saida <= mdr; // lw -> tamanho normal
            2'b10: saida <= {16'd0, mdr[15:0]}; // lh -> halfworld
            2'b11: saida <= {24'd0, mdr[7:0]};// lb -> byte mais valioso
        endcase
    end

endmodule