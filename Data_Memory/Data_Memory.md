# RISC-V Data Memory (DMEM)

This directory contains the SystemVerilog implementation of the Data Memory module for a RISC-V softcore processor, along with its corresponding testbench.

## Key Features

* **Capacity:** 8 KB (2047 x 32-bit words).
* **Asynchronous Read:** The read data bus (`r_data`) is combinational and instantly reflects the content of the requested address.
* **Synchronous Write with Byte Enables:** Utilizes a 4-bit `we` (Write Enable) mask to allow independent writing of each of the 4 bytes within a 32-bit word. This is crucial for supporting RISC-V store instructions (`sb`, `sh`, `sw`).
* **Memory Alignment:** Internal access safely ignores the two least significant bits of the address (`adress[31:2]`), ensuring proper 32-bit word alignment.

## Module Ports

| Signal | Direction | Width (bits) | Description |
| :--- | :--- | :---: | :--- |
| `clk` | Input | 1 | System clock. |
| `we` | Input | 4 | Write enable mask (one bit per byte in the data word). |
| `w_data` | Input | 32 | Data to be written into memory. |
| `adress` | Input | 32 | Requested memory address. |
| `r_data` | Output| 32 | Data read from memory. |

## Simulation and Verification (`DMEM_sim`)

The design includes a comprehensive testbench (`DMEM_sim.sv`) to verify the integrity of the read/write operations. The simulation environment executes the following verification steps:

1. **Initialization:** Iterates through the entire memory array, initializing all values to zero.
2. **Randomized Stress Testing:** Performs 10,000 randomized iterations (using `$urandom()` for both data and word-aligned addresses) for each of the 16 possible write mask (`we`) combinations.
3. **Automated Assertions:** Strictly verifies memory behavior using SystemVerilog assertions (`assert`) to ensure:
   * Bytes with an active `we` bit are successfully updated.
   * Bytes with an inactive `we` bit retain their previous state without data corruption.
