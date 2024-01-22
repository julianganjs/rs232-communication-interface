----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:51:18 11/07/2023 
-- Design Name: 
-- Module Name:    D4to7 - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity D4to7 is
    Port ( q : in  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0));
end D4to7;

architecture Behavioral of D4to7 is

begin

seg<= "1111110" when q = "00000" else
		"0110000" when q = "000001" else
		"1101101" when q = "000010" else
		"1111001" when q = "00011" else
		"0110011" when q = "00100" else
		"1011011" when q = "00101" else
		"1011111" when q = "00110" else
		"1110000" when q = "00111" else
		"1111111" when q = "01000" else
		"1111011" when q = "01001" else
		"1110111" when q = "01010" else
		"0011111" when q = "01011" else
		"1001110" when q = "01100" else
		"0111101" when q = "01101" else
		"1001111" when q = "01110" else
		"1000111" when q = "01111" else
		"0000000";

end Behavioral;

