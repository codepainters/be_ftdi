/**
 * Copyright (c) 2016, Przemyslaw Wegrzyn <pwegrzyn@codepainters.com>
 * All rights reserved.
 *
 * This file is distributed under the Modified BSD License.
 * See LICENSE.txt for details.
 *
 * Sending test:
 * - randomize 1MB of data
 * - send it n times to FPGA, where n is given as command line parameter
 * - print CRC8 of the data (to be compated with LEDs on FPGA board) 
 * - print speed statistics every 5 seconds
 */

#include <unistd.h>
#include <ftdi.h>
#include <stdio.h>
#include <sys/time.h>
#include <fcntl.h>

#include "ft_fifo.h"
#include "crc8.h"

#define VID 0x1222
#define PID 0x1002

#define BUF_SIZE    (1024 * 1024)

static uint8_t buf[BUF_SIZE];

static const char *nibble[16] = {
        "0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111",
        "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111"
};


void prepare_randomized_data(uint8_t* buf, size_t size) {
    int urandom = open("/dev/urandom", O_RDONLY);
    if (urandom == -1) {
        fprintf(stderr, "Failed to open /dev/urandom, exiting.\n");
        exit(EXIT_FAILURE);
    }

    size_t total = 0;

    while (total < size) {
        ssize_t ret = read(urandom, buf, size - total);
        if (ret == -1) {
            fprintf(stderr, "Failed reading from /dev/urandom, exiting.\n");
            exit(EXIT_FAILURE);
        }
        total += ret;
    }

    close(urandom);
}

uint8_t precalc_crc(uint8_t *buf, size_t size, int ntimes) {
    crc_t crc = crc_init();

    for (int i = 0; i < ntimes; i++) {
        crc = crc_update(crc, buf, size);
    }
    return crc_finalize(crc);
}


int main(int argc, char **argv) {

    struct timeval start_time, last_time, current_time;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <megabytes_to_transfer>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    int n_times = atoi(argv[1]);

    printf("Randomizing test data...\n");
    prepare_randomized_data(buf, sizeof(buf));

    printf("Calculating CRC...\n");
    uint8_t local_crc = precalc_crc(buf, sizeof(buf), n_times);
    printf("CRC expected: %02x (bin: %s%s\n", local_crc, nibble[local_crc >> 4], nibble[local_crc & 0x0F]);

    struct ftdi_context *ftdi = ft_fifo_open(VID, PID);
    ft_fifo_flush_buffers(ftdi);

    printf("Go!\n");
    long bytes_sent = 0;
    gettimeofday(&start_time, NULL);
    last_time = start_time;

    // main test loop
    for (int i = 0; i < n_times; i++) {
        ft_fifo_write_bytes(ftdi, buf, BUF_SIZE);
        bytes_sent += BUF_SIZE;

        // print stats every 5 seconds
        gettimeofday(&current_time, NULL);
        if (current_time.tv_sec - last_time.tv_sec > 5) {
            last_time = current_time;

            double total_time = (double) (current_time.tv_usec - start_time.tv_usec) / 1000000 +
                                (double) (current_time.tv_sec - start_time.tv_sec);

            double mbps = ((double) bytes_sent) / (1024.0 * 1024.0) / total_time;

            printf("sent: %lu, speed: %0.2f MB/s\n", bytes_sent, mbps);
        }

    }

    exit(EXIT_SUCCESS);
}
