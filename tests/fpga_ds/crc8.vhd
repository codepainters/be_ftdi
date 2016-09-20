library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity crc8 is
	port(
		clk  : in  std_logic;
		-- asynchronous reset
		rst  : in  std_logic;
		-- if '1', byte from d is added to CRC
		strb : in  std_logic;
		d    : in  std_logic_vector(7 downto 0);

		-- calculated CRC output
		crc  : out std_logic_vector(7 downto 0)
	);

end entity crc8;

architecture arch of crc8 is
	signal reg : std_logic_vector(7 downto 0);
	
	type crc_table_t is array(0 to 255) of std_logic_vector(7 downto 0);
	constant crc_table : crc_table_t:= (
        x"00", x"d5", x"7f", x"aa", x"fe", x"2b", x"81", x"54", x"29", x"fc", x"56", x"83", x"d7", x"02", x"a8", x"7d",
        x"52", x"87", x"2d", x"f8", x"ac", x"79", x"d3", x"06", x"7b", x"ae", x"04", x"d1", x"85", x"50", x"fa", x"2f",
        x"a4", x"71", x"db", x"0e", x"5a", x"8f", x"25", x"f0", x"8d", x"58", x"f2", x"27", x"73", x"a6", x"0c", x"d9",
        x"f6", x"23", x"89", x"5c", x"08", x"dd", x"77", x"a2", x"df", x"0a", x"a0", x"75", x"21", x"f4", x"5e", x"8b",
        x"9d", x"48", x"e2", x"37", x"63", x"b6", x"1c", x"c9", x"b4", x"61", x"cb", x"1e", x"4a", x"9f", x"35", x"e0",
        x"cf", x"1a", x"b0", x"65", x"31", x"e4", x"4e", x"9b", x"e6", x"33", x"99", x"4c", x"18", x"cd", x"67", x"b2",
        x"39", x"ec", x"46", x"93", x"c7", x"12", x"b8", x"6d", x"10", x"c5", x"6f", x"ba", x"ee", x"3b", x"91", x"44",
        x"6b", x"be", x"14", x"c1", x"95", x"40", x"ea", x"3f", x"42", x"97", x"3d", x"e8", x"bc", x"69", x"c3", x"16",
        x"ef", x"3a", x"90", x"45", x"11", x"c4", x"6e", x"bb", x"c6", x"13", x"b9", x"6c", x"38", x"ed", x"47", x"92",
        x"bd", x"68", x"c2", x"17", x"43", x"96", x"3c", x"e9", x"94", x"41", x"eb", x"3e", x"6a", x"bf", x"15", x"c0",
        x"4b", x"9e", x"34", x"e1", x"b5", x"60", x"ca", x"1f", x"62", x"b7", x"1d", x"c8", x"9c", x"49", x"e3", x"36",
        x"19", x"cc", x"66", x"b3", x"e7", x"32", x"98", x"4d", x"30", x"e5", x"4f", x"9a", x"ce", x"1b", x"b1", x"64",
        x"72", x"a7", x"0d", x"d8", x"8c", x"59", x"f3", x"26", x"5b", x"8e", x"24", x"f1", x"a5", x"70", x"da", x"0f",
        x"20", x"f5", x"5f", x"8a", x"de", x"0b", x"a1", x"74", x"09", x"dc", x"76", x"a3", x"f7", x"22", x"88", x"5d",
        x"d6", x"03", x"a9", x"7c", x"28", x"fd", x"57", x"82", x"ff", x"2a", x"80", x"55", x"01", x"d4", x"7e", x"ab",
        x"84", x"51", x"fb", x"2e", x"7a", x"af", x"05", x"d0", x"ad", x"78", x"d2", x"07", x"53", x"86", x"2c", x"f9"
    );

begin
	crc_update : process(clk)
	begin
		if rst = '1' then
				reg <= x"00";
		elsif rising_edge(clk) then
			if strb = '1' then
				reg <= crc_table(to_integer(unsigned(reg xor d)));
			end if;
		end if;
	end process;

	crc <= reg;

end architecture;