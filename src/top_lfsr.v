`timescale 1ns / 1ps

// ============================================================
// Registro de 8 bits con reset activo en bajo
// ============================================================

module register_8bit (
    input        clk_i,
    input        reset_n_i,   // Reset activo en bajo
    input        load_i,      // Habilita almacenamiento
    input  [7:0] data_i,
    output [7:0] data_o
);

    
    reg [7:0] reg_data;

    always @(posedge clk_i or negedge reset_n_i) begin
        if (!reset_n_i) begin
            reg_data <= 8'b00000000;
        end else begin
            if (load_i) begin
                reg_data <= data_i;
            end
        end
    end

    assign data_o = reg_data;

endmodule


// ============================================================
// LFSR parametrizable
// Por defecto configurado para 8 bits
// Reset activo en bajo
// ============================================================

module LFSR #(
    parameter NUM_BITS = 8
)(
    input                  i_Clk,
    input                  i_Rst,        // Reset activo en bajo
    input                  i_Enable,
    output [NUM_BITS-1:0]  o_LFSR_Data,
    output                 o_LFSR_Done
);

    reg [NUM_BITS:1] r_LFSR;
    reg              r_XNOR;

    always @(posedge i_Clk or negedge i_Rst) begin
        if (!i_Rst) begin
            r_LFSR <= 8'b10101010;
        end else begin
            if (i_Enable) begin
                r_LFSR <= {r_LFSR[NUM_BITS-1:1], r_XNOR};
            end
        end
    end

    always @(*) begin
        case (NUM_BITS)
            3:  r_XNOR = r_LFSR[3]  ^~ r_LFSR[2];
            4:  r_XNOR = r_LFSR[4]  ^~ r_LFSR[3];
            5:  r_XNOR = r_LFSR[5]  ^~ r_LFSR[3];
            6:  r_XNOR = r_LFSR[6]  ^~ r_LFSR[5];
            7:  r_XNOR = r_LFSR[7]  ^~ r_LFSR[6];
            8:  r_XNOR = r_LFSR[8]  ^~ r_LFSR[6]  ^~ r_LFSR[5]  ^~ r_LFSR[4];
            9:  r_XNOR = r_LFSR[9]  ^~ r_LFSR[5];
            10: r_XNOR = r_LFSR[10] ^~ r_LFSR[7];
            11: r_XNOR = r_LFSR[11] ^~ r_LFSR[9];
            12: r_XNOR = r_LFSR[12] ^~ r_LFSR[6]  ^~ r_LFSR[4]  ^~ r_LFSR[1];
            13: r_XNOR = r_LFSR[13] ^~ r_LFSR[4]  ^~ r_LFSR[3]  ^~ r_LFSR[1];
            14: r_XNOR = r_LFSR[14] ^~ r_LFSR[5]  ^~ r_LFSR[3]  ^~ r_LFSR[1];
            15: r_XNOR = r_LFSR[15] ^~ r_LFSR[14];
            16: r_XNOR = r_LFSR[16] ^~ r_LFSR[15] ^~ r_LFSR[13] ^~ r_LFSR[4];
            17: r_XNOR = r_LFSR[17] ^~ r_LFSR[14];
            18: r_XNOR = r_LFSR[18] ^~ r_LFSR[11];
            19: r_XNOR = r_LFSR[19] ^~ r_LFSR[6]  ^~ r_LFSR[2]  ^~ r_LFSR[1];
            20: r_XNOR = r_LFSR[20] ^~ r_LFSR[17];
            21: r_XNOR = r_LFSR[21] ^~ r_LFSR[19];
            22: r_XNOR = r_LFSR[22] ^~ r_LFSR[21];
            23: r_XNOR = r_LFSR[23] ^~ r_LFSR[18];
            24: r_XNOR = r_LFSR[24] ^~ r_LFSR[23] ^~ r_LFSR[22] ^~ r_LFSR[17];
            25: r_XNOR = r_LFSR[25] ^~ r_LFSR[22];
            26: r_XNOR = r_LFSR[26] ^~ r_LFSR[6]  ^~ r_LFSR[2]  ^~ r_LFSR[1];
            27: r_XNOR = r_LFSR[27] ^~ r_LFSR[5]  ^~ r_LFSR[2]  ^~ r_LFSR[1];
            28: r_XNOR = r_LFSR[28] ^~ r_LFSR[25];
            29: r_XNOR = r_LFSR[29] ^~ r_LFSR[27];
            30: r_XNOR = r_LFSR[30] ^~ r_LFSR[6]  ^~ r_LFSR[4]  ^~ r_LFSR[1];
            31: r_XNOR = r_LFSR[31] ^~ r_LFSR[28];
            32: r_XNOR = r_LFSR[32] ^~ r_LFSR[22] ^~ r_LFSR[2]  ^~ r_LFSR[1];

            default: r_XNOR = 1'b0;
        endcase
    end

    assign o_LFSR_Data = r_LFSR[NUM_BITS:1];

  assign o_LFSR_Done = (r_LFSR[NUM_BITS:1] == 10101010) ? 1'b1 : 1'b0;

endmodule


// ============================================================
// Top: conexión entre LFSR y registro de 8 bits
// ============================================================

module tt_um_top_lfsr_register_8bit (
    input        clk_i,
    input        reset_n_i,       // Reset activo en bajo
    input        lfsr_enable_i,   // Habilita generación del LFSR
    input        reg_load_i,      // Habilita almacenamiento en el registro

    output [7:0] reg_data_o,
    output       lfsr_done_o
);

    wire [7:0] lfsr_data;

    LFSR #(
        .NUM_BITS(8)
    ) u_lfsr (
        .i_Clk       (clk_i),
        .i_Rst       (reset_n_i),
        .i_Enable    (lfsr_enable_i),
        .o_LFSR_Data (lfsr_data),
        .o_LFSR_Done (lfsr_done_o)
    );

    register_8bit u_register_8bit (
        .clk_i     (clk_i),
        .reset_n_i (reset_n_i),
        .load_i    (reg_load_i),
        .data_i    (lfsr_data),
        .data_o    (reg_data_o)
    );

endmodule
