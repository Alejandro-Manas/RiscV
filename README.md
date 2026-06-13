# RV32I Single-Core Processor

A single-cycle 32-bit RISC-V processing core implementing the unprivileged **RV32I Base Integer Instruction Set** written in SystemVerilog. The microarchitecture is designed as a pure IP processing block focused on structural modularity, clean datapath steering, and explicit industry-standard compliance.

---

## Core Specifications

* **ISA:** RISC-V (RV32I unprivileged user-level ISA).
* **Microarchitecture:** Single-cycle execution matrix.
* **Architecture Type:** Pure Harvard structure (strictly isolated, independent Instruction and Data memory addressing spaces).
* **Application Profile:** Bare-metal native execution.
* **Verification Grade:** 100% compliant with official RISC-V International architectural test vectors.

---

## Project Directory Structure

The repository is organized into isolated, self-contained functional subdirectories. You can navigate through the individual architectural components below:

* [`ALU/`](ALU/ALU.md) – Arithmetic Logic Unit executing integer math, shifts, and comparisons.
* [`ALU_Decoder/`](ALU_Decoder/ALU_Decoder.md) – Dedicated operational decoder generating specific ALU instruction signals.
* [`Control_Unit/`](Control_Unit/Control_Unit.md) – Centralized combinational translation matrix decoding instruction fields to drive global routing flags.
* [`Data_Memory/`](Data_Memory/Data_Memory.md) – Local byte-enabled RAM simulation block (`DMEM.sv`) featuring asynchronous reads and byte-masked synchronous writes.
* [`Global_Test/`](Global_Test/Global_Test.md) – Exclusive system-level verification suite containing the pre-compiled official RISC-V architectural compliance `.hex` vectors and the top testbench wrapper (`Top_Module_sim.sv`).
* [`Immediate_Generator/`](Immediate_Generator/Immediate_Generator.md) – Sign-extension unit formatting constant values dynamically based on instruction types (`I`, `S`, `B`, `U`, `J`).
* [`Instruction_Memory/`](Instruction_Memory/Instruction_memory.md) – Local ROM simulation block (`IMEM.sv`) hosting executable firmware binaries.
* [`Load_Store_Unit/`](Load_Store_Unit/Load_Store_Unit.md) – Structural memory alignment administrator managing unaligned byte, half-word, and word memory transactions.
* [`Program_Counter/`](Program_Counter/Program_Counter.md) – Upstream synchronous register updating sequential execution (`PC + 4`) or target branch/jump addresses.
* [`Top_Module/`](Top_Module/Top_Module.md) – The root structural entity.

---

## Technical Highlights & Microarchitecture

Based on the low-level module implementation, the processor integrates several advanced digital design choices:

* **Hardwired Zero Register ($x0$):** The Register File (`File_Reg.sv`) physically excludes storage allocation for register `0` (`mem_reg[31:1]`). A combinational block forces `data_a` and `data_b` to zero whenever $x0$ is addressed, ensuring strict standard compliance while saving physical flip-flop resources.
* **Synchronous Edge-Triggered Logic:** The Program Counter and the Register File operate on a pure synchronous execution model driven exclusively by the positive edge of the global clock, featuring a synchronous active-low reset (`rst_n`).
* **Byte-Masked Single-Cycle RAM:** The Data Memory (`DMEM.sv`) supports byte-level write granularity using a 4-bit write-enable mask (`we[3:0]`). This directly facilitates the integration of fractional store instructions (`sb`, `sh`) within a single clock period via asynchronous data reads.

---

## Design Scope & Limitations

To maintain a clean microarchitecture focused on core execution principles, the following design boundaries were established:

* **Processing Core vs. MCU:** This design represents a pure processing IP block, not a full commercial microcontroller. It instantiates internal tightly-coupled memory structures for hardware simulation and lacks general-purpose I/O (GPIO) pins or external peripheral buses at the top layer.
* **Bare-Metal Focus:** The processor is engineered exclusively for raw native execution. It does not include privileged architecture components, such as Control and Status Registers (CSRs) for exception/interrupt handling, Supervisor Mode privileges, or a Memory Management Unit (MMU) for virtual memory. Therefore, it is **not** capable of deploying complex operating systems like Linux.
* **Memory Consistency:** Operating as a structural single-cycle core with decoupled memory spaces, it omits complex memory ordering fences (`FENCE`, `FENCE.I`), assuming static, non-self-modifying program vectors.

---

## Verification Suite

Processor correctness and strict ISA alignment were verified against the **Official RISC-V Architecture Compliance Test Suite** provided by RISC-V International. 

Rather than relying on non-exhaustive, custom-written simulation routines, the top-level entity was evaluated systematically, function-by-function, using official pre-compiled hexadecimal binary vectors:
1. **Targeted Testing:** Individual test streams located under the `Global_Test/` directory were loaded into the `IMEM` to thoroughly stress arithmetic boundaries, logical bitwise operations, signed/unsigned comparisons, memory wrap-around offsets, and conditional branching edge cases.
2. **Bit-Accurate Enforcement:** Every instruction execution cycle was audited within the simulation environment, confirming that internal register state transitions, datapath selections, and memory byte-alignment writes precisely match the gold-standard reference footprint of the RISC-V ISA.

---

## Tools and Workflow

* **Hardware Description Language:** SystemVerilog
* **Primary EDA Toolchain:** Designed, simulated, and structurally verified using **AMD Xilinx Vivado**.
* **Framework Compatibility:** Written in portable, synthesizable IEEE 1800 SystemVerilog, maintaining full compliance for alternative deployment in Intel Quartus Prime or ModelSim/QuestaSim environments.

---

## Future Roadmap

The development of this RV32I core is structured around two distinct evolutionary tracks aimed at shifting the architecture from a functional single-cycle baseline into a high-performance, system-level design:

### Track 1: Microarchitectural Optimization (High-Performance Core)
* **5-Stage Pipelining:** Transition the single-cycle execution into a classic 5-stage RISC pipeline (`Fetch`, `Decode`, `Execute`, `Memory`, `Writeback`).
* **Hazard Resolution Logic:** Design and integrate a dedicated hazard detection and forwarding unit to resolve data dependencies dynamically (structural stalls and bypass networks) and mitigate control hazards caused by branch mispredictions via pipeline flushing mechanics.

### Track 2: System-on-Chip (SoC) & MCU Expansion
* **Memory-Mapped GPIO:** Expose physical pin interfaces to the top layer by mapping hardware registers into the `DMEM` address space, enabling full unprivileged software control over software-defined inputs and outputs.
* **Bare-Metal Software Libraries:** Develop native C driver abstraction layers to facilitate clean peripheral access and register manipulation.
* **UART Bootloader & Dynamic IMEM Reprogramming:** Integrate an autonomous UART hardware peripheral capable of capturing incoming binary streams to overwrite the internal Instruction Memory (`IMEM`) dynamically on-chip, achieving a fully self-contained, field-reprogrammable Microcontroller Unit (MCU).
