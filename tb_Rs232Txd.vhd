--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   07:50:15 11/01/2023
-- Design Name:   
-- Module Name:   /home/ise/Desktop/Workspace/rs232_lab/tb_Rs232Txd.vhd
-- Project Name:  rs232_lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Rs232Txd
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_Rs232Txd IS
END tb_Rs232Txd;
 
ARCHITECTURE behavior OF tb_Rs232Txd IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Rs232Txd
    PORT(
         Reset : IN  std_logic;
         Send : IN  std_logic;
         Clock16x : IN  std_logic;
         DataIn : IN  std_logic_vector(7 downto 0);
         Txd : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Reset : std_logic := '0';
   signal Send : std_logic := '0';
   signal Clock16x : std_logic := '0';
   signal DataIn : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal Txd : std_logic;

   -- Clock period definitions
   constant Clock16x_period : time := 6.5 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Rs232Txd PORT MAP (
          Reset => Reset,
          Send => Send,
          Clock16x => Clock16x,
          DataIn => DataIn,
          Txd => Txd
        );

   -- Clock process definitions
   Clock16x_process :process
   begin
		Clock16x <= '0';
		wait for Clock16x_period/2;
		Clock16x <= '1';
		wait for Clock16x_period/2;
   end process;
 

   -- Txd stimulus
	-- produce Send signal
   process
   begin		
		Send <= '0';
		wait for 5*Clock16x_period;
		Send <= '1';
		wait for 50*Clock16x_period;
		Send <= '0';
		wait for 150*Clock16x_period;
		Send <= '1';
		wait for 10*Clock16x_period;
		Send <= '0';
		wait;
		
   end process;
	
	-- Txd Data
   process
   begin		
		DataIn <= "11000101";
		wait for 150*Clock16x_period;
		DataIn <= "00101011";
		wait;
   end process;

END;
