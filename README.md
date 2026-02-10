# 🧱 Synchronous FIFO (Verilog)

A clean and synthesizable **synchronous FIFO (First-In First-Out)** implemented in Verilog HDL.  
This project demonstrates core FIFO concepts used in real RTL designs such as **UART buffering**, producer–consumer pipelines, and data rate matching between blocks operating in the same clock domain.

---

## 📌 Overview
- Single clock **synchronous FIFO**
- Circular buffer implementation
- Supports **simultaneous read and write**
- Full and Empty status flags
- Registered read output (1-cycle latency)
- Verified using a timing-correct testbench

---

## ✨ Features
- One write per clock when `wr_en && !full`
- One read per clock when `rd_en && !empty`
- Pointer-based full/empty detection using extra MSB
- FIFO ordering strictly preserved
- Simple, readable, and synthesizable RTL

---

## 🧠 Architecture

### Internal Blocks
- **Memory**: 8 × 8-bit register array
- **Write Pointer (`wr_ptr`)** with wrap-around MSB
- **Read Pointer (`rd_ptr`)** with wrap-around MSB
- **Status Logic** for `full` and `empty`

### Pointer Logic
- Lower bits → memory index
- MSB → wrap detection
- Prevents ambiguity between full and empty conditions


### RTL Linting and Compilation

The Register Transfer Level (RTL) design was written in SystemVerilog and first verified for language correctness and coding quality.  
The following tools were used:

- **Slang** was used for SystemVerilog parsing, compilation, and RTL linting. It was primarily used to detect syntax errors, unresolved references, and potential RTL coding issues early in the design process.
- **Verilator** was used as an additional linting and sanity-check tool. Verilator was applied to both RTL and gate-level netlists to ensure structural correctness, proper module connectivity, and compatibility with synthesizable SystemVerilog constructs.

Using both Slang and Verilator helped ensure that the design was clean, well-formed, and suitable for synthesis.

---

### RTL Synthesis and Technology Mapping

After successful linting and verification, the RTL design was synthesized using **Yosys**.  
Yosys was used to perform logic synthesis, optimization, and technology mapping.

The synthesized design was mapped to a standard-cell library targeting a 45 nm technology node using the following library:

- **Standard Cell Library:** `nandgate45_fast.lib`

This step converts the high-level RTL description into a gate-level netlist composed of standard logic cells from the target technology library.
