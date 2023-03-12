module control_unit (
    input wire clk,
    input wire rst,
    input wire overflow,
    input wire negativo,
    input wire zero,
    input wire igual,
    input wire maior,
    input wire menor,
    input wire [5:0] opcode,
    input wire [5:0] funct,
    output reg PCWrite,
    output reg memRW, //memRead and memWrite
    output reg IRWrite,
    output reg RegWrite,
    output reg ABWrite,
    output reg AluOutWrite,
    output reg EpcWrite,
    output reg [2:0] aluOP,
    output reg [2:0] muxIord,
    output reg [1:0] muxAluSrcA,
    output reg [1:0] muxAluSrcB,
    output reg [2:0] muxRegDst,
    output reg [2:0] muxMemToReg,
    output reg [2:0] muxPCSource,
    output reg rstOut,
    output reg [2:0] SR_c,
    output reg [2:0] SRNumSel,
    output reg MdrWrite,
    output reg [2:0] SRInputSel,
    output reg [1:0] LS_c,
    output reg [1:0] SS_c
);

//sram, lui, sb, sh

//Variables
reg [5:0] COUNTER;
reg [6:0] STATE;

parameter ST_WAIT = 7'd127;
parameter ST_RESET = 7'd0;
parameter ST_COMMON_0 = 7'd1;
parameter ST_COMMON_1 = 7'd2;
parameter ST_COMMON_2 = 7'd3;
parameter ST_COMMON_WAIT = 7'd4;
parameter ST_ADD = 7'd5;
parameter ST_ADDI = 7'd6; //aumentar esse valor depois de adicionar 
parameter ST_AND = 7'd7;
parameter ST_SUB = 7'd8;
parameter ST_ADDIU = 7'd9;
 
parameter ST_JR = 7'd15;
parameter ST_RTE = 7'd23;

parameter ST_SLT = 7'd40;
parameter ST_SLTI = 7'd42; 
parameter ST_BREAK = 7'd44;

parameter ST_SLL_1 = 7'd50;
parameter ST_SLL_2 = 7'd51;
parameter ST_SLL_3 = 7'd52;
parameter ST_SLL_4 = 7'd53;

parameter ST_SLLV_1 = 7'd54;
parameter ST_SLLV_2 = 7'd55;
parameter ST_SLLV_3 = 7'd56;
parameter ST_SLLV_4 = 7'd57;

parameter ST_SRA_1 = 7'd90;
parameter ST_SRA_2 = 7'd91;
parameter ST_SRA_3 = 7'd92;
parameter ST_SRA_4 = 7'd93;

parameter ST_SRAV_1 = 7'd33;
parameter ST_SRAV_2 = 7'd34;
parameter ST_SRAV_3 = 7'd35;
parameter ST_SRAV_4 = 7'd36;

parameter ST_SRL_1 = 7'd18;
parameter ST_SRL_2 = 7'd19;
parameter ST_SRL_3 = 7'd20;
parameter ST_SRL_4 = 7'd21;


parameter ST_SW_1 = 7'd65;
parameter ST_SW_2 = 7'd66;

parameter ST_LB_1 = 7'd73;
parameter ST_LB_2 = 7'd74;
parameter ST_LB_3 = 7'd75;
parameter ST_LB_4 = 7'd76;


//J type STATES
parameter ST_J = 7'd60;
parameter ST_JAL = 7'd61;

parameter ST_BEQ_0 = 7'd24; ///
parameter ST_BEQ_1 = 7'd25; ///
parameter ST_BNE_0 = 7'd26; ///
parameter ST_BNE_1 = 7'd27; ///
parameter ST_BLE_0 = 7'd28; ///
parameter ST_BLE_1 = 7'd29; ///
parameter ST_BGT_0 = 7'd30; ///
parameter ST_BGT_1 = 7'd31; ///


