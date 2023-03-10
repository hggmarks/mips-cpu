module MUX_ALUSrc_B(
    input wire [31:0] b,
    input wire [31:0] sign_extend,
    input wire [31:0] sign_left, // branch
    input wire [1:0] sel,
    output reg [31:0] saida

    );
  
  always@(*) begin
    case (sel)
        2'b00: saida = b;
        2'b01: saida = 32'd4;
	      2'b10: saida = sign_extend; 
	      2'b11: saida = sign_left;
    endcase
  end
endmodule
