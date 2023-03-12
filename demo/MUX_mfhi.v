module MUX_mfhi (
    input SEL,
    input [31:0] mfhi_mult,
    input [31:0] mfhi_div, 
    output reg [31:0] OUT
);

    always @(*) begin

        if (SEL)
            OUT = mfhi_div;
        else
            OUT = mfhi_mult;

    end

endmodule