//Instruções tipo R
parameter TYPE_R = 7'h0;
    parameter OP_ADD = 7'h20;
    parameter OP_AND = 7'h24;
    parameter OP_DIV = 7'h1a;
    parameter OP_MULT = 7'h18;
    parameter OP_JR = 7'h8;
    parameter OP_MFHI = 7'h10;
    parameter OP_MFLO = 7'h12;
    parameter OP_SLL = 7'h0;
    parameter OP_SLLV = 7'h4;
    parameter OP_SLT = 7'h2a;
    parameter OP_SRA = 7'h3;
    parameter OP_SRAV = 7'h7;
    parameter OP_SRL = 7'h2;
    parameter OP_SUB = 7'h22;
    parameter OP_BREAK = 7'hd;
    parameter OP_RTE = 7'h13;
    parameter OP_XCHG = 7'h5;


//Instruções tipo I
parameter OP_ADDI = 7'h8;
parameter OP_ADDIU = 7'h9;
parameter OP_BEQ = 7'h4;
parameter OP_BNE = 7'h5;
parameter OP_BLE = 7'h6;
parameter OP_BGT = 7'h7;
parameter OP_SRAM = 7'h1;
parameter OP_LB = 7'h20;
parameter OP_LH = 7'h21;
parameter OP_LUI = 7'hf;
parameter OP_LW = 7'h23;
parameter OP_SB = 7'h28;
parameter OP_SH = 7'h29;
parameter OP_SLTI = 7'ha;
parameter OP_SW = 7'h2b;

//Instruções tipo J
parameter OP_J = 7'h2;
parameter OP_JAL = 7'h3;

    initial begin
        // Initial Reset
        STATE = ST_RESET;
    end

