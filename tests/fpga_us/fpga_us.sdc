## Generated SDC file "fpga_us.out.sdc"

## Copyright (C) 1991-2016 Altera Corporation. All rights reserved.
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, the Altera Quartus Prime License Agreement,
## the Altera MegaCore Function License Agreement, or other 
## applicable license agreement, including, without limitation, 
## that your use is for the sole purpose of programming logic 
## devices manufactured by Altera and sold by Altera or its 
## authorized distributors.  Please refer to the applicable 
## agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 16.0.0 Build 211 04/27/2016 SJ Lite Edition"

## DATE    "Wed Sep 14 18:14:45 2016"

##
## DEVICE  "10M08DAF484C8GES"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3

#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {f_CLK} -period 16.666 -waveform { 0.000 8.333 } [get_ports {f_CLK}]

#**************************************************************
# Create Generated Clock
#**************************************************************


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

# max 9ns after clock edge
set_input_delay -add_delay -max -clock [get_clocks {f_CLK}]  9.000 [get_ports {f_nTXE}]
set_input_delay -add_delay -min -clock [get_clocks {f_CLK}]  0.000 [get_ports {f_nTXE}]

set_input_delay -add_delay -max -clock [get_clocks {f_CLK}]  9.000 [get_ports {f_nRXF}]
set_input_delay -add_delay -min -clock [get_clocks {f_CLK}]  0.000 [get_ports {f_nRXF}]

#**************************************************************
# Set Output Delay
#**************************************************************

# 7.5ns setup time, no hold time, ignoring clock propagation time 
set_output_delay -add_delay -min -clock [get_clocks {f_CLK}]  0.000 [get_ports {f_nWR}]
set_output_delay -add_delay -max -clock [get_clocks {f_CLK}]  7.500 [get_ports {f_nWR}]

set_output_delay -add_delay -min -clock [get_clocks {f_CLK}]  0.000 [get_ports {f_D}]
set_output_delay -add_delay -max -clock [get_clocks {f_CLK}]  7.500 [get_ports {f_D}]

set_output_delay -add_delay -min -clock [get_clocks {f_CLK}]  0.000 [get_ports {f_nRD}]
set_output_delay -add_delay -max -clock [get_clocks {f_CLK}]  7.500 [get_ports {f_nRD}]

set_output_delay -add_delay -min -clock [get_clocks {f_CLK}]  0.000 [get_ports {f_nSIWU}]
set_output_delay -add_delay -max -clock [get_clocks {f_CLK}]  7.500 [get_ports {f_nSIWU}]

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************


#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

