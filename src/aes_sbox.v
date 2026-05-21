// ==============================================================================
// File Name: aes_sbox.v
// Module Name: aes_sbox
// Description: AES S-Box Lookup Table (LUT). Can be mapped to ROM/Block RAM.
// Author: Senior IC Design Engineer
// Date: 2026-05-21
// ==============================================================================

`timescale 1ns / 1ps

module aes_sbox (
    input  wire [7:0] sbox_in,
    output reg  [7:0] sbox_out
);

    // Simplified S-box look up placeholder for synthesis testing
    always @(*) begin
        case (sbox_in)
            8'h00:   sbox_out = 8'h63;
            default: sbox_out = 8'h00; // Will be expanded to full LUT
        endcase
    end

endmodule
