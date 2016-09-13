#include <unistd.h>
#include <ftdi.h>

#include "ft_fifo.h"

#define VID 0x1222
#define PID 0x1002


int main() {
    int ret;
    int i;
    uint8_t b;
    struct ftdi_context *ftdi;

    ftdi = ft_fifo_open(VID, PID);

    // endless disco
    b = 0;
    for(;;) {
        ft_fifo_write_byte(ftdi, b++);
        usleep(500000);
    }
}