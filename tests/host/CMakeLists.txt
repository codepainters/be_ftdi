cmake_minimum_required(VERSION 3.5)
project(be_ftdi)

add_executable(bf_leds ft_fifo.c bf_leds.c)
target_link_libraries(bf_leds ftdi)

add_executable(bf_rxfifo ft_fifo.c bf_rxfifo.c)
target_link_libraries(bf_rxfifo ftdi)

add_executable(bf_txfifo ft_fifo.c bf_txfifo.c crc8.c)
target_link_libraries(bf_txfifo ftdi)

add_executable(bf_eeprom_reset ft_fifo.c bf_eeprom_reset.c)
target_link_libraries(bf_eeprom_reset ftdi)