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
