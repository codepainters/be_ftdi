library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity if_test is
port(
	-- Clock ins, SYS_CLK = 50MHz, USER_CLK = 24MHz 
	SYS_CLK : in std_logic;
	
	-- LED outs 
	USER_LED : out std_logic_vector(8 downto 1);

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

end entity if_test;

architecture arch of if_test is

	-- array of test data  
	type byte_table is array(integer range <>) of std_logic_vector(7 downto 0);

	-- this sequence of 23 bytes is continuously writen to FTDI FIFO, it contains
	-- moving 1 test + flipping most/all bits at once, to detect signalling issues.
	-- Length is a prime number, to avoid starting sequence from 0 on each 
	-- USB transaction.
	constant test_data : byte_table(0 to 22) := (
		X"FF", X"00", X"01", X"02", X"04", X"08", X"10", X"20", X"40", X"80",
		X"40", X"20", X"10", X"08", X"04", X"02", X"01", X"AA", X"55", X"00",
		X"AA", X"00", X"55" 
	);

	type fsm_state is (s_idle, s_read, s_write, s_write_ws);
	signal state : fsm_state := s_idle;

	-- set to 1 to enable counter
	signal counter_en : boolean;

    -- signal controlling the counter
	signal count_strb : boolean;

	-- any writes from USB goes to this register
	signal wr_reg : std_logic_vector(7 downto 0);
	
	-- counter - indexes test sequence
	signal count : integer range 0 to test_data'high := 0;
	
	-- signal dbg1 : std_logic;
	-- signal dbg2 : std_logic;
	-- signal dbg3 : std_logic;
	-- signal dbg4 : std_logic;
	
begin
	
	-- various debug signals, uncoment if in troubles :)
	-- dbg1 <= '0' when counter_en = '1' and state = s_write and f_nTXE = '0' else '1';
	-- dbg2 <= '0' when counter_en = '1' else '1';
	-- dbg3 <= '0' when state = s_write  else '1';
	-- dbg4 <= '0' when f_nTXE = '0' else '1';

	--  USER_LED <= (1 => dbg1, 2 => dbg2, 3 => dbg3, 4 => dbg4, others => '1');
	
	USER_LED <= not wr_reg;
		
    counter_en <= wr_reg(0) = '1';
    count_strb <= counter_en and state = s_write and f_nTXE = '0';

	counter : process(f_CLK) is
	begin
		if rising_edge(f_CLK) then
			if count_strb then
				if count < test_data'high then
					count <= count + 1;
				else 
					count <= 0;
				end if;					
			else
				count <= 0;
			end if;
		end if;
	end process;

	fifo_fsm : process(f_CLK) is
	begin
		if rising_edge(f_CLK) then
			case state is
			
			when s_idle =>
				-- is there anything to read? let's make reads higher prio
				if f_nRXF = '0' then
					state <= s_read;
				-- otherwise, can we start writing?	
				elsif counter_en and f_nTXE = '0' then 
					state <= s_write;
				end if;  

			when s_read =>
				-- read from FPGA perspective, i.e. USB -> FTDI -> FPGA 
				if f_nRXF = '1' then
					-- stop when FIFO is empty
					state <= s_idle;
				else
					-- latch next value, f_nRD is controlled with separate statement 
					wr_reg <= f_D;
				end if;

			when s_write =>
				-- write from FPGA perspective, i.e. FPGA -> FTDI -> USB 
				-- abort if there is pending read (higher prio)
				if f_nRXF = '0' then
					state <= s_idle;
				else if f_nTXE = '1' then
					-- FIFO full, enter wait state
					state <= s_write_ws;
				end if;	
					
			when s_write_ws =>
				if f_nRXF = '0' then
					-- abort if there is pending read (higher prio)
					state <= s_idle;
				else if f_nTXE = '0' then
					-- FTDI ready for more data go back to s_write
		 			state <= s_write;
				end if;
					
			when others =>
				state <= s_idle;
			end case;
			

		end if;
	end process;
		
	-- enable FTDI outputs whenever in s_read state
	f_nOE <= '0' when state = s_read else '1';
	
	-- we always accept data when in s_read (i.e. no wait cycles)
	f_nRD <= '0' when state = s_read else '1';
	
	-- no wait states writing from the counter, eihter
    -- note: f_nTXE only gates the counter, f_nWR is low all the time
    -- counting is enabled and we are writing to FTDI
	f_nWR <= '0' when counter_en and state = s_write else '1';
	 
	-- drive outputs in s_write mode
	f_D <= test_data(count) when state = s_write else (others => 'Z');
		
	-- no use for short packet, but we have to pull it up
	f_nSIWU <= '1';
		
end architecture arch;

