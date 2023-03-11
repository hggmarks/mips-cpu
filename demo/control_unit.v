module control_unit (
    input wire clk,
    input wire rst,
    input wire overflow,
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
    output reg rstOut
);


//Variables
reg [5:0] COUNTER;
reg [6:0] STATE;

parameter ST_WAIT = 7'd127;
parameter ST_COMMON_0 = 7'd1;
parameter ST_COMMON_1 = 7'd2;
parameter ST_COMMON_2 = 7'd3;
parameter ST_COMMON_WAIT = 7'd4;
//parameter ST_ADDI = 7'd4;

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

parameter ST_RESET = 7'd0;

parameter TYPE_R = 7'h0;
    parameter OP_ADD = 7'h20;
    parameter OP_JR = 7'h8; //igual ao addi mas sao campos diferentes (funct x opcode)

    parameter OP_RTE = 7'h13;
    parameter OP_AND = 7'h24;
    parameter OP_SUB = 7'h22;

parameter OP_ADDIU = 7'h9;

parameter OP_ADDI = 7'h8;



parameter OP_SLT = 7'h2a;
parameter OP_SLTI = 7'ha;
parameter OP_BREAK = 7'hd;

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

            ST_SLTI: begin
                muxAluSrcA <= 2'b10;
                muxAluSrcB <= 2'b10;
                aluOP <= 3'b111;    
                muxMemToReg <= 3'b101;
                muxRegDst <= 3'b000;
                RegWrite <= 1'b1;
            end
	        ST_RTE: begin
		        muxPCSource <= 3'b101;
                PCWrite <= 1'b1;
	        end

            ST_J: begin
                muxPCSource <= 3'b110; //deveria ser 011 mas adicionei uma entrada a mais
                PCWrite <= 1'b1;
            end

            ST_BREAK: begin
                muxAluSrcA <= 2'b00;
                muxAluSrcB <= 2'b01;
                aluOP <= 3'b010;
                muxPCSource <= 3'b001;
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
                                    STATE <= ST_ADD_1;

                                OP_SLT:
                                    STATE <= ST_SLT;

                                OP_BREAK:
                                    STATE <= ST_BREAK;  

                                OP_AND:
                                    STATE <= ST_AND;

                                OP_SUB:
                                    STATE <= ST_SUB;

                                OP_JR:
                                    STATE <= ST_JR;

				                OP_RTE:
				                    STATE <= ST_RTE;    
                            
                    
                            endcase

                        OP_ADDI:
                            STATE <= ST_ADDI;

                        OP_SLTI:
                            STATE <= ST_SLTI;

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
                
                ST_WAIT:
                    STATE <= ST_COMMON_0;

            endcase
        end
    end    
endmodule