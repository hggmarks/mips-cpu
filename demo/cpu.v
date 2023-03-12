module cpu (
    input wire clk,
    input wire reset
);

//control wires:

    wire [2:0] Iord_sel;
    wire MEM_rw;
    wire IR_w;
    wire [2:0] Reg_dst_sel;
    wire REG_w;
    wire [2:0] Mem_to_reg_sel;
    wire [1:0] Mux_alusrc_A_sel;
    wire [1:0] Mux_alusrc_B_sel;
    wire EPC_w;
    wire mflo_w;
    wire mfhi_w;
    wire Mult_init;
    wire Mult_end;
    wire Div_init;
    wire Div_end;
    wire excessao;
    wire SEL_mflo;
    wire SEL_mfhi;

// Data wires:

    wire [31:0] PC_source_out;
    wire [31:0] PC_out;

    wire [31:0] ALU_out;
    wire [31:0] ALU_result;

    wire [31:0] EPC_out;

    wire [31:0] MEM_to_IR;

    wire [5:0] OPCODE;
    wire [4:0] RS;
    wire [4:0] RT;
    wire [15:0] Imediate;

    wire [4:0] Reg_dst_out;

    wire [31:0] Mem_to_reg_out;
    wire [31:0] RB_to_A;
    wire [31:0] RB_to_B;
    wire AB_w;
    wire [31:0] Reg_A_out;
    wire [31:0] Reg_B_out;

    wire [31:0] Mux_alusrc_A_out;
    wire [31:0] Mux_alusrc_B_out;

    wire [31:0] shift_left_2_alu_out;

    //Saídas dos registradores MFLO e MFHI
    wire [31:0] Reg_mflo_out;
    wire [31:0] Reg_mfhi_out;

    //saídas dos módulos mult e div
    wire [31:0] Mflo_out_div;
    wire [31:0] Mfhi_out_div;
    wire [31:0] Mflo_out_mult;
    wire [31:0] Mfhi_out_mult;   

    //mux mflo
    wire [31:0] Mflo_out;

    //mux mfhi
    wire [31:0] Mfhi_out;

    //Iord
    wire [31:0] Mux_iord_out;

    //extensores
    wire [31:0] sign_X;
    wire [31:0] sign_left;

    //ULA_
    wire [2:0] ALU_c;
    wire overflow;
    wire negativo;
    wire zero;
    wire igual;
    wire maior;
    wire menor;

    wire [2:0] PC_source_sel;

    wire reset_out; //olhar isso aq dps

    wire ALU_OUT_w;

    wire [31:0] Xtend_16x32_out;

    wire [31:0] concat_sl_26x28_out;

    wire [31:0] Xtend_1x32_out;


    Registrador PC_(
        clk,
        reset,
        PC_w || igual,
        PC_source_out,
        PC_out
    );

    Memoria MEM_(
        Mux_iord_out,
        clk, 
        MEM_rw,
        ALU_out,
        MEM_to_IR
    );

    MUX_Iord MUX_IORD_(
        Iord_sel,
        PC_out,
        ALU_out,
        ALU_result,
        Mux_iord_out
    );

    Instr_Reg IR_(
        clk,
        reset,
        IR_w,
        MEM_to_IR,
        OPCODE,
        RS,
        RT,
        Imediate
    );

    MUX_write_register MUX_REG_DST_(
        Reg_dst_sel,
        RS,
        RT,
        Imediate[15:11],
        Reg_dst_out
    );

    MUX_write_data MEM_TO_REG_(
        Mem_to_reg_sel,
        1'd0,
        Reg_mflo_out,
        Reg_mfhi_out,
        1'd0,
        Xtend_1x32_out,
        ALU_result, //ALU_out,
        Mem_to_reg_out
    );

    Banco_reg REG_BASE_(
        clk,
        reset,
        REG_w,
        RS,
        RT,
        Reg_dst_out,
        Mem_to_reg_out,
        RB_to_A,
        RB_to_B
    );    

    Registrador REG_A_(
        clk,
        reset,
        AB_w,
        RB_to_A,
        Reg_A_out
    );

    Registrador REG_B_(
        clk,
        reset,
        AB_w,
        RB_to_B,
        Reg_B_out
    );

    MUX_ALUSrc_A MUX_ALUSrc_A_(
        PC_out,
        Reg_A_out,
        Reg_B_out,
        Mux_alusrc_A_sel,
        Mux_alusrc_A_out
    );

    MUX_ALUSrc_B MUX_ALUSrc_B_(
        Reg_B_out,
        Xtend_16x32_out,
        shift_left_2_alu_out,
        Mux_alusrc_B_sel,
        Mux_alusrc_B_out
    );

    MUX_mflo MUX_MFLO_(
        SEL_mflo,
        Mflo_out_mult,
        Mflo_out_div,
        Mflo_out
    );

    MUX_mfhi MUX_MFHI_(
        SEL_mfhi,
        Mfhi_out_mult,
        Mfhi_out_div,
        Mfhi_out
    );

    ula32 ULA_(
        Mux_alusrc_A_out,
        Mux_alusrc_B_out,
        ALU_c,
        ALU_result,
        overflow,
        negativo,
        zero,
        igual,
        maior,
        menor
    );

    Registrador ALU_OUT_(
        clk,
        reset,
        ALU_OUT_w,
        ALU_result,
        ALU_out
    );

    Registrador EPC_(
        clk,
        reset,
        EPC_w,
        ALU_result,
        EPC_out
);

    MUX_PC PC_SOURCE_(
        PC_source_sel, ///
        MEM_to_IR,
        ALU_result,
        ALU_out,
        PC_out,
        32'd0,
        EPC_out,
        concat_sl_26x28_out,
        PC_source_out
    );

    shift_left_2_alu SHIFT_LEFT2ALU(
        Xtend_16x32_out,
        shift_left_2_alu_out
    );

    sign_extend_16x32 XTEND_16x32_(
        Imediate,
        Xtend_16x32_out
    );

    Sign_extend1x32 XTEND_1x32_(
        menor,
        Xtend_1x32_out
    );

    shift_left_2_alu SHIFT_LEFT2_ALU_(
        Xtend_16x32_out,
        shift_left_2_alu_out
    );

    concat_sl_26x28 CONCAT_SL_26X28_(
        RS,
        RT,
        Imediate,
        PC_out,
        concat_sl_26x28_out
    );

    Registrador MFLO_(
        clk,
        reset,
        mflo_w,
        Mflo_out,
        Reg_mflo_out
    );

    Registrador MFHI_(
        clk,
        reset,
        mfhi_w,
        Mfhi_out,
        Reg_mfhi_out
    );

    mult MULT_(
        clk,
        Mux_alusrc_A_out,
        Mux_alusrc_B_out,
        reset,
        Mflo_out_mult,
        Mfhi_out_mult,
        Mult_init,
        Mult_end
    );

    div DIV_(
        clk,
        Mux_alusrc_A_out,
        Mux_alusrc_B_out,
        reset,
        Mflo_out_div,
        Mfhi_out_div,
        excessao,
        Div_init,
        Div_end
    );

    control_unit CONTROL_UNIT_(
        clk,
        reset,
        overflow,
        negativo,
        zero,
        igual,
        maior,
        menor,
        OPCODE,
        Imediate[5:0], //funct 
        PC_w,
        MEM_rw,
        IR_w,
        REG_w,
	    AB_w,
	    ALU_OUT_w,
	    EPC_w,
        ALU_c,
        Iord_sel,
        Mux_alusrc_A_sel,
        Mux_alusrc_B_sel,
        Reg_dst_sel,
        Mem_to_reg_sel,
        PC_source_sel,
        Mult_init,
        Mult_end,
        mfhi_w,
        mflo_w,
        Div_init,
        Div_end,
        excessao,
        SEL_mflo,
        SEL_mfhi,
        reset 
    ); 
endmodule
