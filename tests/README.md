Be\_FTDI tests
==============

 * `fpga_ds` - Quartus II project (VHDL) for downstream (host -> FPGA) transfer test
 * `fpga_us` - Quartus II project (VHDL) for upstream (FPGA -> host) transfer test
 * `host` - host-side test code (cmake and libftdi required)

Host-side tests include the following binaries:

 * `bf_leds` - simple blinking LEDs write test (use with `fpga_us`)
 * `bf_rxfifo` - upstream transfer test (use with `fpga_us`)
 * `bf_txfifo` - downstream transfer test (use with `fpga_ds`)
 * `bf_eeprom_reset` - helper to reset configuration EEPROM contents

For upstream test FPGA sends a sequence of bytes which is verified by the host. Throughput/error statistics are printed on the console every 5 seconds, test continues until interrupted.

For downstream test host sends randomized data to FPGA, which calculates CRC8 and displays it on the board LEDs. CRC has to be compared "manually" with the expected value printed on the host console. Test continues until a given number of megabytes is transferred (command line argument).

For details see source code comments.

Note: the on-board EEPROM has to be programmed once before using the board using `FT_PROG` tool from FTDI. See the hardware folder.

