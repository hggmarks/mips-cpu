module MUX_SR_B(
    input wire [31:0] b,
    input wire [31:0] instruction,
    input wire [31:0] mdr,
    input wire [1:0] sel,
    output reg [4:0] saida
);

always@(*) begin
    case (sel)
        2'b00: saida = b;
        2'b01: saida = instruction [10:6];
	    2'b10: saida = mdr; 
        2'b11: saida = 32'b00000000000000000000000000010000;
    endcase
  end
endmodule