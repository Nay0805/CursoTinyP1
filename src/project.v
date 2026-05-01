/*
* Copyright (c) 2024 Your Name
* SPDX-License-Identifier: Apache-2.0
*/

`default_nettype wire

module tt_um_Nay0805_detector_de_patrones_generados_aleatoreamente (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path
    input  wire       ena,      // always 1 when powered
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // ------------------------------------------------------------
    // Señales internas
    // ------------------------------------------------------------

    wire       rst;
    wire       rx;
    wire       pulso;
    wire       tx;
    wire [3:0] leds;

    assign rst   = ~rst_n;     // El top usa reset activo en alto
    assign rx    = ui_in[0];   // Entrada serial UART
    assign pulso = ui_in[1];   // Pulso para LFSR/FSM


    // ------------------------------------------------------------
    // Instancia del top principal
    // ------------------------------------------------------------

    top_uart_lfsr_detector U0 (
        .clk   (clk),
        .rst   (rst),
        .rx    (rx),
        .pulso (pulso),
        .tx    (tx),
        .leds  (leds)
    );


    // ------------------------------------------------------------
    // Asignación de salidas
    // ------------------------------------------------------------

    assign uo_out[3:0] = leds;
    assign uo_out[4]   = tx;
    assign uo_out[7:5] = 3'b000;

    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;


    // ------------------------------------------------------------
    // Entradas no utilizadas para evitar warnings
    // ------------------------------------------------------------

    wire _unused = &{ena, ui_in[7:2], uio_in, 1'b0};

endmodule
