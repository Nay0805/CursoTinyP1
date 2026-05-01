module Comparador (
  input  wire [3:0] bit_REGISTRO,  // 4 bits desde registro UART
  input  wire [3:0] bit_LFSR,      // 4 bits desde registro LFSR
  output wire igual                 // 1 si los 4 bits son iguales
);

  assign igual = (bit_REGISTRO == bit_LFSR);

endmodule