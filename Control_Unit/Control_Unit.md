# Main Control Unit - RV32I

This module implements the central Control Unit (`Control_Unit`) for a 32-bit RISC-V processor (RV32I Architecture), written in SystemVerilog. It decodes the instruction `op_code` to generate the global control signals required to orchestrate the datapath, managing execution flow, operand selection, memory accesses, and register writes.

## Key Features

* **Architecture:** RISC-V (RV32I).
* **Design Type:** Purely combinational logic (`always_comb`) organized via specialized sub-blocks for structural clarity.
* **Header Integration:** Seamlessly relies on unified package headers (`Imm_Gen_header.svh` and `ALU_header.svh`) to drive command selection across modules.
* **Centralized Instruction Routing:** Evaluates the 7-bit `op_code` to govern all major processor subsections:
  * **Program Counter Flow:** Dispatches `branch` and `jump` flags to handle control hazards and out-of-order execution (e.g., JAL, JALR, Conditional Branches).
  * **Writeback Control:** Manages the `wb_selector` multiplexer to route either the ALU result, Data Memory output, or the sequential return address (PC + 4) back to the Register File.
  * **Immediate Format Selection:** Drives the `imm_cmd` bus to dynamically configure the extraction format (`TYPE_I`, `TYPE_U`, `TYPE_S`, `TYPE_B`, `TYPE_J`) inside the Immediate Generator.
  * **ALU Steering:** Controls the `ALU_a_selector` and `ALU_b_selector` routing structures to supply correct operands (Registers, PC, Zero, or Immediates) while setting the operational context via `ALU_control`.
  * **Memory Operations:** Toggles the Load/Store Unit (LSU) interface flags (`mem_read` and `mem_write`) exclusively during memory instruction frames.

## Verification Strategy

Unlike lower-level processing elements, the Main Control Unit acts as a direct combinational translation matrix. To ensure efficient and exhaustive verification, a dual-layer testing strategy is employed rather than a redundant, manual signal-forcing unit testbench:

1. **Integration-Driven Validation (Top-Level Testbench):** The control matrix is validated globally within the system `Top` module using architectural firmware streams. By running standard RISC-V software binaries (hexadecimal instruction vectors), every single control path and signal configuration is stressed under real execution conditions, catching any instruction decoding anomalies.
2. **Strict Combinational Inspection:** The block uses a dense, fully-defined structural decomposition where each functional multiplexer has a predictable default fallback block. This prevents any unintended latch inference and ensures that undefined opcodes safely force all write-enables (`file_reg_we`, `mem_write`) to an inactive low state, protecting the architectural state of the processor.
