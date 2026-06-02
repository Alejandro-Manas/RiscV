# Program Counter (PC) - RV32I

This module implements the main Program Counter (`Program_Counter`) for a 32-bit RISC-V processor (RV32I Architecture), written in SystemVerilog. It acts as the sequential heart of the processor, holding the memory address of the current instruction being executed.

## Key Features

* **Architecture:** RISC-V (RV32I).
* **Bus Width:** 32 bits (inputs and outputs).
* **Design Type:** Sequential logic (`always_ff`).
* **Synchronous Active-Low Reset (`rst_n`):** Optimized for robust FPGA implementation, ensuring predictable timing and avoiding metastability recovery issues. When asserted (`0`), the PC resets to the boot vector address (`32'h0000_0000`).
* **Stall Support (`pc_en`):** Includes a hardware enable signal to freeze the PC. This is a critical feature to support pipeline pauses (hazard handling) or wait states for instruction memory latency in future design stages.

## Testbench

The simulation module `Program_Counter_sim` is included, featuring automated verification through SystemVerilog *assertions*. Input signals are intentionally applied on the falling edge of the clock (`negedge clk`) to prevent race conditions and ensure accurate sampling. The directed testing verifies the following core behaviors:

1. **Initialization & Reset:** Confirms that the active-low synchronous reset correctly forces the PC to `0x0000_0000` precisely on the clock edge.
2. **Enable (Stall) Logic:** Validates that the PC captures the `pc_next` address when `pc_en` is active, and perfectly retains its current state (stalls) when `pc_en` is disabled.
3. **Reset Priority (Stress Test):** Simulates a conflict scenario where both a write enable and a reset are triggered simultaneously, proving that the hardware reset condition takes absolute priority over the datapath.
