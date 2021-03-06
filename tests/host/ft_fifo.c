/**
 * Copyright (c) 2016, Przemyslaw Wegrzyn <pwegrzyn@codepainters.com>
 * All rights reserved.
 *
 * This file is distributed under the Modified BSD License.
 * See LICENSE.txt for details.
 * 
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
        fprintf(stderr, "libftdi: cannot initialize!\n");
        exit(EXIT_FAILURE);
    }

    ret = ftdi_usb_open(ftdi, vid, pid);
    if (ret < 0) {
        fprintf(stderr, "libftdi: cannot open FTDI device: %d (%s)\n", ret, ftdi_get_error_string(ftdi));
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }

    ret = ftdi_set_bitmode(ftdi, 0xFF, BITMODE_SYNCFF);
    if (ret != 0) {
        fprintf(stderr, "libftdi: failed to set mode to Synchronous FIFO");
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }
    
    ret = ftdi_set_latency_timer(ftdi, 2);
    if (ret != 0) {
        fprintf(stderr, "libftdi: failed to set latency timer");
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }

    ret = ftdi_setflowctrl(ftdi, SIO_RTS_CTS_HS);
    if (ret != 0) {
        fprintf(stderr, "libftdi: failed to set flow control");
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }

    ret = ftdi_read_data_set_chunksize(ftdi, 0x10000);
    if (ret != 0) {
        fprintf(stderr, "libftdi: failed to set read chunk size");
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }

    ret = ftdi_write_data_set_chunksize(ftdi, 0x10000);
    if (ret != 0) {
        fprintf(stderr, "libftdi: failed to set write chunk size");
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }
    
    return ftdi;
}

void ft_fifo_write_bytes(struct ftdi_context* ftdi, uint8_t* buf, int size)
{
    // Note: ftdi_write_data() tries to send all the data before returning
    int ret = ftdi_write_data(ftdi, buf, size);
    if (ret < 0) {
        fprintf(stderr, "ftdi_write_data failed: %d (%s)\n", ret, ftdi_get_error_string(ftdi));
        exit(EXIT_FAILURE);
    }
}

void ft_fifo_write_byte(struct ftdi_context* ftdi, uint8_t b)
{
    ft_fifo_write_bytes(ftdi, &b, 1);
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

void ft_fifo_flush_buffers(struct ftdi_context* ftdi)
{
    int ret = ftdi_usb_purge_buffers(ftdi);
    if (ret != 0) {
        fprintf(stderr, "Failed to purge buffers");
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }
}

