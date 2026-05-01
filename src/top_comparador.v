`timescale 1ns/1ps

module top_uart_lfsr_detector (
    input  wire       clk,
    input  wire       rst,       // Reset activo en alto
    input  wire       rx,        // Entrada UART desde consola
    input  wire       pulso,     // Pulso para avanzar el LFSR/FSM
    output wire       tx,        // Salida UART
    output wire [3:0] leds
);

    // ------------------------------------------------------------
    // Señales internas
    // ------------------------------------------------------------

    wire rst_n;

    wire [7:0] uart_data_out;
    wire       rx_data_rdy;
    wire       tx_rdy;

    wire [7:0] uart_reg_data;
    wire [7:0] lfsr_reg_data;

    wire       lfsr_done;

    assign rst_n = ~rst;


    // ------------------------------------------------------------
    // UART
    // Recibe dato serial por rx.
    // data_out entrega el dato recibido en paralelo.
    // ------------------------------------------------------------

    UART u_uart (
        .clk         (clk),
        .reset       (rst),
        .tx_start    (1'b0),
        .tx_rdy      (tx_rdy),
        .rx_data_rdy (rx_data_rdy),
        .data_in     (8'b00000000),
        .data_out    (uart_data_out),
        .rx          (rx),
        .tx          (tx)
    );


    // ------------------------------------------------------------
    // Registro del dato recibido por UART
    // Se carga cuando rx_data_rdy está activo.
    // ------------------------------------------------------------

    register_8bit u_reg_uart (
        .clk_i     (clk),
        .reset_n_i (rst_n),
        .load_i    (rx_data_rdy),
        .data_i    (uart_data_out),
        .data_o    (uart_reg_data)
    );


    // ------------------------------------------------------------
    // LFSR + registro
    // El LFSR avanza con pulso.
    // El registro del LFSR se carga con tx_rdy.
    // ------------------------------------------------------------

    tt_um_top_lfsr_register_8bit u_lfsr_register (
        .clk_i         (clk),
        .reset_n_i     (rst_n),
        .lfsr_enable_i (1'b1),
        .reg_load_i    (tx_rdy),
        .reg_data_o    (lfsr_reg_data),
        .lfsr_done_o   (lfsr_done)
    );


    // ------------------------------------------------------------
    // Detector de patrones
    // Compara salida del registro UART contra salida del registro LFSR.
    // ------------------------------------------------------------

    Top_Detector_de_patrones u_detector (
        .clk          (clk),
        .rst          (rst),
        .bit_REGISTRO (uart_reg_data),
        .bit_LFSR     (lfsr_reg_data),
        .pulso        (pulso),
        .leds         (leds)
    );

endmodule
