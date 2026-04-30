<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This design implements a **fixed-point Henon map generator** with **serial output interfaces** for both state variables.

### Core functionality

The circuit computes the discrete-time Henon map:

x(n+1) = 1 - a·x(n)^2 + y(n)  
y(n+1) = b·x(n)

with constants:
- a = 1.4  
- b = 0.3  

The implementation uses:
- Fixed-point arithmetic (Q2.8 format)
- 10-bit signed representation (WIDTH = 10, FRAC = 8)

---

### Internal operation

#### Henon map block

- When `ena_henon = 1`, the system computes a new iteration every clock cycle.
- Outputs:
  - `x_out`: next x value
  - `y_out`: next y value
  - `done_henon`: indicates valid output (1 cycle pulse)

- When `rst_n = 0`:
  - Internal registers are reset to zero

---

#### Serialization blocks

Each variable (`x_out`, `y_out`) is serialized independently.

- `ena_ser_x` and `ena_ser_y` act as start signals
- On activation:
  - The 10-bit value is loaded
  - Data is shifted out LSB first
  - One bit per clock cycle

Outputs:
- `Q_ser_x`, `Q_ser_y`: serial data streams
- `eos_x`, `eos_y`: end-of-sequence signals (1 cycle pulse)

---

### Data flow summary

1. Enable Henon computation:
   - `ena_henon = 1`
2. Wait for valid output:
   - `done_henon = 1`
3. Trigger serialization:
   - `ena_ser_x = 1` → serialize `x_out`
   - `ena_ser_y = 1` → serialize `y_out`
4. Read serial outputs:
   - Bits appear on `Q_ser_x` / `Q_ser_y`
   - `eos_*` indicates completion


## How to test

### 1. Reset the system

Set:
- `rst_n = 0` for a few clock cycles  
- Then set `rst_n = 1`

Initial state:
x = 0, y = 0

---

### 2. Generate Henon data

Set:
- `ena_henon = 1`

Then:
- New values are generated every clock cycle
- `done_henon` indicates valid outputs

---

### 3. Capture a sample

Wait until:
- `done_henon = 1`

At that moment:
- `x_out` and `y_out` contain valid data

---

### 4. Serialize X output

1. Pulse:
   ena_ser_x = 1 (for 1 clock cycle)

2. Then:
   ena_ser_x = 0

3. Observe:
- `Q_ser_x`: outputs 10 bits (LSB first)
- One bit per clock cycle

4. Wait for:
- `eos_x = 1`

---

### 5. Serialize Y output

Repeat the same process:

1. Pulse:
   ena_ser_y = 1

2. Read:
- `Q_ser_y`

3. Wait for:
- `eos_y = 1`

---

### 6. Expected behavior

- First outputs may be zero due to initialization
- Subsequent values follow Henon chaotic dynamics
- Serial output:
  - 10 bits per value
  - LSB first
  - `eos_*` marks completion
 
### How to connect

Using the Tiny Tapeout demo board:

- Inputs (via GPIO or switches):
  - `rst_n` → reset control
  - `ena_henon` → enable Henon computation
  - `ena_ser_x` → start serialization of x
  - `ena_ser_y` → start serialization of y

- Outputs:
  - `Q_ser_x`, `Q_ser_y` → serial data outputs
  - `eos_x`, `eos_y` → end-of-sequence indicators

### Notes

- Always apply reset before starting
- Avoid triggering serialization and computation at the exact same cycle
- Outputs are fixed-point signed values (Q2.8 format)




## External hardware

To test this design on real hardware, the following is required:

### Required hardware

- Tiny Tapeout demo board (with the fabricated chip installed)
- USB cable for power and communication
- A computer to configure and monitor the board

---

### Optional but recommended

- Logic analyzer (recommended) to observe serial outputs:
  - `Q_ser_x`
  - `Q_ser_y`

- Alternatively:
  - LEDs (to visualize activity)
  - Oscilloscope (to inspect timing and bitstream)
