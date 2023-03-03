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
    output reg rstOut
);

//Variables
reg [5:0] COUNTER;
reg [5:0] STATE;

parameter ST_COMMON = 6'b000000;
parameter ST_ADD = 6'b000001;
parameter ST_RESET = 6'b111111;

    initial begin
        rstOut = 1'b1;
        STATE = ST_ADD;
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

                rstOut = 1'b1;

            end
        end
        else begin
            case (STATE)
                ST_COMMON: begin
                    if (COUNTER < 6'd3) begin
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

                        rstOut = 1'b0;

                        COUNTER = COUNTER + 1;

                    end
                    else if (COUNTER == 6'd3 || COUNTER == 6'd4) begin

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

                        rstOut = 1'b0;

                        COUNTER = COUNTER + 1;
                    end
                    else if (COUNTER == 6'd5) begin
                        muxAluSrcA = 3'b000;
                        muxAluSrcB = 3'b011;
                        aluOP = 3'b001;
                    end
                end
            default: begin
                

            end
            endcase
            
        end
    end

endmodule

