// ==============================================================================
// File Name: aes_controller.v
// Module Name: aes_controller
// Description: FSM Controller for the AES-128 IP Core.
//              Manages state transitions and core control signals.
// Author: Senior IC Design Engineer
// Date: 2026-05-21
// ==============================================================================

`timescale 1ns / 1ps

module aes_controller (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire       key_exp_ready,
    output reg  [3:0] round_idx,
    output reg        ld_state,
    output reg        sub_bytes_en,
    output reg        shift_rows_en,
    output reg        mix_columns_en,
    output reg        add_round_key_en,
    output reg        ready,
    output reg        done
);

    // FSM State Encoding
    localparam STATE_IDLE        = 3'd0;
    localparam STATE_KEY_EXP     = 3'd1;
    localparam STATE_ADD_ROUND_0 = 3'd2;
    localparam STATE_ROUND_LOOP  = 3'd3;
    localparam STATE_FINAL_ROUND = 3'd4;
    localparam STATE_DONE        = 3'd5;

    reg [2:0] current_state, next_state;

    // FSM State Registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= STATE_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State Logic & Outputs (Skeletal placeholder)
    always @(*) begin
        next_state = current_state;
        ld_state = 1'b0;
        sub_bytes_en = 1'b0;
        shift_rows_en = 1'b0;
        mix_columns_en = 1'b0;
        add_round_key_en = 1'b0;
        ready = 1'b0;
        done = 1'b0;

        case (current_state)
            STATE_IDLE: begin
                ready = 1'b1;
                if (start) begin
                    next_state = STATE_KEY_EXP;
                end
            end

            STATE_KEY_EXP: begin
                if (key_exp_ready) begin
                    next_state = STATE_ADD_ROUND_0;
                end
            end

            STATE_ADD_ROUND_0: begin
                ld_state = 1'b1;
                add_round_key_en = 1'b1;
                next_state = STATE_ROUND_LOOP;
            end

            STATE_ROUND_LOOP: begin
                sub_bytes_en = 1'b1;
                shift_rows_en = 1'b1;
                mix_columns_en = 1'b1;
                add_round_key_en = 1'b1;
                if (round_idx == 4'd9) begin
                    next_state = STATE_FINAL_ROUND;
                end
            end

            STATE_FINAL_ROUND: begin
                sub_bytes_en = 1'b1;
                shift_rows_en = 1'b1;
                add_round_key_en = 1'b1;
                next_state = STATE_DONE;
            end

            STATE_DONE: begin
                done = 1'b1;
                next_state = STATE_IDLE;
            end

            default: next_state = STATE_IDLE;
        endcase
    end

    // Round counter logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            round_idx <= 4'd0;
        end else if (current_state == STATE_ROUND_LOOP) begin
            round_idx <= round_idx + 1'b1;
        end else if (current_state == STATE_IDLE) begin
            round_idx <= 4'd0;
        end
    end

endmodule
