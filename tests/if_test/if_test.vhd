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

	type fsm_state is (s_idle, s_read, s_write);
	signal state : fsm_state := s_idle;

	-- set to 1 to enable counter
	signal counter_en : std_logic := '0';

	-- any writes from USB goes to this register
	signal wr_reg : std_logic_vector(7 downto 0);
	
	-- counter - generates test sequence
	signal count : unsigned(7 downto 0);
	
begin

	-- show written value on LEDs
	USER_LED <= wr_reg;

	counter : process(f_CLK) is
	begin
		if rising_edge(f_CLK) then
			if counter_en = '1' and state = s_write and f_nTXE = '0' then
				count <= count + 1;
			else
				count <= to_unsigned(0, count'length);
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
				elsif counter_en = '1' and f_nTXE = '0' then 
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
					counter_en <= f_D(0);
				end if;

			when s_write =>
				-- write from FPGA perspective, i.e. FPGA -> FTDI -> USB 
				-- abort if there is pending read (higher prio), or FIFO is full
				if f_nRXF = '0' or f_nTXE = '1' then
					state <= s_idle;
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
	f_nWR <= '0' when counter_en = '1' and state = s_write and f_nTXE = '0' else '1';
	 
	-- drive outputs in s_write mode
	f_D <= std_logic_vector(count) when state = s_write else (others => 'Z');
		
end architecture arch;

