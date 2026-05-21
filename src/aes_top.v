// ==============================================================================
// File Name: aes_top.v
// Module Name: aes_top
// Description: Top-level module for AES-128 Encryption IP Core.
//              Designed with a standard SoC handshake protocol.
// Author: Senior IC Design Engineer
// Date: 2026-05-21
// ==============================================================================

`timescale 1ns / 1ps

module aes_top (
    // Clock and Reset
    input  wire         clk,          // System clock
    input  wire         rst_n,        // Active-low synchronous reset

    // Control Inputs
    input  wire         start,        // Start encryption process (assert for 1 cycle)
    input  wire         key_load,     // Trigger key expansion (assert when key is updated)

    // Data Inputs
    input  wire [127:0] plain_text,   // 128-bit Plaintext input
    input  wire [127:0] key,          // 128-bit Cipher Key

    // Status/Handshake Outputs
    output wire         ready,        // IP core is ready for new encryption
    output wire         done,         // Encryption complete, cipher_text is valid

    // Data Outputs
    output wire [127:0] cipher_text   // 128-bit Ciphertext output
);

    // ==========================================================================
    // Internal Wire & Register Declarations (For architectural connection)
    // ==========================================================================
    
    // Key Expansion Connections
    wire [127:0] round_key;
    wire [3:0]   round_idx;
    wire         key_exp_ready;

    // Controller to Datapath Signals
    wire         ld_state;
    wire         sub_bytes_en;
    wire         shift_rows_en;
    wire         mix_columns_en;
    wire         add_round_key_en;

    // ==========================================================================
    // Core Module Instantiations (Skeletal Architecture)
    // ==========================================================================

    // 1. Key Expansion Module
    aes_key_expansion u_key_expansion (
        .clk        (clk),
        .rst_n      (rst_n),
        .key_load   (key_load),
        .key        (key),
        .round_idx  (round_idx),
        .round_key  (round_key),
        .ready      (key_exp_ready)
    );

    // 2. Controller (FSM) Module
    aes_controller u_controller (
        .clk              (clk),
        .rst_n            (rst_n),
        .start            (start),
        .key_exp_ready    (key_exp_ready),
        .round_idx        (round_idx),
        .ld_state         (ld_state),
        .sub_bytes_en     (sub_bytes_en),
        .shift_rows_en    (shift_rows_en),
        .mix_columns_en   (mix_columns_en),
        .add_round_key_en (add_round_key_en),
        .ready            (ready),
        .done             (done)
    );

    // 3. Datapath Module
    aes_datapath u_datapath (
        .clk              (clk),
        .rst_n            (rst_n),
        .ld_state         (ld_state),
        .sub_bytes_en     (sub_bytes_en),
        .shift_rows_en    (shift_rows_en),
        .mix_columns_en   (mix_columns_en),
        .add_round_key_en (add_round_key_en),
        .plain_text       (plain_text),
        .round_key        (round_key),
        .cipher_text      (cipher_text)
    );

endmodule