//SINAIS
    always @(posedge clk) begin

        PCWrite <= 1'b0;
        memRW <= 1'b0;
        IRWrite <= 1'b0;
        RegWrite <= 1'b0;
        ABWrite <= 1'b0;
        AluOutWrite <= 1'b0;
        aluOP <= 3'b000;
        muxIord <= 3'b000;
        muxAluSrcA <= 2'b00;
        muxAluSrcB <= 2'b00;
        muxRegDst <= 3'b000;
        muxMemToReg <= 3'b000;
        muxPCSource <= 3'b000;
        rstOut <= 3'b000;

        case (STATE)
            ST_RESET: begin
                RegWrite <= 1'b1; ///
                muxRegDst <= 3'b100;   ///
                muxMemToReg <= 3'b000; ///
            end

            ST_COMMON_0: begin
                muxIord <= 3'b000;
                memRW <= 1'b0;
            end

            ST_COMMON_1: begin
                muxAluSrcA <= 2'b00;
                muxAluSrcB <= 2'b01;  // 4 do pc + 4
                aluOP <= 3'b001;
                muxPCSource <= 3'b001;
                PCWrite <= 1'b1;
                IRWrite <= 1'b1;
            end

            ST_COMMON_2: begin
		        ABWrite <= 1'b1;
                muxAluSrcA <= 2'b00;
                muxAluSrcB <= 2'b11; //prevendo um branch
                aluOP <= 3'b001;
            end

            ST_ADDI: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b10; // pegando imediato do sign xtend
                aluOP <= 3'b001;
                muxRegDst <= 3'b000;
                RegWrite <= 1'b1;
                muxMemToReg <= 3'b110;
            end

            ST_ADD: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b00; // deveria voltar a pegar do REG_B_
                aluOP <= 3'b001;
                muxRegDst <= 3'b010;
                RegWrite <= 1'b1;
                muxMemToReg <= 3'b110;
            end

            ST_SLT: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b00;
                aluOP <= 3'b111;
                muxMemToReg <= 3'b101;
                muxRegDst <= 3'b010; //DEVIA SER 001
                RegWrite <= 1'b1;
            end

            ST_BREAK: begin
                muxAluSrcA <= 2'b00;
                muxAluSrcB <= 2'b01;
                aluOP <= 3'b010;
                muxPCSource <= 3'b001;
                PCWrite <= 1'b1;
            end

            ST_SLTI: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b10;
                aluOP <= 3'b111;    
                muxMemToReg <= 3'b101;
                muxRegDst <= 3'b000;
                RegWrite <= 1'b1;
            end

            ST_AND: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b00; 
                aluOP <= 3'b011;
                muxRegDst <= 3'b010;
                RegWrite <= 1'b1;
                muxMemToReg <= 3'b110;
            end

            ST_SUB: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b00; 
                aluOP <= 3'b010; 
                muxRegDst <= 3'b010;
                RegWrite <= 1'b1;
                muxMemToReg <= 3'b110;
            end

            ST_ADDIU: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b10; 
                aluOP <= 3'b001;
                muxRegDst <= 3'b000;
                RegWrite <= 1'b1;
                muxMemToReg <= 3'b110;
            end

            ST_JR: begin
                muxAluSrcA <= 2'b10;
                aluOP <= 3'b000;
                muxPCSource <= 3'b001; // era p ser 010 mas prefiro pegar direto do result
                PCWrite <= 1'b1;
            end

	        ST_RTE: begin
		        muxPCSource <= 3'b101;
                PCWrite <= 1'b1;
	        end

            ST_J: begin
                muxPCSource <= 3'b110; //deveria ser 011 mas adicionei uma entrada a mais
                PCWrite <= 1'b1;
            end

            ST_JAL: begin
                muxMemToReg <= 3'b110; ///
                muxRegDst <= 3'b011;   ///
                RegWrite <= 1'b1;      ///
            end

            ST_BEQ_0: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b00;
                aluOP <= 3'b111;
            end

            ST_BEQ_1: begin
                muxAluSrcA <= 2'b00;
                muxAluSrcB <= 2'b11;
                aluOP <= 001;
                muxPCSource <= 3'b001;
                if (igual) begin
                    PCWrite <= 1'b1;
                end
            end

            ST_BNE_0: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b00;
                aluOP <= 3'b111;
            end

            ST_BNE_1: begin
                muxAluSrcA <= 2'b00;
                muxAluSrcB <= 2'b11;
                aluOP <= 001;
                muxPCSource <= 3'b001;
                if (!igual) begin
                    PCWrite <= 1'b1;
                end
            end

            ST_BLE_0: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b00;
                aluOP <= 3'b111;
            end

            ST_BLE_1: begin
                muxAluSrcA <= 2'b00;
                muxAluSrcB <= 2'b11;
                aluOP <= 001;
                muxPCSource <= 3'b001;
                if (!maior) begin
                    PCWrite <= 1'b1;
                end
            end

            ST_BGT_0: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b00;
                aluOP <= 3'b111;
            end

            ST_BGT_1: begin
                muxAluSrcA <= 2'b00;
                muxAluSrcB <= 2'b11;
                aluOP <= 001;
                muxPCSource <= 3'b001;
                if (maior) begin
                    PCWrite <= 1'b1;
                end
            end
//###################################################################
            ST_SLL_1: begin
                SRInputSel <= 2'b10;
                SRNumSel <= 2'b01;
                SR_c <= 3'b001; 
            end

            ST_SLL_2: begin
                SR_c <= 3'b010;
            end
            ST_SLL_3: begin
                SR_c <= 3'b000;
                rstOut <= 3'b000;
            end
            ST_SLL_4: begin
                muxMemToReg <= 3'b001;
                muxRegDst <= 3'b010;
                RegWrite <= 1'b1;
            end
//#####################################################################
            ST_SRA_1: begin
                SRInputSel <= 2'b10;
                SRNumSel <= 2'b01;
                SR_c <= 3'b001;
            end
            ST_SRA_2: begin
                SR_c <= 3'b100;
            end
            ST_SRA_3: begin
                SR_c <= 3'b000;
                rstOut <= 3'b000;
            end
            ST_SRA_4: begin
                muxMemToReg <= 3'b001;
                muxRegDst <= 3'b010;
                RegWrite <= 1'b1;
            end
            
