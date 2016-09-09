library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity if_test is
port(
	-- Clock ins, SYS_CLK = 50MHz, USER_CLK = 24MHz 
	SYS_CLK : in std_logic;
	
	-- LED outs 
	USER_LED : out std_logic_vector(8 downto 1);


);

end entity if_test;


architecture arch of if_test is
begin
		
end architecture if_test;

