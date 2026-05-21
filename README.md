# High-Performance AES-128 Encryption IP Core

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Language: Verilog](https://img.shields.io/badge/Language-Verilog-blue.svg)](#)
[![Simulation: ModelSim](https://img.shields.io/badge/Simulation-ModelSim-green.svg)](#)

A synthesizable, high-performance AES-128 (Advanced Encryption Standard) IP Core designed in Verilog. This IP core is optimized for SoC integration, featuring a clean **Control/Data Path partitioning**, **on-the-fly round key expansion**, and a **fully parallelized substitution layer (S-Box)**.

---

## 🚀 Key Features

* **Standard Compliant**: Fully compliant with the NIST FIPS-197 AES-128 specification.
* **On-the-Fly Key Expansion**: Expands round keys on-the-fly to save hardware area and eliminate power-hungry registers.
* **Separated Controller & Datapath**: Clear FSM control logic separated from mathematical data processing for easier timing closure.
* **Strobe-and-Handshake Protocol**: Ready/Done handshake protocol directly compatible with DMA controllers and SoC bus wrappers (e.g., AXI-Lite, APB).
* **High Performance**: Encrypts a 128-bit block in **11 clock cycles** (including key load and round transformations).
* **Fully Automated Verification**: Includes automated compilation and simulation script using ModelSim.

---

## 📁 Directory Structure

```
.
├── README.md           # Project Overview (This file)
├── docs/               # Technical specifications and architecture specification
│   └── architecture.md # Detailed Architectural Specification
├── src/                # Synthesizable RTL source files (Verilog)
│   ├── aes_top.v       # Top-level IP core wrapper
│   ├── aes_controller.v# FSM-based Control Unit
│   ├── aes_datapath.v  # AES round transformation Datapath
│   ├── aes_key_expansion.v # On-the-fly round key generator
│   └── aes_sbox.v      # Non-linear SubBytes Lookup Table (ROM optimized)
├── tb/                 # Verification Files
│   └── tb_aes_top.v    # Self-checking top-level testbench
└── scripts/            # Automation scripts
    └── run_sim.sh      # ModelSim simulation automation script
```

---

## 🔌 Hardware Interface (Pinout)

The core uses a standard strobe-and-handshake interface:

| Port Name | Direction | Width (bits) | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | Master system clock (active rising edge). |
| `rst_n` | Input | 1 | Synchronous active-low system reset. |
| `start` | Input | 1 | Strobe signal to start encryption (assert for 1 cycle). |
| `key_load` | Input | 1 | Strobe signal to initiate key expansion (assert for 1 cycle). |
| `plain_text` | Input | 128 | 128-bit plain-text block to be encrypted. |
| `key` | Input | 128 | 128-bit initial cipher key. |
| `ready` | Output | 1 | Active-high status flag indicating core is idle and ready. |
| `done` | Output | 1 | Handshake strobe indicating encryption is complete. |
| `cipher_text` | Output | 128 | 128-bit encrypted output ciphertext. |

### Handshake Protocol Waveform Flow
1. **Reset**: `ready` is pulled high.
2. **Key Load**: Assert `key_load` along with valid `key` for 1 cycle.
3. **Trigger**: Assert `start` with valid `plain_text` for 1 cycle. `ready` falls low during processing.
4. **Completion**: After 11 clock cycles, `done` pulses high for 1 cycle, `cipher_text` becomes valid, and `ready` returns high.

---

## 🛠️ Verification & Simulation

You can easily run the verification testbench using the provided automated script.

### Prerequisites
* ModelSim or QuestaSim installed.
* Executables (`vlib`, `vlog`, `vsim`) available in your system path.

### Running Simulation
1. Navigate to the `scripts` directory:
   ```bash
   cd scripts
   ```
2. Run the simulation script:
   ```bash
   ./run_sim.sh
   ```
   The script will:
   * Create the `work` library directory.
   * Compile all RTL source files and testbenches.
   * Run the testbench simulation and print verification logs to the console.

---

## 📝 License
This project is licensed under the MIT License - see the LICENSE file for details.
