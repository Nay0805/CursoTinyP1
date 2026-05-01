module Top_Detector_de_patrones (
  input  wire       clk,
  input  wire       rst,
  output wire [3:0] leds
);

  wire       pulso;
  wire [7:0] bit_REGISTRO;
  wire       igual_alto;
  wire       igual_bajo;
  wire [7:0] bit_LFSR;
  wire       flag;

  // Comparador bits bajos [3:0]
  Comparador u_cmp_bajo (
    .bit_REGISTRO (bit_REGISTRO[3:0]),
    .bit_LFSR     (bit_LFSR[3:0]),
    .igual        (igual_bajo)
  );

  // Comparador bits altos [7:4]
  Comparador u_cmp_alto (
    .bit_REGISTRO (bit_REGISTRO[7:4]),
    .bit_LFSR     (bit_LFSR[7:4]),
    .igual        (igual_alto)
  );

  // FSM detector
  FSM_DETECTOR u_fsm (
    .clk        (clk),
    .rst        (rst),
    .Pulso      (pulso),
    .Igual_alto (igual_alto),
    .Igual_bajo (igual_bajo),
    .flag       (flag)
  );

  // flag va al LED 0, el resto apagados
  assign leds = {3'b000, flag};

endmodule