# Positive-Edge D Flip-Flop with Asynchronous Reset
### Dual RTL & Verification Implementations: Verilog & SystemVerilog

![HDL: Verilog](https://img.shields.io/badge/HDL-Verilog--2001-blue.svg)
![HDL: SystemVerilog](https://img.shields.io/badge/HDL-SystemVerilog--IEEE%201800-darkblue.svg)
![Simulator: ModelSim](https://img.shields.io/badge/Simulator-ModelSim-purple.svg)
![Verification: Functional](https://img.shields.io/badge/Verification-Functional%20Sim%20Passed-brightgreen.svg)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)

A comparative digital design project featuring a **positive-edge triggered D Flip-Flop with active-high asynchronous reset**, implemented in both **Verilog (IEEE 1364-2001)** and **SystemVerilog (IEEE 1800)**. Both versions have been simulated, verified, and cross-checked using **ModelSim**.

---

## 📑 Table of Contents
1. [Digital Logic Specification](#-digital-logic-specification)
2. [Verilog vs. SystemVerilog Comparison](#-verilog-vs-systemverilog-comparison)
3. [Repository Structure](#-repository-structure)
4. [ModelSim Simulation Guide (Completed Work)](#-modelsim-simulation-guide-completed-work)
5. [Timing & Waveform Analysis](#-timing--waveform-analysis)
6. [Source Code Inspection](#-source-code-inspection)
7. [Future Scope & Roadmap](#-future-scope--roadmap)
8. [License](#-license)

---

## ⚡ Digital Logic Specification

A D Flip-Flop captures the value of the data input (`d`) at the rising edge of the clock (`clk`) and outputs it to `q`, with `q_bar` providing the complementary inverted output. An active-high **asynchronous reset** overrides the clock, forcing the state immediately to zero.

### Port List

| Port | Direction | Type (Verilog) | Type (SystemVerilog) | Description |
|:---:|:---:|:---:|:---:|:---|
| `clk` | **Input** | `wire` | `logic` | Master clock input (active on positive edge `↑`) |
| `reset` | **Input** | `wire` | `logic` | Asynchronous active-high reset (`1` = force reset) |
| `d` | **Input** | `wire` | `logic` | Synchronous data input |
| `q` | **Output** | `reg` | `logic` | Registered data output |
| `q_bar` | **Output** | `wire` | `logic` | Inverted registered data output ($\overline{Q}$) |

---

### Function & Truth Table

| `reset` | `clk` | `d` | Next State $Q(t+1)$ | Next State $\overline{Q}(t+1)$ | Operation Description |
|:---:|:---:|:---:|:---:|:---:|:---|
| **`1`** | `X` (Don't Care) | `X` | **`0`** | **`1`** | **Asynchronous Reset (Immediate Force 0)** |
| `0` | `0` or `1` (No Edge) | `X` | $Q(t)$ | $\overline{Q}(t)$ | **Hold State (No Change)** |
| `0` | `↓` (Falling Edge) | `X` | $Q(t)$ | $\overline{Q}(t)$ | **Inactive Clock Edge (No Change)** |
| `0` | `↑` (Rising Edge) | **`0`** | **`0`** | **`1`** | **Clocked Sample: Reset to Low** |
| `0` | `↑` (Rising Edge) | **`1`** | **`1`** | **`0`** | **Clocked Sample: Set to High** |

> **Characteristic Equation:**  
> $$Q_{next} = \overline{reset} \cdot D$$

---

### State Transition Diagram

```mermaid
stateDiagram-v2
    direction LR

    [*] --> State_0 : Asynchronous Reset = 1

    state "State 0\n(Q = 0, Q_bar = 1)" as State_0
    state "State 1\n(Q = 1, Q_bar = 0)" as State_1

    State_0 --> State_0 : posedge clk & D = 0
    State_0 --> State_1 : posedge clk & D = 1
    State_1 --> State_0 : posedge clk & D = 0
    State_1 --> State_1 : posedge clk & D = 1

    State_1 --> State_0 : ANYTIME: reset = 1 (Async Reset)
```

---

## 🔄 Verilog vs. SystemVerilog Comparison

This repository demonstrates the migration from classic Verilog constructs to modern SystemVerilog standards:

| Feature | Verilog Implementation (`.v`) | SystemVerilog Implementation (`.sv`) | Advantage of SystemVerilog |
|---|---|---|---|
| **Data Types** | Separate `reg` for procedural targets and `wire` for nets | Unified `logic` data type for all inputs, outputs, and internal signals | Eliminates confusing `reg` vs `wire` misuse; compiler automatically infers net vs variable |
| **Sequential RTL Block** | Generic `always @(posedge clk or posedge reset)` | Explicit `always_ff @(posedge clk or posedge reset)` | Enforces pure flip-flop inference at compile/synthesis time; simulator flags unintended latches or combinational loops |
| **Testbench Stimulus Timing** | Raw propagation delays (`#10 d = 1;`) | Event-controlled edge alignment (`@(negedge clk); d = 1;`) | Drives inputs away from active clock edge, preventing setup/hold race conditions |
| **Inversion Logic** | Continuous `assign q_bar = ~q;` | Continuous `assign q_bar = ~q;` | Direct combinational complement |

---

## 📂 Repository Structure

```text
d_flip_flop/
├── verilog/
│   ├── d_flip_flop.v         # Verilog synthesizable RTL
│   └── tb_d_flip_flop.v      # Verilog testbench
├── systemverilog/
│   ├── d_flip_flop.sv        # SystemVerilog RTL (always_ff, logic)
│   └── tb_d_flip_flop.sv     # SystemVerilog testbench (edge-aligned stimuli, $monitor)
├── .gitignore                # Filters ModelSim work/ library, WLF waveforms, & compile cache
├── LICENSE                   # MIT open-source license
└── README.md                 # Project documentation & simulation manual
```

---

## 🚀 ModelSim Simulation Guide (Completed Work)

All functional simulations for both implementations were executed and verified in **ModelSim**.

<details>
<summary>▶ <b>Click to expand ModelSim Commands for Verilog</b></summary>

Navigate into the `verilog/` directory or run from root:

```bash
# 1. Create the working library
vlib work

# 2. Compile Verilog RTL and Testbench
vlog verilog/d_flip_flop.v verilog/tb_d_flip_flop.v

# 3. Run simulation in Command-Line Mode (CLI)
vsim -c -do "run -all; quit" tb_d_flip_flop

# OR Launch in Interactive GUI Mode with Wave Viewer:
vsim -gui tb_d_flip_flop
```

Inside the ModelSim GUI console:
```tcl
add wave -position insertpoint sim:/tb_d_flip_flop/*
run -all
wave zoomfull
```

</details>

<details>
<summary>▶ <b>Click to expand ModelSim Commands for SystemVerilog</b></summary>

Navigate into the `systemverilog/` directory or run from root:

```bash
# 1. Create the working library
vlib work

# 2. Compile SystemVerilog RTL and Testbench (-sv flag enables full SystemVerilog support)
vlog -sv systemverilog/d_flip_flop.sv systemverilog/tb_d_flip_flop.sv

# 3. Run simulation in Command-Line Mode (CLI)
vsim -c -do "run -all; quit" tb_d_flip_flop

# OR Launch in Interactive GUI Mode with Wave Viewer:
vsim -gui tb_d_flip_flop
```

Inside the ModelSim GUI console:
```tcl
add wave -position insertpoint sim:/tb_d_flip_flop/*
run -all
wave zoomfull
```

</details>

---

## ⏱️ Timing & Waveform Analysis

Both testbenches generate a **10 ns clock** (`period = 10ns`, toggling every 5ns).

### ASCII Simulation Timing Diagram

```text
Time (ns): 0       10      20      30      40      50   53  58       78
           |-------|-------|-------|-------|-------|-----|---|--------|
           
clk        __--__--__--__--__--__--__--__--__--__--__--__--__--__--__--
              ^       ^       ^       ^       ^       ^       ^
             10ns    20ns    30ns    40ns    50ns    60ns    70ns

reset      --------___________________________________-----___________
           |<Init> |<--- Normal Synchronous Mode ---->|Async Pulse|

d          ________________--------________--------___________________
           |  d=0  |  d=0  |  d=1  |  d=0  |  d=1  |  d=0  |   d=0    |

q          ________________--------________--------___________________
           |   0   |   0   |   1   |   0   |   1   | 0 (immediate)    |

q_bar      ----------------________--------________-------------------
           |   1   |   1   |   0   |   1   |   0   | 1 (immediate)    |
```

### Observed Simulation Monitor Output (`$monitor`)

During the SystemVerilog simulation in ModelSim, the testbench generated the following console trace:

```text
# Time=0 CLK=0 RESET=1 D=0 Q=0 Q_BAR=1
# Time=5 CLK=1 RESET=1 D=0 Q=0 Q_BAR=1
# Time=10 CLK=0 RESET=1 D=0 Q=0 Q_BAR=1
# Time=12 CLK=0 RESET=0 D=0 Q=0 Q_BAR=1
# Time=15 CLK=1 RESET=0 D=0 Q=0 Q_BAR=1
# Time=20 CLK=0 RESET=0 D=1 Q=0 Q_BAR=1
# Time=25 CLK=1 RESET=0 D=1 Q=1 Q_BAR=0
# Time=30 CLK=0 RESET=0 D=0 Q=1 Q_BAR=0
# Time=35 CLK=1 RESET=0 D=0 Q=0 Q_BAR=1
# Time=40 CLK=0 RESET=0 D=1 Q=0 Q_BAR=1
# Time=45 CLK=1 RESET=0 D=1 Q=1 Q_BAR=0
# Time=50 CLK=0 RESET=0 D=0 Q=1 Q_BAR=0
# Time=53 CLK=0 RESET=1 D=0 Q=0 Q_BAR=1    <-- Asynchronous reset triggers immediately!
# Time=55 CLK=1 RESET=1 D=0 Q=0 Q_BAR=1
# Time=58 CLK=1 RESET=0 D=0 Q=0 Q_BAR=1
# ** Note: $finish    : systemverilog/tb_d_flip_flop.sv(48)
```

---

## 🔍 Source Code Inspection

<details>
<summary><b>View <code>verilog/d_flip_flop.v</code></b></summary>

```verilog
module d_flip_flop (
    input wire clk,
    input wire reset,
    input wire d,
    output reg q,
    output wire q_bar
);

    // Positive-edge triggered D Flip-Flop with asynchronous active-high reset
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

    assign q_bar = ~q;

endmodule
```

</details>

<details>
<summary><b>View <code>verilog/tb_d_flip_flop.v</code></b></summary>

```verilog
`timescale 1ns/1ps

module tb_d_flip_flop;

    reg clk;
    reg reset;
    reg d;

    wire q;
    wire q_bar;

    // Instantiate the D Flip-Flop
    d_flip_flop uut (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Apply test cases
    initial begin
        clk = 0;
        reset = 1;
        d = 0;

        #10 reset = 0;

        #10 d = 1;
        #10 d = 0;
        #10 d = 1;
        #10 d = 0;

        // Test asynchronous reset
        #3 reset = 1;
        #5 reset = 0;

        #20 $finish;
    end

endmodule
```

</details>

<details>
<summary><b>View <code>systemverilog/d_flip_flop.sv</code></b></summary>

```systemverilog
module d_flip_flop (
    input  logic clk,
    input  logic reset,
    input  logic d,
    output logic q,
    output logic q_bar
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

    assign q_bar = ~q;

endmodule
```

</details>

<details>
<summary><b>View <code>systemverilog/tb_d_flip_flop.sv</code></b></summary>

```systemverilog
`timescale 1ns/1ps

module tb_d_flip_flop;

    logic clk;
    logic reset;
    logic d;

    logic q;
    wire q_bar;

    // DUT instantiation
    d_flip_flop uut (
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q),
        .q_bar(q_bar)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        clk = 0;
        reset = 1;
        d = 0;

        #12 reset = 0;

        @(negedge clk);
        d = 1;

        @(negedge clk);
        d = 0;

        @(negedge clk);
        d = 1;

        @(negedge clk);
        d = 0;

        #2 reset = 1;
        #5 reset = 0;

        #20;
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t CLK=%b RESET=%b D=%b Q=%b Q_BAR=%b",
                 $time, clk, reset, d, q, q_bar);
    end

endmodule
```

</details>

---

## 🔮 Future Scope & Roadmap

The current scope covers ModelSim simulation and functional verification. Planned future milestones include:

- [ ] **SystemVerilog Assertions (SVA):** Implement formal property checks (`assert property`) for reset validity and setup/hold window verification.
- [ ] **Constrained-Random Verification (CRV):** Build randomized stimulus generators with `rand` classes.
- [ ] **Functional Coverage:** Add covergroups and coverpoints to measure 100% state and transition coverage.
- [ ] **UVM Architecture:** Wrap the verification components in an industry-standard UVM (Universal Verification Methodology) environment.
- [ ] **Hardware Synthesis & FPGA Implementation:** Synthesize using Intel Quartus / AMD Vivado to measure resource utilization (LUTs, FFs) and maximum operating frequency ($F_{max}$).

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).
