# RS232 Communication Interface
This repository contains the VHDL module and testbench codes for an RS232 communication interface. RS232 is a protocol for the interchange of serial binary data between two devices. It is a link used to connect DTE and DCE equipment for serial communication.

## Code Structure
- [Rs232Rxd.vhd](): This code contains the RS232 receiver design.
- [Rs232Txd.vhd](): This code contains the RS232 transmitter design.
- [RS232.vhd](): This code packs the RS232 receiver and transmitter into a single VHDL design.
- [TopLevelRS232.vhd](): This code  is the top-level design and includes three components, D4to7, Scan4Digit and RS232, so that it allows in-coming RS232 serial data to be received and displayed on 7-segment LEDs, while the 8-bit parallel data set by eight slide switches can be sent out over the RS232 cable.
- [D4to7.vhd](): This code converts the received binary code to a 7-segment representation.
- [scan4Digit.vhd](): This code send the four digits to four 7-segment displays.
- [tb_Rs232Rxd.vhd](): This code contains the testbench for the RS232 receiver design.
- [tb_Rs232Txd.vhd](): This code contains the testbench for the RS232 transmitter design.
- [tb_TopLevelRS232.vhd](): This code contains the testbench for the RS232 top-level design.

## Methodology
- ### Data Transmission
  The transmission of data is represented by a sequence of voltage levels. The voltage levels are output as either positive or negative, and utilizes a reference point of zero volts. Additionally, an internal clock signal is utilized for the synchronization of timing of which the bits are sent out.
  <br><br><img src="https://github.com/julianganjs/rs232-communication-interface/assets/127673790/ff7b5587-21ae-43fa-b15f-ac35adb27859" width="500vw"><br><br>
  A standard data packet is comprised of a single start bit, 8 message bits, one parity bit, and one stop bit. The start bit will always be a logic ‘0’, while the stop bit will always be a logic ‘1’. Within the message segment, the Least Significant Bit (LSB) precedes the Most Significant Bit (MSB). The signal also idles at a logic ‘1’ before start bit is sent.
- ### Receiver (RxD)
  <img src="https://github.com/julianganjs/rs232-communication-interface/assets/127673790/07f6298e-1343-42d0-8715-4ab1a6bbcd0e" width="500vw"><br><br>
  The RS232 receiver will first detect a falling edge in the RxD signal, which indicates that a start bit is present. This means that a data packet has been received by the RS232. Once detected, the internal signal “iClock1xEnable” will be asserted, and then counter for Clock1x will start along with the receiving process of each bit from the data packet. When “iClock1xEnable” switches to a logic ‘1’, the state will be updated from “stIdle” to “stData”.<br><br>
  An internal shift register, called “iShiftRegister”, is utilized to receive and store the bits from the data packet. Clock1x is used to ensure that the bits are stored according to the correct timing. When each bit is received one at a time, the receiver will first embed the bit at the MSB position of the shift register. Then, the 7th to 1st bit in the register will be shifted to the back. Through this process, the bits will be shifted one by one into the register from the MSB position to the LSB position, until all 8 bits have been stored. An internal counter called “iNoBitsReceived” will be used to keep track of the number of bits received.
  <br><br><img src="https://github.com/julianganjs/rs232-communication-interface/assets/127673790/413e1d29-11f2-4c38-b7a1-cbc6465641c0" width="350vw"><br><br>
  Once “iNoBitsReceived” reaches “1001”, the state changes to “stStop” and “iEnableDataOut” will be asserted. With “iEnableDataOut” at a logic ‘1’, the bits stored in the internal shift register will be sent to the output port. Then, the state will change to “stRxdCompleted”, and an internal reset signal will be asserted in order to restart the cycle, returning the receiver back to idle state.
- ### Transmistter (TxD)
  <img src="https://github.com/julianganjs/rs232-communication-interface/assets/127673790/f1733fe8-f431-4b51-8b21-d418b7bdb6f5" width="500vw"><br><br>
  If a HIGH signal is received at “Send”, “iClock1xEnable” will be asserted which enables “Clock1x” for bit shifting and output. If a HIGH signal is received at “Reset”, “iClock1xEnable” will be deasserted and the counter for “iClockDiv” will be reset to “0000”. An internal counter named “iNoBitsSent” is used to keep track of the number of bits sent out by the TxD output. When “iClock1xEnable” is deasserted, “iNoBitsSent” is reset to “0000” and the transmitter is set back to idle state.<br><br>
  If “Clock1x” is enabled, the process for storing the bits from “DataIn” and outputting them at “TxD” will begin. During the very first rising edge, the number of bits sent out will still be zero. This is also indicated in the counter “iNoBitsSent” as “0000”. At this stage, the 8-bit vector being received at “DataIn” will be concatenated with a ‘0’ bit at the LSB position for the start bit. This resultant 9-bit vector will be stored inside “iTxdBuffer”. These bits will then be outputted one by one at each clock cycle at the “Txd” port.<br><br>
  When all 9-bits in the data packet have been sent out, including the start bit, the “iNoBitsSent” counter will reach “1001”. At this stage, “iEnableTxdBuffer” will be deasserted and the state for the next clock cycle will be set to “stStop”. After that, the state will change to “stTxdCompleted” and an internal reset signal will be asserted in order to restart the cycle, returning the transmitter back to idle state to wait for the next “Send” signal.

## License
This project is licensed under the MIT License.
