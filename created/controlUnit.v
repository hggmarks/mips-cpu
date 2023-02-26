module control_unit (
    input wire clk, rst, overflow, [5:0] opcode, funct,
    output reg PCWrite,
    output reg memRW, //memRead and memWrite
    output reg IRWrite,
    output reg RegWrite,
    output reg [2:0] aluOP,
    output reg [2:0] muxIord,
    output reg [1:0] muxAluSrcA,
    output reg [2:0] muxAluSrcB,
    output reg [1:0] muxRegDst,
    output reg [2:0] muxMemToReg,


);
    

endmodule

