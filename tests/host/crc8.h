/**
 * CRC8 calculator
 *
 * Generated with:
 * pycrc.py --width 8 --poly 0xd5 --reflect-in False --xor-in 0x00 --reflect-out False
 * --xor-out 0x00 --generate=c --algorithm table-driven
 */

#ifndef __CRC8_H__
#define __CRC8_H__

#include <stdlib.h>
#include <stdint.h>

typedef uint8_t crc_t;


static inline crc_t crc_init(void) {
    return 0x00;
}

crc_t crc_update(crc_t crc, const void *data, size_t data_len);

static inline crc_t crc_finalize(crc_t crc) {
    return crc ^ 0x00;
}

#endif
