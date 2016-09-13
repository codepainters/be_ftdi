/**
 * Common code for FT232H Sync FIFO mode.
 */

#include "ft_fifo.h"

#include <stdio.h>


struct ftdi_context* ft_fifo_open(int vid, int pid)
{
    int ret;
    struct ftdi_context *ftdi;

    ftdi = ftdi_new();
    if (!ftdi) {
        fprintf(stderr, "Cannot initialize libftdi\n");
        exit(EXIT_FAILURE);
    }

    ret = ftdi_usb_open(ftdi, vid, pid);
    if (ret < 0) {
        fprintf(stderr, "cannot open FTDI device: %d (%s)\n", ret, ftdi_get_error_string(ftdi));
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }

    ret = ftdi_set_bitmode(ftdi, 0xFF, BITMODE_SYNCFF);
    if (ret != 0) {
        fprintf(stderr, "Failed to set mode to Synchronous FIFO");
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }

    return ftdi;
}

void ft_fifo_write_byte(struct ftdi_context* ftdi, uint8_t b)
{
    int ret = ftdi_write_data(ftdi, &b, 1);
    if (ret < 0) {
        fprintf(stderr, "ftdi_write_data failed: %d (%s)\n", ret, ftdi_get_error_string(ftdi));
        exit(EXIT_FAILURE);
    }
}

int ft_fifo_read_bytes(struct ftdi_context* ftdi, uint8_t* buf, int buf_size)
{
    int ret = ftdi_read_data(ftdi, buf, buf_size);
    if (ret < 0) {
        fprintf(stderr, "ftdi_read_data failed: %d (%s)\n", ret, ftdi_get_error_string(ftdi));
        exit(EXIT_FAILURE);
    }

    return ret;
}
