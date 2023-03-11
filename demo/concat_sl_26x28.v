module concat_sl_26x28(
    input wire [4:0] RS,
    input wire [4:0] RT,
    input wire [15:0] Imediate,
    input wire [31:0] PC_output,
    output wire [31:0] concat_sl_26x28_out
);

    assign concat_sl_26x28_out = {PC_output[31:28], RS, RT, Imediate, 2'b00};

endmodule