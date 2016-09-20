library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity fpga_ds is
port(
	-- Clock ins, SYS_CLK = 50MHz, USER_CLK = 24MHz 
	SYS_CLK : in std_logic;
	
	-- LED outs 
	USER_LED : out std_logic_vector(8 downto 1);

	-- push buttons (active low)
	PB : in std_logic_vector(4 downto 1);
	
	-- inputs from BE_FTDI
	f_CLK : in std_logic;
	f_nRXF : in std_logic;
	f_nTXE : in std_logic;

	-- outputs to BE_FTDI
	f_nOE : out std_logic;
	f_nWR : out std_logic;
	f_nRD : out std_logic;
	f_nSIWU : out std_logic;

	-- bidirectional data bus
	f_D : inout std_logic_vector(7 downto 0)
);

end entity fpga_ds;

architecture arch of fpga_ds is

	component crc8
		port(clk  : in  std_logic;
			 rst  : in  std_logic;
			 strb : in  std_logic;
			 d    : in  std_logic_vector(7 downto 0);
			 crc  : out std_logic_vector(7 downto 0));
	end component crc8;
	
	signal crc : std_logic_vector(7 downto 0);
	
begin
	
	crc8_inst : crc8
		port map(
			clk  => f_CLK,
			rst  => not PB(1),
			strb => not f_nRXF,
			d    => f_D,
			crc  => crc
		);

	-- just show CRC on LEDs	
	USER_LED <= not crc;	
	
	-- we always accept data
	f_nRD <= '0';
	
    -- no writing (towards PC)
	f_nWR <= '1';
		 
	-- enable FTDI outputs whenever in s_read state
	f_nOE <= '0';
		
	-- no use for short packet, but we have to pull it up
	f_nSIWU <= '1';
		
end architecture arch;

