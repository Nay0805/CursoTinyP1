`timescale 1ns/1ps

module reg_pp_8b_en_ar(
  input  logic        clk_i,
  input  logic        rst_n_i,
  input  logic [7:0]  d_i,
  input  logic        en_i,
  output logic [7:0]  q_o
);

  always_ff @(posedge clk_i or negedge rst_n_i) begin
    if (!rst_n_i) begin
      q_o <= 8'b0000_0000;
    end
    else if (en_i) begin
      q_o <= d_i;
    end
    else begin
      q_o <= q_o;
    end
  end

endmodule