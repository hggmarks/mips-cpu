module control_unit (
    input wire clk,
    input wire rst,
    input wire overflow,
    input wire [5:0] opcode,
    input wire [5:0] funct,
    input wire excessao,
    output reg PCWrite,
    output reg memRW, //memRead and memWrite
    output reg IRWrite,
    output reg RegWrite,
    output reg [2:0] aluOP,
    output reg [2:0] muxIord,
    output reg [2:0] muxAluSrcA,
    output reg [2:0] muxAluSrcB,
    output reg [2:0] muxRegDst,
    output reg [2:0] muxMemToReg,
    output reg [2:0] muxPCSource,
    output reg [1:0] muxSRInputSel,
    output reg [2:0] muxSRControl,
    output reg [1:0] muxSRNumSel,
    output reg [1:0] storeSize,
    output reg [1:0] loadSize,
    output reg  HiWrite,
    output reg  LoWrite,
    output reg MultDiv,
    output reg EPCWrite,

    output reg rstOut
);

//Variables
reg [5:0] COUNTER;
reg [5:0] STATE;

// definir os estados
parameter ST_COMMON = 6'b000000;
parameter ST_ADD = 6'b000001; // 1 felix
parameter ST_AND = 6'b000010; // 2 vitor
parameter ST_SUB = 6'b001110; // 14 vitor
parameter ST_BREAK = 6'b001111; //15 daniel
parameter ST_ADDI = 6'b010010; // 18 vitor
parameter ST_ADDIU = 6'b010011; // 19 vitor
parameter ST_RESET = 6'b111111;

parameter ST_SLL = 6'b001000; // 8 iti
parameter ST_SLLV = 6'b001001; // 9 iti
parameter ST_SLT = 6'b001010; // 10 iti
parameter ST_SRA = 6'b001011; // 11  iti
parameter ST_SRAV = 6'b001100; // 12 iti
parameter ST_SRL = 6'b001101; //13 iti
parameter ST_LB = 6'b011001; //25 daniel
parameter ST_LH = 6'b011010; //26 daniel
parameter ST_LW = 6'b011100; //28 daniel
parameter ST_SLTI = 6'b011111; // 31 iti
parameter ST_SW = 6'b100000; // 32 iti
parameter ST_MFHI = 6'b000110; //6 Dodo 
parameter ST_MFLO = 6'b000111; //7 Dodo
parameter ST_MULT = 6'b000100; //4 Dodo
parameter ST_DIV = 6'b000011; //3 Dodo


// definir os OPCODES
parameter TYPE_R = 6'h0;