//#########################################################
            ST_SLLV_1: begin
                SRInputSel <= 2'b01;
                SRNumSel <= 2'b00;
                SR_c <= 3'b001; 
            end
            ST_SLLV_2: begin
                SR_c <= 3'b010;
            end
            ST_SLLV_3: begin
                SR_c <= 3'b000;
                rstOut <= 3'b000;
            end
            ST_SLLV_4: begin
                muxMemToReg <= 3'b001;
                muxRegDst <= 3'b010;
                RegWrite <= 1'b1;
            end
//##########################################################
            ST_SRL_1: begin
                SRInputSel <= 2'b10;
                SRNumSel <= 2'b01;
                SR_c <= 3'b001;
            end
            ST_SRL_2: begin
                SR_c <= 3'b011;                                 // ESTOU AQUI
            end
            ST_SRL_3: begin
                SR_c <= 3'b000;
                rstOut <= 3'b000;
            end
            ST_SRL_4: begin
                muxMemToReg <= 3'b001;
                muxRegDst <= 3'b010;
                RegWrite <= 1'b1;
            end
//#############################################################
            ST_SRAV_1: begin
                SRInputSel <= 2'b01;
                SRNumSel <= 2'b00;
                SR_c <= 3'b001; 
            end
            ST_SRAV_2: begin
                SR_c <= 3'b100;
            end
            ST_SRAV_3: begin
                SR_c <= 3'b000;
                rstOut <= 3'b000;
            end
            ST_SRAV_4: begin
                muxMemToReg <= 3'b001;
                muxRegDst <= 3'b010;
                RegWrite <= 1'b1;
            end
            

            ST_SW_1: begin
                muxAluSrcA <= 3'b010;
                muxAluSrcB <= 3'b010;
                aluOP <= 3'b001;
                SS_c <= 2'b11;
            end
            ST_SW_2: begin
                muxIord <= 3'b001;
                memRW <= 1'b1;
            end

            ST_LB_1:begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b10;
                aluOP <= 3'b001;
            end
            ST_LB_2: begin
                muxIord <= 3'b001;
                memRW <= 1'b0;
            end
            ST_LB_3: begin
                muxIord <= 3'b001;
                memRW <= 1'b0;
            end
            ST_LB_4: begin
                LS_c <= 2'b01;
                muxMemToReg <= 3'b100;
                muxRegDst <= 3'b000;
                RegWrite <= 1'b1;
            end

            ST_COMMON_WAIT,
            ST_WAIT:
                rstOut <= 3'b000;

        endcase
    end

