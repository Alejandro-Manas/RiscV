# RISC-V 32I - Register File

This module implements a standard 32x32-bit register file (`File_Reg`) for a RISC-V processor (RV32I Architecture), written in SystemVerilog.

## Key Features

* **32 32-bit Registers:** Standard ISA design.
* **Zero Register (x0):** Hardwired to `0`. Writes directed to this register are automatically ignored.
* **Asynchronous Read:** 2 combinational read ports (`data_a`, `data_b`) to fetch operands in a single cycle.
* **Synchronous Write:** 1 sequential write port (`data_w`) enabled by the `we` (*Write Enable*) signal on the rising edge of the clock.

## Testbench

The simulation module `File_Reg_sim` is included, which performs automatic validations using *assertions* to guarantee hardware integrity:

1. **Register 0 Test:** Verifies that `x0` is immutable.
2. **Write Enable Test:** Checks that data is not overwritten if `we` is `0`.
3. **Read/Write Conflicts:** Validates the behavior when attempting to read and write to the same address simultaneously.
4. **Double Read:** Ensures both read ports work correctly when pointing to the same register.
5. **Random Stress Test:** Writes random values to the 31 available registers and verifies they are read correctly.
