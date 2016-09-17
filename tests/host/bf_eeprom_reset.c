/**
 * Helper tool clearing FT232H's configuration EEPROM.
 *
 * Once EEPROM is programmed, the device enumarates with different
 * VID/PID and FT_PROG utility no longer recognizes it. By clearing
 * EEPROM with this tool it's possible to start from scratch.
 */

#include <unistd.h>
#include <ftdi.h>
#include <stdio.h>

#include "ft_fifo.h"

#define VID 0x1222
#define PID 0x1002


int main() {
    int ret;
    int i;
    uint8_t b;
    struct ftdi_context *ftdi;

    ftdi = ft_fifo_open(VID, PID);
    ret = ftdi_erase_eeprom(ftdi);
    if (ret < 0) {
        fprintf(stderr, "libftdi: ftdi_erase_eeprom failed: %d (%s)\n", ret, ftdi_get_error_string(ftdi));
        ftdi_free(ftdi);
        exit(EXIT_FAILURE);
    }

    ftdi_free(ftdi);
    exit(EXIT_SUCCESS);
}