parameter OP_ADD = 6'h20;
parameter OP_AND = 6'h24;
parameter OP_SUB = 6'h22;
parameter OP_ADDI = 6'h8;
parameter OP_ADDIU = 6'h9;
parameter OP_SLL = 6'h0;
parameter OP_SLLV = 6'h4;
parameter OP_SLT = 6'h2a;
parameter OP_SLTI = 6'ha;
parameter OP_SRA = 6'h3;
parameter OP_SRAV = 6'h7;
parameter OP_SRL = 6'h2;
parameter OP_SW = 6'h2b;
parameter OP_BREAK = 6'hd;
parameter OP_LB = 6'h20;
parameter OP_LH = 6'h21;
parameter OP_MFHI = 6'h10;
parameter OP_MFLO = 6'h12;
parameter OP_MULT = 6'h18;
parameter OP_DIV = 6'h1a;


    initial begin
        rstOut = 1'b1;
        STATE = ST_COMMON;
    end

    always @(posedge clk) begin
        if (rst == 1'b1) begin
            if (STATE != ST_RESET)  begin
                STATE = ST_RESET;
                COUNTER = 6'b000000;

                PCWrite = 1'b0;
                memRW = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b0; ///
                aluOP = 3'b000;
                muxIord = 3'b000;
                muxAluSrcA = 3'b000;
                muxAluSrcB = 3'b000;
                muxRegDst = 3'b000; ///
                muxMemToReg = 3'b000; ///
                muxPCSource = 3'b000;
                muxSRInputSel = 2'b00;
                muxSRControl = 3'b000;
                muxSRNumSel = 2'b00;
                storeSize = 2'b00;
                loadSize = 2'b00;
                HiWrite = 1'b0;
                LoWrite = 1'b0;
                MultDiv = 1'b0;
                EPCWrite = 1'b0;

                rstOut = 1'b1;

            end
            else begin

                STATE = ST_COMMON;
                COUNTER = 6'b000000;

                PCWrite = 1'b0;
                memRW = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b1; ///
                aluOP = 3'b000;
                muxIord = 3'b000;
                muxAluSrcA = 3'b000;
                muxAluSrcB = 3'b000;
                muxRegDst = 3'b100; ///
                muxMemToReg = 3'b000; ///
                muxPCSource = 3'b000;
                muxSRInputSel = 2'b00;
                muxSRControl = 3'b000;
                muxSRNumSel = 2'b00;
                storeSize = 2'b00;
                loadSize = 2'b00;
                HiWrite = 1'b0;
                LoWrite = 1'b0;
                MultDiv = 1'b0;
                EPCWrite = 1'b0;

                rstOut = 1'b1;

            end
        end
        else begin
            case (STATE)
                ST_COMMON: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_COMMON;

                        PCWrite = 1'b0;
                        memRW = 1'b0; ///
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000;
                        muxIord = 3'b000; ///
                        muxAluSrcA = 3'b000;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;
                        rstOut = 1'b0;

                        COUNTER = COUNTER + 1;

                    end
                    else if (COUNTER == 6'd1) begin

                        STATE = ST_COMMON;

                        PCWrite = 1'b1; ///
                        memRW = 1'b0;
                        IRWrite = 1'b1; ///
                        RegWrite = 1'b0;
                        aluOP = 3'b001; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; ///
                        muxAluSrcB = 3'b001; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000; ///
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;
                        rstOut = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd2) begin
                        PCWrite = 1'b1;
                        memRW = 1'b0;
                        IRWrite = 1'b1;
                        RegWrite = 1'b0;
                        aluOP = 3'b001; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; ///
                        muxAluSrcB = 3'b011; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        rstOut = 1'b0;
                        COUNTER = 6'b000000;

                        case (opcode)
                            TYPE_R: begin //instruções do tipo R vem mudar o OPCODE pra FUNC aqui

                                case (funct)
                                    OP_ADD: begin
                                        STATE = ST_ADD;
                                    end
                                    OP_AND: begin
                                        STATE = ST_AND;
                                    end
                                    OP_SUB: begin
                                        STATE = ST_SUB;
                                    end
                                    OP_SLL: begin
                                        STATE = ST_SLL;
                                    end
                                    OP_SLLV: begin
                                        STATE = ST_SLLV;
                                    end
                                    OP_SLT: begin
                                        STATE = ST_SLT;
                                    end
                                    OP_SRA: begin
                                        STATE = ST_SRA;
                                    end
                                    OP_SRAV: begin
                                        STATE = ST_SRAV;
                                    end
                                    OP_SRL: begin
                                        STATE = ST_SRL;
                                    end
                                    OP_BREAK: begin
                                        STATE = ST_BREAK;
                                    end
                                    OP_MFHI: begin
                                        STATE = ST_MFHI;
                                    end
                                    OP_MFLO: begin
                                        STATE = ST_MFLO;
                                    end
                                    OP_MULT: begin
                                        STATE = ST_MULT;
                                    end
                                    OP_DIV: begin
                                        STATE = ST_DIV;
                                    end
                                

                                endcase
                            end
                            // instruções que nao são do tipo R nao precisam mudar o OPCODE
                            OP_SLTI: begin
                                STATE = ST_SLTI;
                            end
                            OP_ADDI: begin
                                STATE = ST_ADDI;
                            end
                            OP_ADDIU: begin
                                STATE = ST_ADDIU;
                            end
                            OP_SW: begin
                                STATE = ST_SW;
                            end
                            OP_LB: begin
                                STATE = ST_LB;
                            end
                            OP_LH: begin
                                STATE = ST_LH;
                            end
                            OP_LW: begin
                                STATE = ST_LW;
                            end

                        endcase
                    end
                end
                // oq realmente vai acontecer em cada função
                ST_ADD: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_ADD;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b001; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010; ///
                        muxAluSrcB = 3'b000; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1 || COUNTER == 6'd2) begin

                        if (COUNTER == 6'd2) begin
                            STATE = ST_COMMON;
                        end
                        else begin
                            STATE = ST_ADD;
                        end

                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b001;
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b010; ///
                        muxMemToReg = 3'b110; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_AND: begin
                    if(COUNTER == 6'd0) begin
                        STATE = ST_AND;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b011; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010; ///
                        muxAluSrcB = 3'b000; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1 || COUNTER == 6'd2) begin

                        if (COUNTER == 6'd2) begin
                            STATE = ST_COMMON;
                        end
                        else begin
                            STATE = ST_AND;
                        end

                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b001;
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b010; ///
                        muxMemToReg = 3'b110; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_SUB: begin
                    if(COUNTER == 6'd0) begin
                        STATE = ST_SUB;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b010; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010; ///
                        muxAluSrcB = 3'b000; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1 || COUNTER == 6'd2) begin

                        if (COUNTER == 6'd2) begin
                            STATE = ST_COMMON;
                        end
                        else begin
                            STATE = ST_SUB;
                        end

                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b001;
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b010; ///
                        muxMemToReg = 3'b110; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_BREAK: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b1; ///
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b010; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; ///
                        muxAluSrcB = 3'b001; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b001; ///
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_ADDI: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_ADDI;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b001; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010; ///
                        muxAluSrcB = 3'b010; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1 || COUNTER == 6'd2) begin

                        if (COUNTER == 6'd2) begin
                            STATE = ST_COMMON;
                        end
                        else begin
                            STATE = ST_ADDI;
                        end

                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b001;
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b010; ///
                        muxMemToReg = 3'b110; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_ADDIU: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_ADDIU;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b001; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010; ///
                        muxAluSrcB = 3'b010; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1 || COUNTER == 6'd2) begin

                        if (COUNTER == 6'd2) begin
                            STATE = ST_COMMON;
                        end
                        else begin
                            STATE = ST_ADDIU;
                        end

                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b001;
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b010; ///
                        muxMemToReg = 3'b110; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_SLL: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_SLL;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b01; ///
                        muxSRControl = 3'b001; ///
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if(COUNTER == 6'd1) begin
                        STATE = ST_SLL;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b010; ///
                        muxSRNumSel = 2'b01; ///
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if(COUNTER == 6'd2) begin

                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b100; ///
                        muxMemToReg = 3'b010; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00; 
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_SLLV: begin
                    if (COUNTER == 6'd0) begin

                        STATE = ST_SLLV;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b01; ///
                        muxSRControl = 3'b001; ///
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if(COUNTER == 6'd1) begin

                        STATE = ST_SLLV;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b010; ///
                        muxSRNumSel = 2'b00; ///
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if(COUNTER == 6'd2) begin

                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b100; ///
                        muxMemToReg = 3'b010; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00; 
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_SLT: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_SLT;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b111; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b100; ///
                        muxAluSrcB = 3'b000; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end

                    else if (COUNTER == 6'd1) begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000; /// 
                        muxMemToReg = 3'b101; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_SLTI: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_SLTI;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b111; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b100; ///
                        muxAluSrcB = 3'b100; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1) begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;  ///
                        muxMemToReg = 3'b101; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end
                
                ST_SRA: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_SRA;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b01; ///
                        muxSRControl = 3'b001; ///
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1) begin
                        STATE = ST_SRA;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;  
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b100; ///
                        muxSRNumSel = 2'b01; ///
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd2) begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b100;  ///
                        muxMemToReg = 3'b010; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00; 
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_SRAV:begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_SRAV;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b01; ///
                        muxSRControl = 3'b001; ///
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1) begin
                        STATE = ST_SRAV;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;  
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b100; ///
                        muxSRNumSel = 2'b01; ///
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd2) begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b100;  ///
                        muxMemToReg = 3'b010; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00; 
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_SRL: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_SRL;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b10; ///
                        muxSRControl = 3'b001; ///
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1) begin
                        STATE = ST_SRL;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;  
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b011; ///
                        muxSRNumSel = 2'b01; ///
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd2) begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b100;  ///
                        muxMemToReg = 3'b010; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00; 
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_SW: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_SW;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b001; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010; ///
                        muxAluSrcB = 3'b010; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b11; //
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1) begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b1; ///
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b000; 
                        muxIord = 3'b001; ///
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_LB: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_LB;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b001; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010; ///
                        muxAluSrcB = 3'b010; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1 || COUNTER == 6'd2) begin

                        STATE = ST_LB;
                        PCWrite = 1'b0;
                        memRW = 1'b0; ///
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000;
                        muxIord = 3'b001; ///
                        muxAluSrcA = 3'b000;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b000; 
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd3) begin

                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0; 
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b000;
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b000; ///
                        muxMemToReg = 3'b100; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b01; ///
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_LH: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_LH;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b001; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010; ///
                        muxAluSrcB = 3'b010; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1 || COUNTER == 6'd2) begin

                        STATE = ST_LH;
                        PCWrite = 1'b0;
                        memRW = 1'b0; ///
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000;
                        muxIord = 3'b001; ///
                        muxAluSrcA = 3'b000;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b000; 
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd3) begin

                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0; 
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b000;
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b000; ///
                        muxMemToReg = 3'b100; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b10; ///
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_LW: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_LW;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        aluOP = 3'b001; ///
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b010; ///
                        muxAluSrcB = 3'b010; ///
                        muxRegDst = 3'b000;
                        muxMemToReg = 3'b000;
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd1 || COUNTER == 6'd2) begin

                        STATE = ST_LW;
                        PCWrite = 1'b0;
                        memRW = 1'b0; ///
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000;
                        muxIord = 3'b001; ///
                        muxAluSrcA = 3'b000;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b000; 
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd3) begin

                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0; 
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b000;
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000;
                        muxAluSrcB = 3'b000;
                        muxRegDst = 3'b000; ///
                        muxMemToReg = 3'b100; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00;
                        muxSRControl = 3'b000;
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00;
                        loadSize = 2'b11; ///
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end
                ST_MFHI: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b001; ///
                        muxMemToReg = 3'b011; ///
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_MFLO: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b1; ///
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b001; /// 
                        muxMemToReg = 3'b010; /// 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0;
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_MULT: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_MULT;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000; 
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b0; ///
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end

                    else if (COUNTER == 6'd1)begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000; 
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b1; ///
                        LoWrite = 1'b1; ///
                        MultDiv = 1'b0; 
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

                ST_DIV: begin
                    if (COUNTER == 6'd0) begin
                        STATE = ST_DIV;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000; 
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        MultDiv = 1'b1; ///
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end

                    else if (COUNTER == 6'd1 & excessao == 0)begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; 
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000; 
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b1; ///
                        LoWrite = 1'b1; ///
                        MultDiv = 1'b0; 
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end

                    else if (COUNTER == 6'd1 & excessao == 1)begin
                        STATE = ST_DIV;
                        PCWrite = 1'b0;
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b010; /// 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000; ///
                        muxAluSrcB = 3'b001; /// 
                        muxRegDst = 3'b000; 
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b0; 
                        LoWrite = 1'b0;
                        MultDiv = 1'b0; 
                        EPCWrite = 1'b1; ///

                        COUNTER = COUNTER + 1;
                    end

                    else if ((COUNTER == 6'd2 & excessao == 1) || (COUNTER == 6'd3 & excessao == 1))begin
                        STATE = ST_DIV;
                        PCWrite = 1'b0;
                        memRW = 1'b0; ///
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b101; ///
                        muxAluSrcA = 3'b000;
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000; 
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000;
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b0; 
                        LoWrite = 1'b0;
                        MultDiv = 1'b0; 
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end

                    else if (COUNTER == 6'd4 & excessao == 1)begin
                        STATE = ST_COMMON;
                        PCWrite = 1'b1; ///
                        memRW = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0; 
                        aluOP = 3'b000; 
                        muxIord = 3'b000;
                        muxAluSrcA = 3'b000;
                        muxAluSrcB = 3'b000; 
                        muxRegDst = 3'b000; 
                        muxMemToReg = 3'b000; 
                        muxPCSource = 3'b000; ///
                        muxSRInputSel = 2'b00; 
                        muxSRControl = 3'b000; 
                        muxSRNumSel = 2'b00;
                        storeSize = 2'b00; 
                        loadSize = 2'b00;
                        HiWrite = 1'b0; 
                        LoWrite = 1'b0;
                        MultDiv = 1'b0; 
                        EPCWrite = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                end

            default: begin
            end
        endcase
        end
    end

endmodule