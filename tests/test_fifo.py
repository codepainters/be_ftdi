#!/usr/bin/python

#
# Simple sync FIFO mode test (see VHDL files for further description).
# 

from pyftdi.ftdi import Ftdi
from time import sleep

VID=0x1222
PID=0x1002


def run_test():
    f = Ftdi()
    f.open(VID, PID, 0)

    f.write_data_set_chunksize(512)
    f.read_data_set_chunksize(512)
    f.purge_buffers()
    f.set_bitmode(0, Ftdi.BITMODE_SYNCFF)

    try:
        while True:
            # write 0 and 1 to reset the sequence generator
            print 'Writing...'
            f.write_data((0x00,))
            f.write_data((0x01,))

            # Read back 1MB of data
            print 'Reading...'
            d = f.read_data(1024 * 1024)
            print len(d)

            # wait before next try
            sleep(1)

    finally:
        f.close()


if __name__ == '__main__':
    run_test()

