module mult(
    input clk,
    input signed[31:0]multiplicando,
    input signed[31:0]multiplicador,
    input reset,
    output reg signed [31:0] mflo,
    output reg signed [31:0] mfhi,
    input mult_init
);

integer count;
reg signed [63:0] produto;
reg Qadicional;
reg signed [64:0]superVariavel;
reg signed [31:0] M;
reg signed [31:0] Q;

always @(posedge clk or negedge reset) begin
    if (reset == 1) begin
            produto = 64'd0;
            count = 0;
            Qadicional = 0;
             M = 0;
             Q = 0;
      end
 
    else begin
        if (mult_init == 1) begin
            produto = 0;
            count = 0;
            Qadicional = 0;
            M = multiplicando;
            Q = multiplicador;
        end

        if ({Q[0], Qadicional} == 2'b10) begin
                produto = produto - M;
        end

        else if ({Q[0], Qadicional} == 2'b01) begin
            produto = produto + M;
        end

        superVariavel = {produto, Q, Qadicional} >> 1;
        produto = superVariavel[64:33];
        Q = superVariavel[32:1];
        Qadicional = superVariavel[0];
        count = count + 1;

        if (count == 32) begin
            mfhi = produto;
            mflo = Q;
            end
        end
end

endmodule;