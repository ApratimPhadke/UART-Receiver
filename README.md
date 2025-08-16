
## 🚀 Project Overview

UART is a widely used protocol for **serial communication** between digital devices.
This project implements the **UART Receiver module**, which:

* ✅ Listens to the **serial input line (RXD)**
* ✅ Detects the **start bit**
* ✅ Samples the incoming **8-bit data** at the correct baud rate
* ✅ Checks the **stop bit**
* ✅ Outputs the received **parallel 8-bit data** with a **data valid flag**
* ✅ Provides a **frame error flag** when the stop bit check fails


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

<img width="1536" height="1024" alt="block diagram" src="https://github.com/user-attachments/assets/7c55802d-a6f0-4003-926a-1b802c45338f" />

## 🛠️ Schematic 
<img width="1158" height="768" alt="schematic " src="https://github.com/user-attachments/assets/245d42b5-4727-4e50-84c5-c44d5f8238b8" />

## Detailed Schematic 


<img width="1158" height="768" alt="detailed schematic " src="https://github.com/user-attachments/assets/97d98502-fb5f-4ac9-b77b-a6d27f3600d4" />

## DEVICE 

<img width="1570" height="694" alt="synthesis " src="https://github.com/user-attachments/assets/66cbdf9f-0b58-453c-a1a0-967ba47150c2" />

##POWER 

<img width="1854" height="1168" alt="power" src="https://github.com/user-attachments/assets/1bbc34f4-e361-4aae-9e60-c53614509a49" />

##TIMING 

<img width="1854" height="1168" alt="timing" src="https://github.com/user-attachments/assets/cc1db6b6-b4b8-49be-852a-6d615c1271e1" />

##TESTBENCH

<img width="1001" height="812" alt="testbench" src="https://github.com/user-attachments/assets/da628449-22a1-4fd4-a8b5-7cb507f3bd12" />

---

## ⚡ How It Works (Simplified)

1. **Idle State**: RX line is high (`1`).
2. **Start Bit Detection**: When RX goes low, start is detected.
3. **Bit Sampling**: At every baud interval, the RX line is sampled.

   * Collect **8 data bits** into a register.
4. **Stop Bit Check**:

   * If stop bit = `1` → Frame valid.
   * If
