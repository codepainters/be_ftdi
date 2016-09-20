#include <unistd.h>
#include <ftdi.h>
#include <stdio.h>
#include <sys/time.h>

#include "ft_fifo.h"

#pragma clang diagnostic ignored "-Wmissing-noreturn"

#define VID 0x1222
#define PID 0x1002

// recommended buffer size is n * 510 
#define BUF_SIZE    (2048 * 510)

static const uint8_t test_data[23] = {
        0xFF, 0x00, 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80,
        0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01, 0xAA, 0x55, 0x00,
        0xAA, 0x00, 0x55
};

static uint8_t buf[BUF_SIZE];


int main() {
    int i;
    int ret;
    int seq_ptr;
    long errors;
    long bytes_received;
    struct timeval start_time, last_time, current_time;


    struct ftdi_context *ftdi = ft_fifo_open(VID, PID);

    // write 0x00 to stop and reset the generator, then 0x01 to start it again
    ft_fifo_write_byte(ftdi, 0x00);
    ft_fifo_flush_buffers(ftdi);
    ft_fifo_write_byte(ftdi, 0x01);

    seq_ptr = 0;
    errors = 0;
    bytes_received = 0;
    gettimeofday(&start_time, NULL);
    last_time = start_time;

    // main test loop
    for (;;) {
        ret = ft_fifo_read_bytes(ftdi, buf, sizeof(buf));
        // printf("%d\n", ret);

        // sequence validation
        for (i = 0; i < ret; i++) {
            if (test_data[seq_ptr] != buf[i]) {
                // printf("offs: %lu, exp. 0x%02x - got 0x%02x \n", bytes_received + i, test_data[seq_ptr], buf[i]);
                errors++;
            }
            seq_ptr = (seq_ptr + 1) % sizeof(test_data);
        }

        bytes_received += ret;

        // print stats every 5 seconds
        gettimeofday(&current_time, NULL);
        if (current_time.tv_sec - last_time.tv_sec > 5) {
            last_time = current_time;

            double total_time = (double) (current_time.tv_usec - start_time.tv_usec) / 1000000 +
                                (double) (current_time.tv_sec - start_time.tv_sec);

            double mbps = ((double) bytes_received) / (1024.0 * 1024.0) / total_time;

            printf("received: %lu, errors: %lu, speed: %0.2f MB/s\n", bytes_received, errors, mbps);
        }

    }
}
