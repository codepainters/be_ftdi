BeFTDI
------

This simple FT232H-equipped interface adds USB connectivity
to the BeMicro MAX10 FPGA board.

It uses `FT232H` in synchronous FIFO mode.



Pin mapping
-----------

U5 connector:

| Pin # | FIFO | Be Micro   |
|-------|------|------------|
| 1     | D7   | PMOD\_A[0] |
| 2     | D6   | PMOD\_B[0] |
| 3     | D5   | PMOD\_A[1] |
| 4     | D4   | PMOD\_B[1] |
| 5     | D3   | PMOD\_A[2] |
| 6     | D2   | PMOD\_B[2] |
| 7     | D1   | PMOD\_A[3] |
| 8     | D0   | PMOD\_B[3] |

U6 connector:

| Pin # | FIFO  | Be Micro   |
|-------|-------|------------|
| 1     | ~TXE  | PMOD\_C[0] |
| 2     | ~RXF  | PMOD\_D[0] |
| 3     | ~WR   | PMOD\_C[1] |
| 4     | ~RD   | PMOD\_D[1] |
| 5     | CLK   | PMOD\_C[2] |
| 6     | ~SIWU | PMOD\_D[2] |
| 8     | ~OE   | PMOD\_D[3] |

