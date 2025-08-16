---

## 🚀 Project Overview

UART is a widely used protocol for **serial communication** between digital devices.
This project implements the **UART Receiver module**, which:

* ✅ Listens to the **serial input line (RXD)**
* ✅ Detects the **start bit**
* ✅ Samples the incoming **8-bit data** at the correct baud rate
* ✅ Checks the **stop bit**
* ✅ Outputs the received **parallel 8-bit data** with a **data valid flag**
* ✅ Provides a **frame error flag** when the stop bit check fails

---

## 🛠️ Block Diagram

Here’s the simplified logic of how it works:

```
      ┌─────────────┐
      │   Start Bit │  → Detect falling edge → Enable sampling
      └──────┬──────┘
             │
             ▼
      ┌─────────────┐
      │   Shift Reg │  → Collect 8 bits at baud intervals
      └──────┬──────┘
             │
             ▼
      ┌─────────────┐
      │   Stop Bit  │  → Validate frame
      └──────┬──────┘
             │
             ▼
      ┌─────────────┐
      │  Data Out   │  → Parallel 8-bit + Data Valid Flag + Error Flag
      └─────────────┘
```

---

## 📂 Repository Structure

```
📁 UART-Receiver
 ┣ 📄 uart_receiver.v     # Main UART Receiver Verilog code
 ┣ 📄 tb_uart_receiver.v  # Testbench for simulation
 ┣ 📄 README.md           # Documentation (this file)
 ┗ 📄 waveform.png        # Example simulation waveform
```

---

## ⚡ How It Works (Simplified)

1. **Idle State**: RX line is high (`1`).
2. **Start Bit Detection**: When RX goes low, start is detected.
3. **Bit Sampling**: At every baud interval, the RX line is sampled.

   * Collect **8 data bits** into a register.
4. **Stop Bit Check**:

   * If stop bit = `1` → Frame valid.
   * If
