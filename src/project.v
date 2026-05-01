/*
* Copyright (c) 2024 Your Name
* SPDX-License-Identifier: Apache-2.0
*/
 
`default_nettype wire 
 
module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
 
  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out[7:4] = 4'b0000;
  assign uio_out     = 8'b0;
  assign uio_oe      = 8'b0;
  // List all unused inputs to prevent warnings
  wire _unused = &{ena, 1'b0};
  
  Top_Detector_de_patrones U0 (
    .clk          (clk),
    .rst          (rst_n),
    .bit_REGISTRO (ui_in),
    .bit_LFSR     (uio_in),
    .pulso        (1)
    .leds         (uo_out[3:0])
  ); 
   
endmodule
