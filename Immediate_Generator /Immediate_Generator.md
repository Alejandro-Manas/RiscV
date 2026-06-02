# Immediate Generator (Imm_Gen) - RV32I

This module implements the Immediate Generator (`Imm_Gen`) for a RISC-V processor (RV32I Architecture), written in SystemVerilog. It is responsible for extracting, reordering, and sign-extending the immediate values embedded within the 32-bit instruction word.

## Key Features

* **Architecture:** RISC-V (RV32I).
* **Bus width:** 32 bits (inputs and outputs).
* **Design type:** Purely combinational (`always_comb`).
* **Command-Driven:** Uses a 3-bit `cmd` signal (provided by the Control Unit) to select the correct extraction format without evaluating the opcode internally.

## Supported Formats

The module correctly decodes the 32-bit `instruction` into a 32-bit sign-extended `immediate_out` for the following standard RISC-V formats:

* **`TYPE_I`** (Immediate): Extraction and 20-bit sign-extension for Arithmetic immediate and Load instructions.
* **`TYPE_S`** (Store): Recombined immediate extraction for Store instructions.
* **`TYPE_B`** (Branch): Complex bit reordering and sign-extension for conditional Branch instructions (e.g., `BEQ`, `BNE`).
* **`TYPE_U`** (Upper Immediate): Upper 20-bit extraction (padded with 12 lower zeros) for `LUI` and `AUIPC`.
* **`TYPE_J`** (Jump): Complex bit reordering and sign-extension for unconditional Jump instructions (`JAL`).

## Testbench

The simulation module `Imm_Gen_Sim` is included, which performs automatic validations using *assertions* to guarantee hardware integrity. The directed testing focuses heavily on verifying critical datapath corner cases:

1. **Absolute Extremes Test:** Injects full zeros (`32'h0000_0000`) and full ones (`32'hFFFF_FFFF`) across all formats to verify that the hardware sign extension handles absolute minimum and maximum bounds flawlessly.
2. **Alternating Bit Patterns:** Injects alternating values (`32'hAAAA_AAAA` and `32'h5555_5555`) to ensure accurate bit placement. This specifically validates the asymmetric routing required for the `TYPE_B` and `TYPE_J` formats, confirming that no logical cross-wiring exists in the System Verilog concatenation logic.
