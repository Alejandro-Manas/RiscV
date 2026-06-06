# RISC-V Load/Store Unit (LSU)

This directory contains the SystemVerilog implementation of the Load/Store Unit (LSU) module for an RV32I RISC-V softcore processor, along with its corresponding testbench.

## Key Features

* **Address Alignment:** Calculates the 32-bit aligned base address by safely truncating the two least significant bits (`addr[31:2]`) for data memory (DMEM) transactions.
* **Load Operations:** Processes raw data coming from memory, extracting the corresponding byte or half-word based on the address. It automatically applies sign extension (`lb`, `lh`) or zero extension (`lbu`, `lhu`) as required by the RISC-V architecture, in addition to supporting full words (`lw`).
* **Store Operations:** Based on the least significant bits of the address, it generates the active 4-bit write mask (`dmem_we`) and replicates the data (`dmem_w_data`) in the exact position of the 32-bit bus so that the DMEM can capture individual bytes (`sb`), half-words (`sh`), or full words (`sw`).
* **Combinational Design:** The module operates entirely with combinational logic (`always_comb`), resolving memory masking and formatting in a single instruction cycle.

## Module Ports

| Signal | Direction | Width (bits) | Description |
| :--- | :--- | :---: | :--- |
| `addr` | Input | 32 | Original memory address requested by the ALU. |
| `w_data` | Input | 32 | Original data to be stored, coming from the register file. |
| `funct_3` | Input | 3 | Function bits (`funct3`) of the RISC-V instruction that determine size and sign. |
| `mem_read` | Input | 1 | Control signal to enable load functions. |
| `mem_write` | Input | 1 | Control signal to enable store functions. |
| `dmem_adress` | Output | 32 | Aligned address sent to the data memory (DMEM). |
| `dmem_we` | Output | 4 | Write enable mask sent to the DMEM. |
| `dmem_w_data` | Output | 32 | Replicated and pre-aligned data sent to the DMEM. |
| `r_data` | Input | 32 | Raw data read from the DMEM. |
| `r_data_aligned` | Output | 32 | Final processed data (with sign/zero extension) returned to the register file. |

## Simulation and Verification (`LSU_sim`)

The design includes a high-performance, self-checking testbench (`LSU_sim.sv`) to verify the integrity of the combinational logic. The simulation environment executes the following verification steps using `tasks`:

1. **Address Generation Testing:** Verifies through a sweep that the output memory addresses correctly omit the 2 LSBs in favor of fixed zeros to enforce alignment.
2. **Massive Randomized Stress Testing:** Executes a total of 800,000 random transactions (100,000 iterations using `$urandom()` for both addresses and data) covering each of the 8 supported RISC-V operations (`lb`, `lh`, `lw`, `lbu`, `lhu`, `sb`, `sh`, `sw`) in isolation.
3. **Automated Assertions (SVA):** Strictly validates hardware behavior using logical assertions (`assert ===`), ensuring that:
   * Data packaging (`r_data_aligned`) generates the correct padding with zeros or the expected sign bit.
   * The memory write mask (`dmem_we`) is activated exclusively on the correct bytes defined by the address alignment.
