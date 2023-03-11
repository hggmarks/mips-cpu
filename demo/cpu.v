
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
    wire [2:0] ALU_c;
    wire [2:0] SR_c;
    wire [2:0] SR_input_sel;
    wire [2:0] SR_num_sel;
    wire Mdr_w;
    wire [1:0] LS_c;
    wire [1:0] SS_c;

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

    //Iord
    wire [31:0] Mux_iord_out;

    //extensores
    wire [31:0] sign_X;
    wire [31:0] sign_left;

    

    //ULA_
    
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

    wire [31:0] shift_left_2_alu_out;

    wire [31:0] Mux_SR_input_out;
    wire [31:0] Mux_SR_num_out;
    wire [4:0] Xtend_32x5_out;
    wire [31:0] SR_out;
    wire Mdr_out;
    wire [31:0] LS_out;

    wire [31:0] SS_out;

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
        image.png,
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
        SR_out,
        1'd0, //mfodase
        1'd0, //mflolo
        LS_out,
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

    Sign_extend1x32 XTEND_1x32_(
        menor,
        Xtend_1x32_out
    );

    sign_extend_16x32 XTEND_16x32_(
        Imediate,
        Xtend_16x32_out
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

    MUX_SR_A MUX_SR_INPUT_(
        Xtend_16x32_out,
        Reg_A_out,
        Reg_B_out,
        SR_input_sel,
        Mux_SR_input_out
    );

    MUX_SR_B MUX_SR_NUM_(
        Reg_B_out,
        Xtend_16x32_out,
        Mdr_out, //MDR
        SR_num_sel,
        Mux_SR_num_out
    );

    sign_32x5 XTEND_32x5_(
        Mux_SR_num_out,
        Xtend_32x5_out
    );

    RegDesloc SHIFT_REG_(
        clk,
        reset,
        SR_c,
        Xtend_32x5_out,
        Mux_SR_input_out,
        SR_out
    );

    Registrador MDR_(
        clk,
	    reset,
        Mdr_w,
        MEM_to_IR,
        Mdr_out
    );

    load_size_ls LOAD_SIZE_(
        LS_c,
        Mdr_out,
        MEM_to_IR,
        LS_out
    );

    store_size_ss STORE_SIZE_(
        SS_c,
        Reg_B_out,
        Mdr_out,
        SS_out
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
        reset 
    ); 
endmodule
