// ==============================================================================
// File Name: aes_key_expansion.v
// Module Name: aes_key_expansion
// Description: AES-128 Key Expansion module. Generates round keys on the fly.
// Author: Senior IC Design Engineer
// Date: 2026-05-21
// ==============================================================================

`timescale 1ns / 1ps

module aes_key_expansion (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         key_load,
    input  wire [127:0] key,
    input  wire [3:0]   round_idx,
    output reg  [127:0] round_key,
    output reg          ready
);

    // Initial architectural block (Placeholder for synthesis logic)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            round_key <= 128'h0;
            ready     <= 1'b0;
        end else if (key_load) begin
            round_key <= key; // Load initial cipher key
            ready     <= 1'b1;
        end
    end

endmodule
