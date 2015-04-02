SetActiveLib -work				 
comp -include "$dsn\src\testbench.vhd" 
asim +access +r TESTBENCH_FOR_TrackingTrigger
wave
wave -noreg CLOCK	 	
wave -noreg EN_pattern
wave -noreg EN_DAQ             
wave -noreg LOAD_pattern
wave -noreg DOUT_pattern 
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

wave -noreg EOE
wave -noreg load 
wave -noreg layer
wave -noreg addr              
wave -noreg pattern             
  
run 20000 ns
#run 140000 ns
#run 670000 ns
