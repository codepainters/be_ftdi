BeFTDI
------

This simple FT232H-equipped interface adds USB connectivity
to the BeMicro MAX10 FPGA board.

It uses `FT232H` in synchronous FIFO mode.



Pin mapping
-----------

U5 connector:

| Pin # | FIFO | Be Micro  |
|-------|------|-----------|
| 1     | D7   | PMOD_A[1] |
| 2     | D6   | PMOD_B[1] |
| 3     | D5   | PMOD_A[2] |
| 4     | D4   | PMOD_B[2] |
| 5     | D3   | PMOD_A[3] |
| 6     | D2   | PMOD_B[3] |
| 7     | D1   | PMOD_A[4] |
| 8     | D0   | PMOD_B[4] |

U6 connector:

| Pin # | FIFO  | Be Micro  |
|-------|-------|-----------|
| 1     | ~TXE  | PMOD_C[1] |
| 2     | ~RXF  | PMOD_D[1] |
| 3     | ~WR   | PMOD_C[2] |
| 4     | ~RD   | PMOD_D[2] |
| 5     | CLK   | PMOD_C[3] |
| 6     | ~SIWU | PMOD_D[3] |
| 8     | ~OE   | PMOD_D[4] |
