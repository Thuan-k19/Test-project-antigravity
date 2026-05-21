# AES-128 IP Core Architectural Design Specification
**Role**: Senior IC Design Engineer  
**Target Platform**: SoC Integration (Linux/WSL, ModelSim, Vivado)  

---

## 1. Project Directory Structure

A standardized, highly organized layout is critical for seamless version control, team collaboration, and automated tool flow integration (Vivado, ModelSim).

```
aes128_core/
├── docs/               # Technical specifications, registers map, architecture docs
│   └── architecture.md # This architecture specification
├── src/                # Synthesizable RTL source files (Verilog)
│   ├── aes_top.v       # Top-level IP integration and routing
│   ├── aes_controller.v# FSM-based control unit (Control Path)
│   ├── aes_datapath.v  # AES round transformation datapath (Data Path)
│   ├── aes_key_expansion.v # On-the-fly round key generator
│   └── aes_sbox.v      # SubBytes Substitution Box (optimized LUT)
├── tb/                 # Verification files (Testbenches)
│   └── tb_aes_top.v    # Top-level testbench
└── scripts/            # Compilation, simulation, and synthesis scripts
    └── run_sim.sh      # ModelSim simulation automation script
```

---

## 2. Core Modules Breakdown

The architecture is partitioned into distinct **Control Path** and **Data Path** segments to optimize for timing closure, clock-gating, and clean synthesizability.

### A. `aes_top` (Top-Level Wrapper)
*   **Purpose**: Interfaces with the SoC bus (e.g., APB, AXI-Lite) or simple handshake interfaces.
*   **Responsibility**: Instantiates and wires together the FSM Controller, the Datapath, and the Key Expansion block.

### B. `aes_controller` (Control Path)
*   **Purpose**: Orchestrates the state transitions of the encryption cycle.
*   **Design**: Implemented as a Mealy/Moore Finite State Machine (FSM).
*   **Responsibilities**:
    *   Maintains the active round counter (`0` to `10`).
    *   Generates enable signals (`sub_bytes_en`, `shift_rows_en`, `mix_columns_en`, `add_round_key_en`) based on the active round.
    *   Handles standard handshake protocols (`start`, `ready`, `done`).

### C. `aes_datapath` (Data Path)
*   **Purpose**: Executes the high-performance mathematical operations of the AES algorithm.
*   **Design**: Optimized for 128-bit parallel execution, using pipelining or iterative looping based on resource-vs-throughput trade-offs.
*   **Transformations Included**:
    *   **SubBytes**: Custom non-linear byte substitution using S-Box modules.
    *   **ShiftRows**: Hardwired cyclic transposition (zero-overhead wire-swapping).
    *   **MixColumns**: Multiplications over Galois Field $GF(2^8)$, implemented via optimal XOR trees.
    *   **AddRoundKey**: Bitwise XOR with the generated round keys.

### D. `aes_key_expansion` (Key Generator)
*   **Purpose**: Expands the original 128-bit key into eleven 128-bit round keys.
*   **Design**: To optimize hardware resources, we calculate the round keys **on-the-fly** during the rounds rather than pre-calculating and storing them in power-hungry registers.

### E. `aes_sbox` (Lookup Table)
*   **Purpose**: The fundamental non-linear substitution mechanism.
*   **Synthesis Strategy**: Designed to be automatically inferred by Vivado as ROM/Distributed RAM or Block RAM (BRAM), ensuring high clock frequency.

---

## 3. Top-Level I/O Port Architecture

The module utilizes a **Strobe-and-Handshake** interface which is directly compatible with DMA engines and standard SoC bus wrappers.

| Port Name | Direction | Width | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | 1 | Master system clock (active rising edge). |
| `rst_n` | Input | 1 | Synchronous active-low system reset. |
| `start` | Input | 1 | Strobe signal to start encryption (assert for 1 cycle). |
| `key_load` | Input | 1 | Strobe signal to initiate key expansion (assert for 1 cycle). |
| `plain_text` | Input | 128 | 128-bit data block to be encrypted. |
| `key` | Input | 128 | 128-bit initial cipher key. |
| `ready` | Output | 1 | Active-high status flag indicating the core is idle and ready for a new operation. |
| `done` | Output | 1 | Handshake strobe indicating encryption is complete and output is valid. |
| `cipher_text` | Output | 128 | 128-bit encrypted output ciphertext. |

### Handshake Protocol Waveform Flow
1. **Reset State**: `ready` is pulled high.
2. **Key Load**: Assert `key_load` along with valid `key`.
3. **Trigger**: Assert `start` with valid `plain_text`. `ready` falls low during processing.
4. **Completion**: After 11 clock cycles, `done` pulses high for 1 cycle, `cipher_text` becomes valid, and `ready` returns high.

---

## 4. Compilation & Verification Flow

Automation using shell scripting ensures reproducible results in CI/CD pipelines and developer workspaces.

### ModelSim Script usage (`run_sim.sh`):
1. Navigate to the `scripts` folder:
   ```bash
   cd scripts
   ```
2. Execute the script:
   ```bash
   ./run_sim.sh
   ```
3. The script automatically:
   * Initializes the work library (`vlib work`).
   * Compiles the source RTL and testbench files with appropriate access visibilities (`vlog -work work ...`).
   * Starts a command-line simulation run (`vsim -c`) and prints the assertions or simulation logs directly to terminal.
