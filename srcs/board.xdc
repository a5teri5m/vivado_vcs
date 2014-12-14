
# Clock
set_property PACKAGE_PIN W5 [get_ports clk]							
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]


## Switches
set_property PACKAGE_PIN V17 [get_ports {sw[0]}]					
set_property PACKAGE_PIN V16 [get_ports {sw[1]}]					
set_property PACKAGE_PIN W16 [get_ports {sw[2]}]					
set_property PACKAGE_PIN W17 [get_ports {sw[3]}]					
set_property PACKAGE_PIN W15 [get_ports {sw[4]}]					
set_property PACKAGE_PIN V15 [get_ports {sw[5]}]					
set_property PACKAGE_PIN W14 [get_ports {sw[6]}]					
set_property PACKAGE_PIN W13 [get_ports {sw[7]}]					
set_property PACKAGE_PIN V2 [get_ports {sw[8]}]					
set_property PACKAGE_PIN T3 [get_ports {sw[9]}]					
set_property PACKAGE_PIN T2 [get_ports {sw[10]}]					
set_property PACKAGE_PIN R3 [get_ports {sw[11]}]					
set_property PACKAGE_PIN W2 [get_ports {sw[12]}]					
set_property PACKAGE_PIN U1 [get_ports {sw[13]}]					
set_property PACKAGE_PIN T1 [get_ports {sw[14]}]					
set_property PACKAGE_PIN R2 [get_ports {sw[15]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {sw[*]}]

## LEDs
set_property PACKAGE_PIN U16 [get_ports {led[0]}]					
set_property PACKAGE_PIN E19 [get_ports {led[1]}]					
set_property PACKAGE_PIN U19 [get_ports {led[2]}]					
set_property PACKAGE_PIN V19 [get_ports {led[3]}]					
set_property PACKAGE_PIN W18 [get_ports {led[4]}]					
set_property PACKAGE_PIN U15 [get_ports {led[5]}]					
set_property PACKAGE_PIN U14 [get_ports {led[6]}]					
set_property PACKAGE_PIN V14 [get_ports {led[7]}]					
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]


