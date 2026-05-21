// ==============================================================================
// File Name: tb_aes_top.v
// Module Name: tb_aes_top
// Description: Testbench for verifying top-level AES-128 Encryption IP Core.
// Author: Senior IC Design Engineer
// Date: 2026-05-21
// ==============================================================================

`timescale 1ns / 1ps

module tb_aes_top;

    // Testbench Signals
    reg          clk;
    reg          rst_n;
    reg          start;
    reg          key_load;
    reg  [127:0] plain_text;
    reg  [127:0] key;
    wire         ready;
    wire         done;
    wire [127:0] cipher_text;

    // Instantiate Unit Under Test (UUT)
    aes_top uut (
        .clk         (clk),
        .rst_n       (rst_n),
        .start       (start),
        .key_load    (key_load),
        .plain_text  (plain_text),
        .key         (key),
        .ready       (ready),
        .done        (done),
        .cipher_text (cipher_text)
    );

    // Clock Generation (100MHz -> 10ns period)
    always begin
        #5 clk = ~clk;
    end

    // Stimulus Process
    initial begin
        // Initialize Signals
        clk        = 1'b0;
        rst_n      = 1'b0;
        start      = 1'b0;
        key_load   = 1'b0;
        plain_text = 128'h0;
        key        = 128'h0;

        // Apply Reset
        #20;
        rst_n = 1'b1;
        #20;

        // Test Case 1: Load Key & Encrypt
        $display("[TB] Loading Key...");
        @(posedge clk);
        key      = 128'h2b7e151628aed2a6abf7158809cf4f3c;
        key_load = 1'b1;
        
        @(posedge clk);
        key_load = 1'b0;

        #20;

        $display("[TB] Starting Encryption...");
        @(posedge clk);
        plain_text = 128'h3243f6a8885a308d313198a2e0370734;
        start      = 1'b1;

        @(posedge clk);
        start = 1'b0;

        // Wait for Done signal
        @(posedge done);
        $display("[TB] Encryption Complete! Ciphertext: %h", cipher_text);

        #100;
        $display("[TB] Simulation Finished.");
        $finish;
    end

endmodule
