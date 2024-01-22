----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:41:10 10/25/2023 
-- Design Name: 
-- Module Name:    Rs232Txd - Rs232Txd_Arch 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Rs232Txd is
	port( Reset, Send, Clock16x: in std_logic;
		DataIn: in std_logic_vector(7 downto 0);
		Txd: out std_logic);
end Rs232Txd;

architecture Rs232Txd_Arch of Rs232Txd is

	attribute enum_encoding: string;
	-- state definitions
	type stateType is (stIdle, stData, stStop, stTxdCompleted);
	attribute enum_encoding of stateType: type is "00 01 11 10";
	
	signal presState: stateType;
	signal nextState: stateType;
	signal iSend1, iSend2, iReset, iClock1xEnable, iEnableTxdBuffer: std_logic := '0';
	signal iTxdBuffer: std_logic_vector (8 downto 0) := (others=>'1');
	signal iClockDiv: std_logic_vector (3 downto 0) := "0000";
	signal iClock1x: std_logic := '0';
	signal iNoBitsSent: std_logic_vector (3 downto 0) := "0000";
	
begin
	
	process (Clock16x, Send, Reset)
	begin
	
	if Clock16x'event and Clock16x = '1' then
		if Reset = '1' or iReset = '1' then -- reset Clock1x
			iClock1xEnable <= '0';
			iClockDiv <= (others=>'0');
		else
			iSend1 <= Send;
			iSend2 <= iSend1;
		end if;
		
		if iSend1 = '1' and iSend2 = '0' then -- check for rising edge only in send signal, prevents data from sending too fast
			iClock1xEnable <= '1';
		end if;

		if iClock1xEnable <= '0' then
			iClockDiv <= (others=>'0'); -- reset iClockDiv when iClock1xEnable goes to '0'
			iClock1x <= iClockDiv(3);
		elsif iClock1xEnable <= '1' then
			iClockDiv <= iClockDiv + '1'; -- begin counter for Clock1x
			iClock1x <= iClockDiv(3);
		end if;
	end if;
	
	end process;
	
	process (iClock1xEnable, iClock1x)
	begin
	
	if iClock1xEnable = '0' then
		iNoBitsSent <= (others=>'0'); -- reset number of bits sent
		presState <= stIdle;
	elsif iClock1x'event and iClock1x = '1' then
		iNoBitsSent <= iNoBitsSent + '1'; --  start counter for number of bits sent
		presState <= nextState;
	end if;
	
	if iClock1x'event and iClock1x = '1' then
		if iNoBitsSent = "0000" then -- during first clock cycle when no bits are sent, store DataIn inside iTxdBuffer
			iTxdBuffer <= DataIn & '0'; -- concatenate DataIn with start bit '0'
		elsif iEnableTxdBuffer = '1' then 
			iTxdBuffer <=  '1' & iTxdBuffer(8 downto 1);	-- concatenate iTxdBuffer with '1' to ensure idle state is always high
		else
			iTxdBuffer <= (others=>'1'); -- reset iTxdBuffer
		end if;
	end if;
	
	end process;
	
	Txd <= iTxdBuffer(0); -- send LSB of iTxdBuffer to Txd output
	
	process (presState, iClock1xEnable, iNoBitsSent)
	begin
	
	-- signal defaults
	iReset <= '0';
	iEnableTxdBuffer <= '0'; -- set default value of iEnableTxdBuffer to '0'
	case presState is
		when stIdle =>
			if iClock1xEnable = '1' then
				nextState <= stData; -- only change state when iClock1x is enabled
			else
				nextState <= stIdle;
			end if;
		when stData =>
			if iNoBitsSent = "1001" then -- change state when all 9 bits have been sent
				nextState <= stStop;
			else
				iEnableTxdBuffer <= '1'; -- turn on iEnableTxdBuffer to send out bits
				nextState <= stData;
			end if;
		when stStop =>
			nextState <= stTxdCompleted;
		when stTxdCompleted =>
			iReset <= '1'; -- send iReset signal to restart the cycle and clear all signals
			nextState <= stIdle;
	end case;
	end process;

end Rs232Txd_Arch;