// ESTADOS
    always @(posedge clk, posedge rst) begin

        if(rst) begin
            STATE = ST_RESET;
        end
        else begin

            case (STATE)
                ST_RESET:
                    STATE <= ST_COMMON_0;

                ST_COMMON_0:
                    STATE <= ST_COMMON_1;
                
                ST_COMMON_1:
                    STATE <= ST_COMMON_WAIT;

                ST_COMMON_WAIT:
                    STATE <= ST_COMMON_2;
                
                ST_COMMON_2:
                    case (opcode) 

                        TYPE_R: 
                            case (funct)

                                OP_ADD:
                                    STATE <= ST_ADD;

                                OP_AND:
                                    STATE <= ST_AND;
                                
                                OP_BREAK:
                                    STATE <= ST_BREAK;

                                OP_SLT:
                                    STATE <= ST_SLT;

                                OP_SUB:
                                    STATE <= ST_SUB;

                                OP_JR:
                                    STATE <= ST_JR;

                                OP_RTE:
				                    STATE <= ST_RTE;    

                                OP_SLL:
                                    STATE <= ST_SLL_1;
                                
                                OP_SLLV:
                                    STATE <= ST_SLLV_1;
                                
                                OP_SRA:
                                    STATE <= ST_SRA_1;
                                
                                OP_SRAV:
                                    STATE <= ST_SRAV_1;
                                
                                OP_SRL:
                                    STATE <= ST_SRL_1;
                            endcase
                            
                        OP_ADDI:
                            STATE <= ST_ADDI;

                        OP_SLTI:
                            STATE <= ST_SLTI;

                        OP_BEQ:
                            STATE <= ST_BEQ_0;
                        
                        OP_BNE:
                            STATE <= ST_BNE_0;
                        
                        OP_BLE:
                            STATE <= ST_BLE_0;

                        OP_BGT:
                            STATE <= ST_BGT_0;

                        OP_ADDIU:
                            STATE <= ST_ADDIU;
                        
                        OP_J:
                            STATE <= ST_J;

                        OP_JAL:
                            STATE <= ST_JAL;   

                        OP_SW:
                            STATE <= ST_SW_1;

                        OP_LB:
                            STATE <= ST_LB_1;
                    endcase

                ST_ADD:
                    STATE <= ST_COMMON_0;

                ST_ADDI:
                    STATE <= ST_COMMON_0;

                ST_SLT:
                    STATE <= ST_COMMON_0;

                ST_SLTI:
                    STATE <= ST_COMMON_0;
                
                ST_BREAK:
                    STATE <= ST_WAIT;

                ST_AND:
                    STATE <= ST_COMMON_0;

                ST_SUB:
                    STATE <= ST_COMMON_0;

                ST_ADDIU:
                    STATE <= ST_COMMON_0;

                ST_JR:
                    STATE <= ST_WAIT;
		
		        ST_RTE:
		            STATE <= ST_WAIT;
                
                ST_J:
                    STATE <= ST_WAIT;

                ST_JAL: 
                    STATE <= ST_J;

                ST_WAIT:
                    STATE <= ST_COMMON_0;

                ST_BEQ_0:
                    STATE <= ST_BEQ_1;

                ST_BEQ_1:
                    STATE <= ST_COMMON_0;
                
                ST_BNE_0:
                    STATE <= ST_BNE_1;
                
                ST_BNE_1:
                    STATE <= ST_COMMON_0;

                ST_BLE_0:
                    STATE <= ST_BLE_1;
                
                ST_BLE_1:
                    STATE <= ST_COMMON_0;
                
                ST_BGT_0:
                    STATE <= ST_BGT_1;
                
                ST_BGT_1:
                    STATE <= ST_COMMON_0;

                ST_SLL_1:
                    STATE <= ST_SLL_2;
                ST_SLL_2:
                    STATE <= ST_SLL_3;
                ST_SLL_3:
                    STATE <= ST_SLL_4;
                ST_SLL_4:
                    STATE <= ST_WAIT;

                ST_SLLV_1:
                    STATE <= ST_SLLV_2;   
                ST_SLLV_2:
                    STATE <= ST_SLLV_3;
                ST_SLLV_3:
                    STATE <= ST_SLLV_4;
                ST_SLLV_4:
                    STATE <= ST_WAIT;

                ST_SRA_1:
                    STATE <= ST_SRA_2;
                ST_SRA_2:
                    STATE <= ST_SRA_3;
                ST_SRA_3:
                    STATE <= ST_SRA_4;
                ST_SRA_4:
                    STATE <= ST_WAIT;

                ST_SRAV_1:
                    STATE <= ST_SRAV_2;
                ST_SRAV_2:
                    STATE <= ST_SRAV_3;
                ST_SRAV_3:
                    STATE <= ST_SRAV_4;
                ST_SRAV_4:
                    STATE <= ST_WAIT;

                ST_SW_1:
                    STATE <= ST_SW_2;
                ST_SW_2:
                    STATE <= ST_COMMON_0;

                ST_SRL_1:
                    STATE <= ST_SRL_2;
                ST_SRL_2:
                    STATE <= ST_SRL_3;
                ST_SRL_3:
                    STATE <= ST_SRL_4;
                ST_SRL_4:
                    STATE <= ST_WAIT;

                ST_LB_1:
                    STATE <= ST_LB_2;
                ST_LB_2:
                    STATE <= ST_LB_3;
                ST_LB_3:
                    STATE <= ST_LB_4;
                ST_LB_4:
                    STATE <= ST_COMMON_0;
            endcase
        end
    end    
endmodule