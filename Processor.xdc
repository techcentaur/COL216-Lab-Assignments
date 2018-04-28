## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# Clock signal
Bank = 34, Pin name = ,	Sch name = CLK100MHZ
	set_property PACKAGE_PIN W5 [get_ports clk]
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]

# Switches
set_property PACKAGE_PIN V17 [get_ports reg_num[0]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_num[0]]

set_property PACKAGE_PIN V16 [get_ports reg_num[1]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_num[1]]

set_property PACKAGE_PIN W16 [get_ports reg_num[2]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_num[2]]

set_property PACKAGE_PIN W17 [get_ports reg_num[3]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_num[3]]

set_property PACKAGE_PIN U16 [get_ports reg_out[0]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[0]]

set_property PACKAGE_PIN E19 [get_ports reg_out[1]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[1]]

set_property PACKAGE_PIN U19 [get_ports reg_out[2]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[2]]

set_property PACKAGE_PIN V19 [get_ports reg_out[3]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[3]]

set_property PACKAGE_PIN W18 [get_ports reg_out[4]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[4]]

set_property PACKAGE_PIN U15 [get_ports reg_out[5]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[5]]

set_property PACKAGE_PIN U14 [get_ports reg_out[6]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[6]]

set_property PACKAGE_PIN V14 [get_ports reg_out[7]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[7]]

set_property PACKAGE_PIN V13 [get_ports reg_out[8]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[8]]

set_property PACKAGE_PIN V3 [get_ports reg_out[9]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[9]]

set_property PACKAGE_PIN W3 [get_ports reg_out[10]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[10]]

set_property PACKAGE_PIN U3 [get_ports reg_out[11]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[11]]

set_property PACKAGE_PIN P3 [get_ports reg_out[12]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[12]]

set_property PACKAGE_PIN N3 [get_ports reg_out[13]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[13]]

set_property PACKAGE_PIN P1 [get_ports reg_out[14]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[14]]

set_property PACKAGE_PIN L1 [get_ports reg_out[15]]
set_property IOSTANDARD LVCMOS33 [get_ports reg_out[15]]

#Push Buttons
#set_property PACKAGE_PIN W19 [get_ports reset]
#set_property IOSTANDARD LVCMOS33 [get_ports reset]

#set_property PACKAGE_PIN T17 [get_ports push]
#set_property IOSTANDARD LVCMOS33 [get_ports push]



# Others (BITSTREAM, CONFIG)
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]


