SetActiveLib -work
comp -include "$dsn\src\vipram_package.vhd" 
comp -include "$dsn\src\node.vhd" 
comp -include "$dsn\src\smoosh.vhd" 
comp -include "$dsn\src\layer.vhd" 
comp -include "$dsn\src\road815.vhd" 
comp -include "$dsn\src\backend.vhd" 
comp -include "$dsn\src\vipram815.vhd" 
comp -include "$dsn\src\TestBench\vipram815_TB.vhd" 
asim +access +r TESTBENCH_FOR_vipram815 
wave 
wave -noreg clock
wave -noreg eoe
wave -noreg load
wave -noreg layer
wave -noreg pattern
wave -noreg addr

# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\vipram815_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_vipram815 

run 2000 ns
#run 350000 ns
