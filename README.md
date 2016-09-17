Be\_FTDI
========

Simple `FT232H`-based USB interface for the great [BeMicro Max10](https://www.arrow.com/en/products/bemicromax10/arrow-development-tools) FPGA board.  

It uses `FT232H` in synchronous FIFO mode. Upstream (FPGA -> USB) throughput achieved in testing:

 * PC (Ubuntu 16.04, kernel 4.4.0)  - 21.5 MB/s
 * MacBook Pro (OS X 10.10.5) - 25.7 MB/s

Downstream (USB -> FPGA) throughput:

 * TBD

See [tests](tests) directory for VHDL & C usage examples.
