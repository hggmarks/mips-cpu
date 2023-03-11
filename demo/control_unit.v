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
    output reg [2:0] aluOP,
    output reg [2:0] muxIord,
    output reg [1:0] muxAluSrcA,
    output reg [1:0] muxAluSrcB,
    output reg [2:0] muxRegDst,
    output reg [2:0] muxMemToReg,
    output reg [2:0] muxPCSource,
    output reg rstOut
);

//sram, lui, sb, sh

//Variables
reg [5:0] COUNTER;
reg [6:0] STATE;

parameter ST_WAIT = 7'd127;
parameter ST_RESET = 7'd0;

parameter ST_COMMON_0 = 7'd1; ///
parameter ST_COMMON_1 = 7'd2; ///
parameter ST_COMMON_2 = 7'd3; ///
parameter ST_COMMON_WAIT = 7'd4; ///
parameter ST_ADD = 7'd5; ///
parameter ST_AND = 7'd6;
parameter ST_DIV = 7'd7;
parameter ST_MULT = 7'd8;
parameter ST_JR = 7'd9; ///
parameter ST_MFHI = 7'd10;
parameter ST_MFLO = 7'd11;
parameter ST_SLL = 7'd12;
parameter ST_SLLV = 7'd13;
parameter ST_SLT = 7'd14;
parameter ST_SRA = 7'd15;
parameter ST_SRAV = 7'd16;
parameter ST_SRL = 7'd17;
parameter ST_SUB = 7'd18;
parameter ST_BREAK = 7'd19;
parameter ST_RTE = 7'd20;
parameter ST_XCHG = 7'd21;
parameter ST_ADDI = 7'd22;
parameter ST_ADDIU = 7'd23;
parameter ST_BEQ_0 = 7'd24; ///
parameter ST_BEQ_1 = 7'd25; ///
parameter ST_BNE_0 = 7'd26; ///
parameter ST_BNE_1 = 7'd27; ///
parameter ST_BLE_0 = 7'd28; ///
parameter ST_BLE_1 = 7'd29; ///
parameter ST_BGT_0 = 7'd30; ///
parameter ST_BGT_1 = 7'd31; ///
parameter ST_SRAM_0 = 7'd32;
parameter ST_SRAM_1 = 7'd33;

parameter ST_J = 7'd60; ///
parameter ST_JAL = 7'd61; ///

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

            ST_JR: begin
                muxAluSrcA <= 2'b10;
                aluOP <= 3'b000;
                muxPCSource <= 3'b001; // era p ser 010 mas prefiro pegar direto do result
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

            ST_SRAM_0: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b10;
                aluOP <= 3'b001;
            end

            ST_SRAM_1: begin
                
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

                                OP_JR:
                                    STATE <= ST_JR;
                                
                            endcase
                        OP_ADDI:
                            STATE <= ST_ADDI;

                        OP_BEQ:
                            STATE <= ST_BEQ_0;
                        
                        OP_BNE:
                            STATE <= ST_BNE_0;
                        
                        OP_BLE:
                            STATE <= ST_BLE_0;

                        OP_BGT:
                            STATE <= ST_BGT_0;
                        
                        OP_SRAM:
                            STATE <= ST_SRAM_0;
                        
                        OP_J:
                            STATE <= ST_J;

                        OP_JAL:
                            STATE <= ST_JAL;
                        
                    endcase
                ST_ADD:
                    STATE <= ST_COMMON_0;
                
                ST_ADDI:
                    STATE <= ST_COMMON_0;

                ST_JR:
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

                ST_SRAM_0:
                    STATE <= ST_SRAM_1;

            endcase
        end
    end    
endmodule