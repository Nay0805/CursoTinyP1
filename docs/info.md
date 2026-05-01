## How it works

Este proyecto implementa un UART de entrada serial. El dato recibido por la línea serial es almacenado en un registro, el cual genera una salida paralela de 8 bits.

## How to test

The project includes a testbench that automatically verifies the UART receiver and output register operation.

Test procedure:

1. Initialize all inputs to zero.
2. Generate the system clock and reset signal.
3. Send serial data through the UART input line.
4. Simulate a complete UART frame, including:
   - Start bit
   - 8 data bits
   - Stop bit
5. Wait for the UART receiver to finish receiving the byte.
6. Verify that the received 8-bit data is correctly stored in the output register.
7. Observe the output `q_o` and confirm that it matches the transmitted serial byte.

Simulation waveform files are generated using:

- `tb.vcd`

These waveforms can be viewed using GTKWave or another VCD waveform viewer.

## External hardware

No external hardware is required for simulation.

For real hardware implementation, an external UART transmitter or USB-to-serial adapter can be used to send serial data to the FPGA or target board.
