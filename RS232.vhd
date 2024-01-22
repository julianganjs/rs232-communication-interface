----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:28:50 10/25/2023 
-- Design Name: 
-- Module Name:    RS232 - RS232_Arch 
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

entity RS232 is
	port( Reset, Clock16x, Rxd, Send: in std_logic;
		DataIn: in std_logic_vector(7 downto 0);
		DataOut1: out std_logic_vector (7 downto 0);
		Txd: out std_logic);
end RS232;

architecture RS232_Arch of RS232 is

	component Rs232Rxd
		port( Reset, Clock16x, Rxd: in std_logic;
			DataOut1: out std_logic_vector (7 downto 0));
	end component;

	component Rs232Txd
		port( Reset, Send, Clock16x: in std_logic;
			DataIn: in std_logic_vector(7 downto 0);
			Txd: out std_logic);
	end component;
	
begin

	u1: Rs232Rxd port map(
		Reset => Reset,
		Clock16x => Clock16x,
		Rxd => Rxd,
		DataOut1 => DataOut1);
		
	u2: Rs232Txd port map(
		Reset => Reset,
		Send => Send,
		Clock16x => Clock16x,
		DataIn => DataIn,
		Txd => Txd);
		
end RS232_Arch;