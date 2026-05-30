# Arithmetic Logic Unit (ALU) - RV32I

This module contains the design and verification of the main Arithmetic Logic Unit (ALU) for a **32-bit RISC-V processor architecture** (specifically, the **RV32I** base integer instruction set).

## Main Features
* **Architecture:** RISC-V (RV32I)
* **Bus width:** 32 bits (inputs and outputs).
* **Design type:** Purely combinational (`always_comb`).

## Supported Operations
The ALU is designed to decode a 4-bit command (`instruction`) and execute the following mathematical and logical operations required by the RISC-V standard:

* **Arithmetic:**
  * `ADD` (Addition)
  * `SUB` (Subtraction)
* **Logical:**
  * `AND` (Logical AND)
  * `OR` (Logical OR)
  * `XOR` (Logical Exclusive OR)
* **Shifts:**
  * `SLL` (Shift Left Logical)
  * `SRL` (Shift Right Logical)
  * `SRA` (Shift Right Arithmetic - preserves the sign bit)
* **Comparisons:**
  * `LT` (Less Than - Signed comparison)
  * `LTU` (Less Than Unsigned - Unsigned comparison)

## Performance and Target FPGA (Artix-7)
Being a strictly combinational module (without flip-flops or an internal clock signal), the ALU does not have a predefined clock frequency of its own. Its response speed is determined by the **maximum propagation delay** (Critical Path), which is typically found in the adder/subtractor block.

This design was synthesized and timing-simulated targeting a **Xilinx Artix-7 FPGA**. During the Vivado *Post-Synthesis Timing Simulation*, the module successfully stabilized all output signals well within a **10 ns** window. This hardware-specific delay footprint confirms that the ALU can comfortably operate at a clock frequency of **100 MHz** on the Artix-7 silicon, paving the way for the full processor integration.

## Verification
The module includes a testbench (`ALU_Sim.sv`) that checks critical cases (maximum and minimum values, bit alternation) and runs **100,000 continuous randomized tests**, comparing the hardware output against an ideal mathematical model to guarantee zero assertion failures.
