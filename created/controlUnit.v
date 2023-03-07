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

parameter ST_COMMON = 6'b000000;
parameter ST_ADD = 6'b000001;
parameter ST_RESET = 6'b111111;
parameter ST_SLL = 6'b000011;
parameter ST_SLLV = 6'b000111;
parameter ST_SLT = 6'b001111;
parameter ST_SLTI = 6'b011111;
parameter ST_SRA = 6'b000010;


parameter TYPE_R = 6'h0;

parameter OP_ADD = 6'h20;
parameter OP_SLL = 6'h0;
parameter OP_SLLV = 6'h4;
parameter OP_SLT = 6'h2a;
parameter OP_SLTI = 6'ha;
parameter OP_SRA = 6'h3;


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
                            TYPE_R: begin
                                case (funct)
                                    OP_ADD: begin
                                        STATE = ST_ADD;
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
                                endcase
                            end
                            
                            OP_SLTI: begin
                                STATE = ST_SLTI;
                            end
                        endcase
                    end
                end

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
                        muxSRControl = 3'b100; ///
                        muxSRNumSel = 2'b01; ///

                        COUNTER = COUNTER + 1;
                    end
                end

            default: begin
            end
        endcase
        end
    end

endmodule
