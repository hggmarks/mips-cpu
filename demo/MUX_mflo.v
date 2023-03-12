module MUX_mflo (
    input SEL,
    input [31:0] mflo_mult,
    input [31:0] mflo_div, 
    output reg [31:0] OUT
);

    always @(*) begin

        if (SEL)
            OUT = mflo_div; // se for 1 ele pega do div
        else
            OUT = mflo_mult; // se for 0 ele pega do mult

    end

endmodule