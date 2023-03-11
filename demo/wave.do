onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
add wave -noupdate -radix decimal -radixshowbase 1 /cpu/PC_/Saida
add wave -noupdate -radix unsigned /cpu/CONTROL_UNIT_/opcode
add wave -noupdate -radix unsigned /cpu/CONTROL_UNIT_/funct
add wave -noupdate -radix unsigned /cpu/CONTROL_UNIT_/COUNTER
add wave -noupdate -radix unsigned /cpu/CONTROL_UNIT_/STATE
add wave -noupdate -radix unsigned /cpu/CONTROL_UNIT_/aluOP
add wave -noupdate -radix decimal /cpu/MUX_ALUSrc_A_/saida
add wave -noupdate -radix unsigned /cpu/MUX_ALUSrc_A_/sel
add wave -noupdate -radix decimal /cpu/MUX_ALUSrc_B_/saida
add wave -noupdate -radix decimal /cpu/ULA_/A
add wave -noupdate -radix decimal /cpu/ULA_/B
add wave -noupdate -label {SAIDA ULA} -radix decimal /cpu/ULA_/S
add wave -noupdate /cpu/ULA_/Seletor
add wave -noupdate -radix decimal /cpu/ALU_OUT_/Entrada
add wave -noupdate -radix decimal /cpu/ALU_OUT_/Saida
add wave -noupdate -radix unsigned /cpu/ALU_OUT_/Load
add wave -noupdate -radix unsigned /cpu/CONTROL_UNIT_/AluOutWrite
add wave -noupdate /cpu/REG_A_/Load
add wave -noupdate -radix decimal /cpu/REG_A_/Entrada
add wave -noupdate -radix decimal /cpu/REG_A_/Saida
add wave -noupdate -radix decimal /cpu/REG_B_/Entrada
add wave -noupdate -radix decimal /cpu/REG_B_/Saida
add wave -noupdate -label {REG BASE 1} -radix decimal /cpu/REG_BASE_/ReadData1
add wave -noupdate -label {REG BASE 2} -radix decimal /cpu/REG_BASE_/ReadData2
add wave -noupdate /cpu/MUX_ALUSrc_B_/sel
add wave -noupdate /cpu/reset
add wave -noupdate /cpu/clk
add wave -noupdate -radix unsigned -childformat {{/cpu/REG_BASE_/Cluster(0) -radix unsigned} {/cpu/REG_BASE_/Cluster(1) -radix unsigned} {/cpu/REG_BASE_/Cluster(2) -radix unsigned} {/cpu/REG_BASE_/Cluster(3) -radix unsigned} {/cpu/REG_BASE_/Cluster(4) -radix unsigned} {/cpu/REG_BASE_/Cluster(5) -radix unsigned} {/cpu/REG_BASE_/Cluster(6) -radix unsigned} {/cpu/REG_BASE_/Cluster(7) -radix unsigned} {/cpu/REG_BASE_/Cluster(8) -radix unsigned} {/cpu/REG_BASE_/Cluster(9) -radix unsigned} {/cpu/REG_BASE_/Cluster(10) -radix unsigned} {/cpu/REG_BASE_/Cluster(11) -radix unsigned} {/cpu/REG_BASE_/Cluster(12) -radix unsigned} {/cpu/REG_BASE_/Cluster(13) -radix unsigned} {/cpu/REG_BASE_/Cluster(14) -radix unsigned} {/cpu/REG_BASE_/Cluster(15) -radix unsigned} {/cpu/REG_BASE_/Cluster(16) -radix unsigned} {/cpu/REG_BASE_/Cluster(17) -radix unsigned} {/cpu/REG_BASE_/Cluster(18) -radix unsigned} {/cpu/REG_BASE_/Cluster(19) -radix unsigned} {/cpu/REG_BASE_/Cluster(20) -radix unsigned} {/cpu/REG_BASE_/Cluster(21) -radix unsigned} {/cpu/REG_BASE_/Cluster(22) -radix unsigned} {/cpu/REG_BASE_/Cluster(23) -radix unsigned} {/cpu/REG_BASE_/Cluster(24) -radix unsigned} {/cpu/REG_BASE_/Cluster(25) -radix unsigned} {/cpu/REG_BASE_/Cluster(26) -radix unsigned} {/cpu/REG_BASE_/Cluster(27) -radix unsigned} {/cpu/REG_BASE_/Cluster(28) -radix unsigned} {/cpu/REG_BASE_/Cluster(29) -radix unsigned} {/cpu/REG_BASE_/Cluster(30) -radix unsigned} {/cpu/REG_BASE_/Cluster(31) -radix unsigned}} -subitemconfig {/cpu/REG_BASE_/Cluster(0) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(1) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(2) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(3) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(4) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(5) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(6) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(7) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(8) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(9) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(10) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(11) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(12) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(13) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(14) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(15) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(16) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(17) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(18) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(19) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(20) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(21) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(22) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(23) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(24) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(25) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(26) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(27) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(28) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(29) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(30) {-height 15 -radix unsigned} /cpu/REG_BASE_/Cluster(31) {-height 15 -radix unsigned}} /cpu/REG_BASE_/Cluster
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
add wave -noupdate /cpu/REG_BASE_/WriteData
add wave -noupdate /cpu/REG_BASE_/WriteReg
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
add wave -noupdate /cpu/MUX_REG_DST_/sel
add wave -noupdate -radix binary /cpu/MUX_REG_DST_/instruction_1
add wave -noupdate -radix binary /cpu/MUX_REG_DST_/instruction_2
add wave -noupdate -radix binary /cpu/MUX_REG_DST_/instruction_3
add wave -noupdate -radix decimal /cpu/MUX_REG_DST_/saida
add wave -noupdate /cpu/IR_/Instr25_21
add wave -noupdate /cpu/IR_/Instr20_16
add wave -noupdate /cpu/IR_/Instr15_0
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
add wave -noupdate -radix decimal /cpu/MEM_/Address
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
add wave -noupdate -radix decimal /cpu/MUX_ALUSrc_B_/b
add wave -noupdate -radix decimal /cpu/MUX_ALUSrc_B_/sign_extend
add wave -noupdate -radix decimal /cpu/MUX_ALUSrc_B_/sign_left
add wave -noupdate /cpu/MUX_ALUSrc_B_/sel
add wave -noupdate -radix decimal /cpu/MUX_ALUSrc_B_/saida
add wave -noupdate /cpu/clk
add wave -noupdate /cpu/reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1011 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 257
configure wave -valuecolwidth 138
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {670 ps} {1296 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern clock -initialvalue 1 -period 100ps -dutycycle 50 -starttime 0ps -endtime 4000ps sim:/cpu/clk 
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 4000ps sim:/cpu/reset 
wave edit change_value -start 0ps -end 52ps -value 1 Edit:/cpu/reset 
WaveCollapseAll -1
wave clipboard restore