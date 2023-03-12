// Autor: Douglas Gemir
// Data: 11/03/2023
// Descrição: Este algoritmo calcula a divisão de dois números recebidos

module div (
    input clk,
    input signed[31:0] dividendo,
    input signed[31:0] divisor,
    input reset,
    output reg signed [31:0] mflo,
    output reg signed [31:0] mfhi,
    output reg excessao,
    input div_init,
    output reg div_end
);

    reg signed [31:0] quociente;
    reg signed [63:0] resto;
    reg signed [31:0] DIVIDENDO;
    reg signed [63:0] DIVISOR;
    integer count;
    reg negative_dividendo;
    reg negative_divisor;

    always @(posedge clk or negedge reset) begin
        if (reset == 1) begin
            quociente = 0;
            count = 0;
            DIVIDENDO = 0;
            DIVISOR = 0;
            resto = 0;
            negative_dividendo = 0;
            negative_divisor = 0;
            excessao = 0;
        end

        else begin 
            if (div_end == 1 & count != 33) begin
                div_end = 0;
            end
                
            if (div_init == 1) begin
                quociente = 0;
                count = 0;
                DIVIDENDO = 0;
                DIVISOR = 0;
                DIVIDENDO = dividendo;
                DIVISOR[63:32] = divisor;
                resto = 0;
                resto[31:0] = dividendo;
                negative_dividendo = 0;
		        negative_divisor = 0;

                if (divisor == 0) begin
                    excessao = 1;
                end

                else begin
                    excessao = 0;
                end

                if(DIVIDENDO < 0 & divisor < 0)begin
                    resto[31:0] = (~DIVIDENDO)+1;
		            DIVISOR = 0;
                    DIVISOR[63:32] = (~divisor)+1;
                    negative_divisor = 1;
                    negative_dividendo = 1;
                end

                else if (DIVIDENDO < 0) begin
                    resto[31:0] = (~DIVIDENDO)+1;
                    negative_dividendo = 1;
                    end
                    
                else if(divisor < 0) begin
		            DIVISOR = 0;
                    DIVISOR[63:32] = (~divisor)+1;
                    negative_divisor = 1;
                end
            end

            if (excessao == 0) begin
                resto = resto - DIVISOR;

                if (resto >= 0) begin
                    quociente = quociente <<< 1;
                    quociente[0] = 1;
                end

                else if(resto < 0) begin
                    resto = resto + DIVISOR;
                    quociente = quociente <<< 1;
                    quociente[0] = 0;
                end

                DIVISOR = DIVISOR >>> 1;
                count = count + 1;  

                if (count == 33) begin
                    if (negative_divisor == 1 & negative_dividendo == 1)begin
                        resto[31:0] = (~resto[31:0])+1;
                    end

                    else if (negative_divisor == 1) begin
                        quociente = (~quociente)+1;
                    end

                    else if(negative_dividendo == 1)begin
                        resto[31:0] = (~resto[31:0])+1;
                        quociente = (~quociente)+1;
                    end

                    mfhi = resto[31:0];
                    mflo = quociente;
                    div_end = 1;
                    count = 0;
                    excessao = 0;
                end
            end
            
        end
    end
endmodule