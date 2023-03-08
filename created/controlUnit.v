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
    output reg [2:0] aluOP,
    output reg [2:0] muxIord,
    output reg [2:0] muxAluSrcA,
    output reg [2:0] muxAluSrcB,
    output reg [2:0] muxRegDst,
    output reg [2:0] muxMemToReg,
    output reg [2:0] muxPCSource,
    output reg [1:0] muxSRInputSel,
    output reg [2:0] muxSRControl;
    output reg [1:0] muxSRNumSel;
    output reg rstOut
);

//Variables
reg [5:0] COUNTER;
reg [5:0] STATE;

// definir os estados
parameter ST_COMMON = 6'b000000;
parameter ST_ADD = 6'b000001; // 1
parameter ST_AND = 6'b000010; // 2
parameter ST_SUB = 6'b001110; // 14
parameter ST_ADDI = 6'b010010; // 18
parameter ST_ADDIU = 6'b010011; // 19
parameter ST_RESET = 6'b111111;

parameter ST_SLL = 6'b001000; // 8
parameter ST_SLLV = 6'b001001; // 9 
parameter ST_SLT = 6'b001010; // 10
parameter ST_SRA = 6'b001011; // 11 
parameter ST_SRAV = 6'b001100; // 12
parameter ST_SLTI = 6'b011111; // 31


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

                        COUNTER = COUNTER + 1;
                    end
                end

            default: begin
            end
        endcase
        end
    end

endmodule
