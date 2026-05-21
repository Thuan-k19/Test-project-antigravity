#!/bin/bash
# ==============================================================================
# File Name: run_sim.sh
# Description: Shell script to automate ModelSim compilation and simulation
# Author: Senior IC Design Engineer
# Date: 2026-05-21
# ==============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# Define directories
SRC_DIR="../src"
TB_DIR="../tb"
WORK_DIR="work"

echo "================================================================="
echo " Starting Simulation Automation Script for AES-128 IP Core"
echo "================================================================="

# Create work library if it does not exist
if [ ! -d "$WORK_DIR" ]; then
    echo "[INFO] Creating ModelSim work library..."
    vlib $WORK_DIR
else
    echo "[INFO] Work library already exists."
fi

# Compile Verilog source files
echo "[INFO] Compiling Design Source Files..."
vlog -work $WORK_DIR \
    +acc \
    "$SRC_DIR/aes_sbox.v" \
    "$SRC_DIR/aes_key_expansion.v" \
    "$SRC_DIR/aes_datapath.v" \
    "$SRC_DIR/aes_controller.v" \
    "$SRC_DIR/aes_top.v"

# Compile Testbench
echo "[INFO] Compiling Testbench..."
vlog -work $WORK_DIR \
    +acc \
    "$TB_DIR/tb_aes_top.v"

# Run simulation
echo "[INFO] Running Simulation..."
# -c runs in command line mode. Remove -c if you want to open the ModelSim GUI.
vsim -c -lib $WORK_DIR tb_aes_top -do "run -all; quit -f"

echo "================================================================="
echo " Simulation Finished Successfully!"
echo "================================================================="
