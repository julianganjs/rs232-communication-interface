--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:17:31 11/07/2023
-- Design Name:   
-- Module Name:   /home/ise/Desktop/Workspace/rs232_lab/tb_TopLevelRS232.vhd
-- Project Name:  rs232_lab
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: TopLevelRS232
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_TopLevelRS232 IS
END tb_TopLevelRS232;
 
ARCHITECTURE behavior OF tb_TopLevelRS232 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TopLevelRS232
    PORT(
         Rxd : IN  std_logic;
         send : IN  std_logic;
         Reset : IN  std_logic;
         SystemClock : IN  std_logic;
         DataIn : IN  std_logic_vector(7 downto 0);
         An : OUT  std_logic_vector(3 downto 0);
         Ca : OUT  std_logic;
         Cb : OUT  std_logic;
         Cc : OUT  std_logic;
         Cd : OUT  std_logic;
         Ce : OUT  std_logic;
         Cf : OUT  std_logic;
         Cg : OUT  std_logic;
         Txd : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal tb_rxd : std_logic := '0';
   signal tb_send : std_logic := '0';
   signal tb_reset : std_logic := '0';
   signal tb_systemclock : std_logic := '0';
   signal tb_DataIn : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal tb_an : std_logic_vector(3 downto 0);
   signal tb_ca : std_logic;
   signal tb_cb : std_logic;
   signal tb_cc : std_logic;
   signal tb_cd : std_logic;
   signal tb_ce : std_logic;
   signal tb_cf : std_logic;
   signal tb_cg : std_logic;
   signal tb_txd : std_logic;

   -- Clock period definitions
   constant period : time := 6.5 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TopLevelRS232 PORT MAP (
          Rxd => tb_rxd,
          send => tb_send,
          Reset => tb_reset,
          SystemClock => tb_systemclock,
          DataIn => tb_DataIn,
          An => tb_an,
          Ca => tb_ca,
          Cb => tb_cb,
          Cc => tb_cc,
          Cd => tb_cd,
          Ce => tb_ce,
          Cf => tb_cf,
          Cg => tb_cg,
          Txd => tb_txd
        );

   -- Clock process definitions
   process
   begin
		tb_systemclock <= '1';
		wait for period/2;
		tb_systemclock <= '0';
		wait for period/2;
   end process;
 
	-- produce reset signal
	process
	begin
		tb_reset <= '1';
		wait for 300*period;
		tb_reset <= '0';
		wait;
	end process;
	
	-- produce enable signal
	process
	begin
	
		tb_rxd <= '1';
		wait for 5.5*period;
		tb_rxd <= '0'; -- Start bit
		wait for 16*period;
		tb_rxd <= '0'; -- Bit 0
		wait for 16*period;
		tb_rxd <= '1'; -- Bit 1
		wait for 16*period;
		tb_rxd <= '0'; -- Bit 2
		wait for 16*period;
		tb_rxd <= '0'; -- Bit 3
		wait for 16*period;
		tb_rxd <= '0'; -- Bit 4
		wait for 16*period;
		tb_rxd <= '1'; -- Bit 5
		wait for 16*period;
		tb_rxd <= '1'; -- Bit 6
		wait for 16*period;
		tb_rxd <= '0'; -- Bit 7
		wait for 16*period;
		tb_rxd <= '1'; -- Stop bit
		wait for 16*period;
		wait;
	
	end process;
	
	-- produce Send signal
	process
	begin
		tb_send <= '0';
		wait for 500*period;
		tb_send <= '1';
		wait for 100000*period;
		tb_send <= '0';
		wait for 500*period;
		tb_send <= '1';
		wait for 500*period;
		tb_send <= '0';
		wait;
	end process;
	
	-- produce reset signal
	process
		begin
		tb_dataIn <= x"62";
		wait;
	end process;
   
END;
