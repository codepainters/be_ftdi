/**
 * Common code for FT232H Sync FIFO mode.
 *
 * Note: all errors are printed to stderr, and exit() is called.
 * This code is for testing purposes only, so failing fast is
 * perfectly OK.
 */

#include <ftdi.h>

/**
 * Open FT232H chip with a given VID/PID and switch it
 * to synchronous FIFO mode.
 *
 * @return ftdi_context pointer
 */
struct ftdi_context* ft_fifo_open(int vid, int pid);

/**
 * Write a single byte to FT232H FIFO.
 *
 * @param ftdi  interface context
 * @param b     byte to write
 */
void ft_fifo_write_byte(struct ftdi_context* ftdi, uint8_t b);

/**
 * Receive data from FT232H FIFO.
 */
int ft_fifo_read_bytes(struct ftdi_context* ftdi, uint8_t* buf, int buf_size);

/**
 * Flush RX/TX buffers.
 */
void ft_fifo_flush_buffers(struct ftdi_context* ftdi);

