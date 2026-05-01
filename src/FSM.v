module FSM_DETECTOR (
  // Entradas
  input  wire clk,
  input  wire rst,         // reset sincrono, ACTIVO-BAJO
  input  wire Pulso,       // indica que los registros estan listos para comparar
  input  wire Igual_alto,  // resultado comparador bits [7:4] del LFSR vs UART
  input  wire Igual_bajo,  // resultado comparador bits [3:0] del LFSR vs UART
  // Salidas
  output reg  flag         // 1 si ambas mitades coinciden
);

  // Codificacion de estados
  localparam [1:0] ESPERA     = 2'b00,
                   COMPARANDO = 2'b01,
                   MATCH      = 2'b10,
                   NO_MATCH   = 2'b11;

  reg [1:0] state, next_state;

  // Memoria de estado
  always @(posedge clk) begin
    if (!rst)   state <= ESPERA;
    else        state <= next_state;
  end

  // Logica de siguiente estado
  always @(*) begin
    next_state = state;
    case (state)
      ESPERA: begin
        if (Pulso)  next_state = COMPARANDO;
        else        next_state = ESPERA;
      end
      COMPARANDO: begin
        if (Igual_alto && Igual_bajo)   next_state = MATCH;
        else                            next_state = NO_MATCH;
      end
      MATCH: begin
        next_state = ESPERA;
      end
      NO_MATCH: begin
        next_state = ESPERA;
      end
      default: next_state = ESPERA;
    endcase
  end

  // Logica de salidas
  always @(*) begin
    flag = 1'b0;
    case (state)
      ESPERA:     flag = 1'b0;
      COMPARANDO: flag = 1'b0;
      MATCH:      flag = 1'b1;
      NO_MATCH:   flag = 1'b0;
      default:    flag = 1'b0;
    endcase
  end

endmodule