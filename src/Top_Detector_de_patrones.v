module Top_Detector_de_patrones (
  input  wire       clk,
  input  wire       rst,
  input  wire [7:0] bit_REGISTRO,   // viene de ui_in
  input  wire [7:0] bit_LFSR,       // viene de uio_in
  input  wire       pulso,          // o lo generás internamente
  output wire [3:0] leds
);

  wire igual_alto;
  wire igual_bajo;
  wire flag;

  Comparador u_cmp_bajo (
    .bit_REGISTRO (bit_REGISTRO[3:0]),
    .bit_LFSR     (bit_LFSR[3:0]),
    .igual        (igual_bajo)
  );

  Comparador u_cmp_alto (
    .bit_REGISTRO (bit_REGISTRO[7:4]),
    .bit_LFSR     (bit_LFSR[7:4]),
    .igual        (igual_alto)
  );

  FSM_DETECTOR u_fsm (
    .clk        (clk),
    .rst        (rst),
    .Pulso      (pulso),
    .Igual_alto (igual_alto),
    .Igual_bajo (igual_bajo),
    .flag       (flag)
  );

  assign leds = {3'b000, flag};

endmodule
