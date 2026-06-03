# Data Memory (DMEM) - RV32I

This module implements the Data Memory (RAM) for a 32-bit RISC-V processor (RV32I Architecture), written in SystemVerilog. It serves as the primary data storage for the processor, handling `Load` and `Store` operations.

## Key Features

* **Architecture:** RISC-V (RV32I).
* **Storage Capacity:** 4 Kilobytes (1024 words x 32 bits). Synthesizable into a single dedicated Block RAM (BRAM) on Xilinx FPGAs, consuming zero logic LUTs.
* **Synchronous Write / Asynchronous Read:** * Writes are strictly synchronous to the rising edge of the clock (`clk`), protected by a Write Enable (`we`) signal to prevent accidental data corruption.
  * Reads are purely combinational, providing the requested data instantaneously to maintain the single-cycle processor architecture.
* **Word-Aligned Addressing:** Fully compatible with RISC-V byte-addressable conventions. The input address is mapped using the `address[31:2]` hardware hack, silently converting +4 byte jumps into +1 array index increments.

## Testbench

The `DMEM_sim` module rigorously verifies the memory through cycle-accurate SystemVerilog assertions. The test environment includes a parameterized clock generator (configured for 100 MHz) and drives stimuli on the negative edge of the clock to prevent race conditions.

Validated critical cases:
1. **Standard R/W:** Correct synchronous data storage and subsequent combinational retrieval.
2. **Write Enable Shielding:** Ensures data integrity by attempting writes with `we = 0` and verifying that the existing memory state remains uncorrupted.
3. **Address Independence:** Confirms that writes to adjacent word boundaries (e.g., `0x0` and `0x4`) do not overwrite or interfere with each other.
