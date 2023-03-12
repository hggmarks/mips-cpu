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
    output reg MultInit,
    input reg MultEnd,
    output reg HiWrite,
    output reg LoWrite,
    output reg DivInit,
    input reg DivEnd,
    input reg excessao,
    output reg SEL_mflo,
    output reg SEL_mfhi,
    output reg rstOut
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

parameter ST_MFHI = 7'd70;
parameter ST_MFLO = 7'd71;
parameter ST_MULT_1 = 7'd78;
parameter ST_MULT_2 = 7'd79;
parameter ST_DIV_1 = 7'd82;
parameter ST_DIV_2_no = 7'd83;
parameter ST_DIV_2_yo = 7'd84;
parameter ST_DIV_3_a = 7'd85;
parameter ST_DIV_3_b = 7'd86;
parameter ST_DIV_4 = 7'd87;

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
        MultInit <= 1'b0;
        DivInit <= 1'b0;
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

            ST_MFHI: begin
                muxMemToReg <= 3'b011;
                muxRegDst <= 3'b010;
                RegWrite <= 1'b1;
            end

            ST_MFLO: begin
                muxRegDst <= 3'b010;
                muxMemToReg <= 3'b010;
                RegWrite <= 1'b1;
            end

            ST_MULT_1: begin
                MultInit <= 1'b1;
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b00;
            end

            ST_MULT_2: begin
                MultInit <= 1'b0;
                SEL_mflo <= 1'b0;
                SEL_mfhi <= 1'b0;
                HiWrite <= 1'b1;
                LoWrite <= 1'b1;
            end

            ST_DIV_1: begin
                DivInit <= 1'b1;
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b00;               
            end

            ST_DIV_2_yo: begin
                muxAluSrcA <= 2'b00;
                muxAluSrcB <= 2'b01;
                aluOP <= 3'b010;
                EpcWrite <= 1'b1;
            end

            ST_DIV_2_no: begin
                DivInit <= 1'b0;
                SEL_mflo <= 1'b1;
                SEL_mfhi <= 1'b1;
                HiWrite <= 1'b1;
                LoWrite <= 1'b1;    
            end

            ST_DIV_3_a: begin
                muxIord <= 3'b101;
                memRW <= 0;
            end

            ST_DIV_3_b: begin
                muxIord <= 3'b101;
                memRW <= 0;
            end

            ST_DIV_4: begin
                muxPCSource <= 3'b000;
                PCWrite <= 1'b1;
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

                               OP_MULT:
                                    STATE <= ST_MULT_1;

                                OP_MFHI:
                                    STATE <= ST_MFHI;

                                OP_MFLO:
                                    STATE <= ST_MFLO;

                                OP_DIV:
                                    STATE <= ST_DIV_1;
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
                    
                ST_MULT_1:
                    STATE <= ST_MULT_2;

                ST_MULT_2:
                    if (MultEnd == 1) begin
                        STATE <= ST_COMMON_0;
                    end

                ST_DIV_1:
                    STATE <= ST_DIV_2_no;

                ST_DIV_2_yo: begin
                    STATE <= ST_DIV_3_a;
                end

                ST_DIV_2_no: begin
                    if (excessao == 1) begin
                        STATE <= ST_DIV_2_yo;
                    end
                    
                    else begin
                        if (DivEnd == 1) begin
                            STATE <= ST_COMMON_0;
                        end
                    end
                end

                ST_DIV_3_a: begin
                    STATE <= ST_DIV_3_b;
                end

                ST_DIV_3_b: begin
                    STATE <= ST_DIV_4;
                end

                ST_DIV_4: begin
                    STATE <= ST_COMMON_0;
                end

                ST_MFHI:
                    STATE <= ST_COMMON_0;

                ST_MFLO:
                    STATE <= ST_COMMON_0;
            endcase
        end
    end    
endmodule