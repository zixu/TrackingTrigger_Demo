SetActiveLib -work
comp -include "$dsn\src\Bank_load.vhd" 
comp -include "$dsn\src\DAQ.vhd" 
comp -include "$dsn\src\input_FPGA.vhd" 
comp -include "$dsn\src\input_FPGA_TestBench\input_fpga_TB.vhd" 
asim +access +r TESTBENCH_FOR_input_fpga 
wave 
wave -noreg CLOCK
wave -noreg EN_pattern
wave -noreg EN_DAQ
wave -noreg LOAD_pattern
wave -noreg EOE_DAQ
wave -noreg LAYER7_BX
wave -noreg LAYER6_BX
wave -noreg LAYER5_BX
wave -noreg LAYER4_BX
wave -noreg LAYER3_BX
wave -noreg LAYER2_BX
wave -noreg LAYER1_BX
wave -noreg LAYER0_BX
wave -noreg LAYER7
wave -noreg LAYER6
wave -noreg LAYER5
wave -noreg LAYER4
wave -noreg LAYER3
wave -noreg LAYER2
wave -noreg LAYER1
wave -noreg LAYER0


# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\input_FPGA_TestBench\input_fpga_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_input_fpga 
											 
run 2000 ns
