// ==============================================================================
// File Name: aes_datapath.v
// Module Name: aes_datapath
// Description: Datapath for the AES-128 IP Core.
//              Handles SubBytes, ShiftRows, MixColumns, and AddRoundKey.
// Author: Senior IC Design Engineer
// Date: 2026-05-21
// ==============================================================================

`timescale 1ns / 1ps

module aes_datapath (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         ld_state,
    input  wire         sub_bytes_en,
    input  wire         shift_rows_en,
    input  wire         mix_columns_en,
    input  wire         add_round_key_en,
    input  wire [127:0] plain_text,
    input  wire [127:0] round_key,
    output reg  [127:0] cipher_text
);

    // Internal State Registers
    reg [127:0] state_reg;

    // Architectural placeholder for Datapath operations
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg   <= 128'h0;
            cipher_text <= 128'h0;
        end else begin
            if (ld_state) begin
                state_reg <= plain_text ^ round_key;
            end else begin
                // Placeholder transformations
                if (sub_bytes_en)     state_reg <= state_reg; // SubBytes logic
                if (shift_rows_en)    state_reg <= state_reg; // ShiftRows logic
                if (mix_columns_en)   state_reg <= state_reg; // MixColumns logic
                if (add_round_key_en) state_reg <= state_reg ^ round_key;
            end
            
            // Output registration
            cipher_text <= state_reg;
        end
    end

endmodule
