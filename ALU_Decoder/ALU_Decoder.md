# ALU Decoder - RV32I

This module implements the Arithmetic Logic Unit Decoder (`ALU_decoder`) for a 32-bit RISC-V processor (RV32I Architecture), written in SystemVerilog. It acts as the bridge between the main Control Unit and the ALU, translating high-level control signals and instruction-specific fields into a precise 4-bit command for the ALU.

## Key Features

* **Architecture:** RISC-V (RV32I).
* **Design Type:** Pure combinational logic (`always_comb`).
* **Hierarchical Decoding:** Utilizes the 2-bit `ALU_control` signal from the main control unit to determine the operation context:
  * **Load/Store:** Automatically forces an addition operation (`ALU_add`) for address calculation.
  * **Branching:** Automatically forces a subtraction operation (`ALU_sub`) for operand comparison.
  * **Arithmetic-Logic Operations (R-Type / I-Type):** Delegates the decision to the instruction-specific fields.
* **Precise Instruction Resolution:** For ALU operations, the module examines the `funct_3` field alongside critical instruction bits (`funct_7_5` and `op_code_5`) to distinguish between instructions that share the same `funct_3`. For example:
  * Differentiates between **ADD** and **SUB** by ensuring the subtraction only occurs if bit 5 of `funct_7` and bit 5 of the `opcode` are active (indicating a valid R-Type instruction for subtraction).
  * Differentiates between logical (**SRL**) and arithmetic (**SRA**) shifts by evaluating `funct_7_5`.

## Testbench

The `ALU_decoder_sim` simulation module includes comprehensive automated verification using SystemVerilog *assertions*. The test is designed to check all possible combinational paths and verify the decoder's behavior against the following conditions:

1. **Operation Override:** Confirms that when `ALU_control` requests an explicit addition (for *addi* or memory access) or an explicit subtraction (for branching), the module strictly generates `ALU_add` or `ALU_sub`.
2. **Immunity to Irrelevant Signals:** Validates that the decoder does not suffer from interference. Logical "ones" are injected into `funct_3`, `funct_7_5`, and `op_code_5` while `ALU_control` is in direct operation mode (e.g., `2'b00`), demonstrating that the output remains stable and correct, ignoring "garbage" on non-relevant inputs.
3. **Exhaustive Decoding (Stress Test):** Iterates through all cases of the `ALU_control` `default` block. It evaluates every possible combination of `funct_3` with variations in `funct_7_5` and `op_code_5` to ensure that the 10 core operations (ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND) are decoded with absolute accuracy according to the RISC-V standard.
