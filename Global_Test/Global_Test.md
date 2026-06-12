# Global Test

This directory serves as the exclusive repository for the official, pre-compiled 32-bit hexadecimal instruction vectors (`*.hex`) used to drive full-system validation and ISA compliance testing on the `Top_Module`.

## Directory Purpose

This folder contains **only** the raw firmware binaries derived from the official RISC-V Architecture Compliance Suite. Unlike individual unit tests which reside locally within their respective module folders (e.g., `ALU/`, `File_Reg/`), these files are used strictly for top-level, end-to-end simulation of the completed single-cycle core.

## File Format Specifications

To ensure seamless compatibility with hardware simulation environments and EDA tooling, all files in this directory adhere to the following formatting rules:
* **Word Width:** 32-bit raw hexadecimal characters representing architectural instructions.

