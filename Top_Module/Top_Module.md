# Top Module - RV32I Single-Cycle Processor

This module implements the top-level entity (`Top_Module`) of a single-cycle 32-bit RISC-V processor based on the RV32I ISA, written in SystemVerilog. It structurally interconnects the control matrix, execution units, memory interfaces, and internal routing structures to instantiate a fully functional hardware processing core.

## Key Features

* **Architecture:** RV32I Base Integer Instruction Set.
* **Design Type:** Single-cycle structural integration with optimized multiplexing logic for datapath steering.
* **Instruction Slicing & Decoding:** Sequentially addresses the independent Instruction Memory (`IMEM`) via the Program Counter, isolating and slicing the 32-bit vector inline into standardized, unprivileged RISC-V fields (`op_code`, `funct_3`, `funct_7_5`, and register sub-fields) without requiring explicit memory ordering fences.
* **Unified Control & Execution:** Directly maps the `Control_Unit` outputs to govern immediate extraction, ALU routing, and writeback targets.
* **Dynamic Branch Resolution:** Implements a localized combinational evaluation block that resolves conditional branches (`BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`) using the ALU flags, dynamically overriding the sequential execution flow (`PC + 4`).
* **Sub-Module Cohesion:** Integrates the following core structural blocks:
  * **Instruction Management:** `Program_Counter` (PC) & `IMEM`.
  * **Data Core:** `File_Reg` (Register File), `Imm_Gen`, and the `ALU` framework (with its dedicated `ALU_decoder`).
  * **Storage Interface:** `LSU` (Load/Store Unit) tightly coupled to an aligned Byte-Enabled Data Memory (`DMEM`).

## Datapath Routing Architecture

The core orchestrates data movement through three critical structural multiplexers configured directly at this top layer:

* **ALU Operand Steering:** 
  * **A-Side:** Routes either the Register File output, the current Program Counter (for PC-relative operations), or zero.
  * **B-Side:** Alternates between Register File data or the extended immediate field.
* **Writeback Control:** Manages the destination bus (`writeback_data`) using a 2-bit selector to route the ALU arithmetic output, the memory load buffer (`r_data_lsu`), or the link return address (`PC + 4`) back into the register matrix.
* **Target Address Selection:** Resolves the final jump/branch destination vector (`target_address`) by choosing between the relative offset (`PC + immediate`) or the absolute calculated address from the ALU (for `JALR` mechanics).

## Verification Strategy

The microarchitecture and instruction execution of this core have been fully validated using the **Official RISC-V Architecture Compliance Test Suite** from RISC-V International. Instead of relying on custom or non-exhaustive testbenches, the verification process was driven by executing the official pre-compiled hexadecimal test vectors for every single function within the RV32I ISA.

* **Official ISA Compliance Vectors:** The `Top_Module` was rigorously tested by loading and executing hundreds of specialized `.hex` firmware streams directly into the `IMEM`. Every individual instruction category (such as arithmetic, logical shifts, load/store boundaries, and conditional branches) was stressed using these official binary patterns to evaluate edge cases and overflow conditions.
* **Function-by-Function Validation:** By running these official pre-compiled test blocks systematically through a top-level simulation suite, the processor's datapath, register state transitions, and memory operations were strictly proven to comply with the official RISC-V standard at a bit-accurate level.
