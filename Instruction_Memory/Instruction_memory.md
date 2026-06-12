# Instruction Memory (IMEM) - RV32I

This module implements the Instruction Memory for a 32-bit RISC-V processor (RV32I Architecture), written in SystemVerilog. It acts as a hardware-agnostic Read-Only Memory (ROM) that holds the compiled machine code to be executed by the processor.

## Key Features

* **Architecture:** RISC-V (RV32I).
* **Storage Capacity:** 8 Kilobytes (2048 words x 32 bits). This sizing allows modern synthesis tools (like Xilinx Vivado) to infer exactly one standard Block RAM (e.g., BRAM36E1) without consuming combinational LUTs.
* **Initialization:** Pre-loaded at synthesis/simulation time via the `$readmemh` system function, reading a standard hexadecimal memory file (`program.hex`).
* **Word-Aligned Addressing:** Implements byte-addressable translation. Since the RISC-V Program Counter increments by 4 for each 32-bit instruction, the memory matrix is indexed using `address[31:2]` to ignore the two least significant bits, effectively converting the +4 byte step into a +1 array row step.
* **Asynchronous Read:** Purely combinational data fetching. The instruction is immediately available on the output bus as soon as the input address settles.

## Testbench

The simulation module `IMEM_sim` is included, featuring automated verification through SystemVerilog assertions. A sample `program.hex` file is required to run the tests. 

Test vectors are sequentially driven to the address bus, and the module verifies the following behaviors:
1. **Accurate Data Fetching:** Confirms that addressing the memory at `0x0`, `0x4`, and `0x8` correctly retrieves the exact 32-bit hexadecimal values pre-loaded into the first three rows of the memory matrix.
