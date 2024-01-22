----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:03:36 11/07/2023 
-- Design Name: 
-- Module Name:    TopLevelRS232 - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TopLevelRS232 is
port ( Rxd: in std_logic;
							send,Reset: in std_logic;
							SystemClock: in std_logic;
							DataIn: in std_logic_vector (7 downto 0);
							An: out std_logic_vector (3 downto 0);
							Ca, Cb, Cc, Cd, Ce, Cf, Cg: out std_logic;
							Txd: out std_logic);
end TopLevelRS232;

architecture Behavioral of TopLevelRS232 is

component RS232 is
	port( Reset, Clock16x, Rxd, Send: in std_logic;
		DataIn: in std_logic_vector(7 downto 0);
		DataOut1: out std_logic_vector (7 downto 0);
		Txd: out std_logic);
end component;

component D4to7 is
    Port ( q : in  STD_LOGIC_VECTOR (3 downto 0);
           seg : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

component scan4Digit
	port ( digit3, digit2, digit1, digit0: in std_logic_vector(6 downto 0);
				clock: in std_logic; an : out std_logic_vector(3 downto 0);
				ca, cb, cc, cd, ce, cf, cg: out std_logic);
end component;

signal iClock : std_logic;
signal iReset : std_logic;

signal iDigitOut3, iDigitOut2, iDigitOut1, iDigitOut0: std_logic_vector (6 downto 0);
signal iDataOut1: std_logic_vector (7 downto 0);
signal iDataOut2: std_logic_vector (7 downto 0);

signal iClock16x: std_logic;
signal iCount9: std_logic_vector (8 downto 0) := "000000000";

begin

	process (SystemClock)
		begin
			if rising_edge(SystemClock) then
				if iCount9 = "101000101" then -- the divider is 325, or "101000101"
					iCount9 <= (others=>'0');
				else iCount9 <= iCount9 + '1';
				end if;
			end if;
	end process;

	iClock16x <= iCount9(8);

	iDataOut2 <= DataIn;

	U1: RS232 port map (
			Reset => Reset,
			Clock16x => iClock16x,
			Rxd => Rxd,
			Send => Send,
			DataIn => DataIn,
			DataOut1 => iDataOut1,
			Txd => Txd);
	U2: D4to7 port map (
			q => iDataOut1(3 downto 0),
			seg => iDigitOut0);
	U3: D4to7 port map (
			q => iDataOut1(7 downto 4),
			seg => iDigitOut1);
	U4: D4to7 port map (
			q => iDataOut2(3 downto 0),
			seg => iDigitOut2);
	U5: D4to7 port map (
			q => iDataOut2(7 downto 4),
			seg => iDigitOut3);
	U6: scan4Digit port map (
			digit3 => iDigitOut3,
			digit2 => iDigitOut2,
			digit1 => iDigitOut1,
			digit0 => iDigitOut0,
			clock => SystemClock,
			an => An,
			ca => Ca,
			cb => Cb,
			cc => Cc,
			cd => Cd,
			ce => Ce,
			cf => Cf,
			cg => Cg);

end Behavioral;

