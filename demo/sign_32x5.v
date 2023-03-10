module sign_32x5(
    input wire[31:0] data_in,
    output wire[4:0] data_out
);

assign data_out = data_in[4:0];

endmodule