module MUX_SR_A(
    input wire [31:0] instruction,
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [1:0] sel,
    output reg [31:0] saida
    );
  
  always@(*) begin
    case (sel)
        2'b00: saida = instruction;
        2'b01: saida = a; 
	    2'b10: saida = b; 
    endcase
  end
endmodule