# Cache Controller Verification using SystemVerilog

A SystemVerilog class-based verification project for a **Direct-Mapped Cache Controller** implementing **write-back** and **write-allocate** policies. The project features a modular verification environment with directed and constrained-random testing, along with a self-checking scoreboard to automatically validate DUT functionality.

---

## Project Overview

This project verifies the functionality of a **Direct-Mapped Cache Controller** designed using RTL and tested using a class-based SystemVerilog verification environment.

The verification environment includes:

- Directed test cases
- Constrained-random stimulus generation
- Self-checking scoreboard
- Reference model
- Functional monitoring
- Hit/Miss verification
- Write-back policy verification
- Write-allocate policy verification

---

# Features

- Direct-Mapped Cache Architecture
- 4 Cache Lines
- 8-bit Address
- 8-bit Data Width
- Tag and Index Address Decoding
- Write-Back Cache Policy
- Write-Allocate Policy
- Cache Hit Detection
- Cache Miss Handling
- Directed Verification
- Constrained-Random Verification
- Self-Checking Scoreboard
- Modular Class-Based Testbench

---

# Project Structure

```text
Cache-Controller-Verification-SystemVerilog
│
├── RTL
│   └── cache_controller.sv
│
├── Verification
│   ├── cache_transaction.sv
│   ├── cache_generator.sv
│   ├── cache_driver.sv
│   ├── cache_monitor.sv
│   ├── cache_scoreboard.sv
│   ├── cache_agent.sv
│   ├── cache_environment.sv
│   ├── cache_test.sv
│   ├── cache_if.sv
│   └── tb_top.sv
│
├── Results
│   ├── simulation_log.txt
│   ├── simulation_output.png
│   └── scoreboard_report.png
│
├── Waveforms
│   ├── cache_waveform.png
│   └── README.md
│
├── Architecture
│   ├── cache_architecture.png
│   └── verification_environment.png
│
└── README.md
```

---

# Cache Architecture

The cache controller uses a **Direct-Mapped Cache** organization consisting of four cache lines. Each memory address is divided into **Tag** and **Index** fields for cache lookup. The controller supports both **write-back** and **write-allocate** cache policies.

<p align="center">
<img src="Architecture/cache_architecture.png" width="700">
</p>

---

# Verification Environment

The verification environment is developed using a modular, class-based SystemVerilog architecture. Transactions are generated, driven to the DUT, monitored, and verified automatically using a self-checking scoreboard.

<p align="center">
<img src="Architecture/verification_environment.png" width="700">
</p>

---

# Verification Components

| Component | Description |
|-----------|-------------|
| Transaction | Defines read/write cache transactions. |
| Generator | Generates directed and constrained-random transactions. |
| Driver | Drives transactions to the DUT through the interface. |
| Monitor | Observes DUT responses and forwards them to the scoreboard. |
| Scoreboard | Compares DUT outputs with the reference model and reports PASS/FAIL. |
| Agent | Groups generator, driver and monitor components. |
| Environment | Connects the verification components. |
| Test | Creates the environment and starts verification. |
| Interface | Connects the DUT and verification environment. |
| DUT | Direct-Mapped Cache Controller RTL. |

---

# Verification Flow

```text
Generator
     │
     ▼
Driver
     │
     ▼
Interface
     │
     ▼
Cache Controller (DUT)
     │
     ▼
Monitor
     │
     ▼
Scoreboard
     │
     ▼
PASS / FAIL Report
```

---

# Simulation Waveform

The waveform demonstrates:

- Reset operation
- Cache Read
- Cache Write
- Cache Hit
- Cache Miss
- Address Decoding
- Tag Generation
- Index Generation
- Write-Back Operation
- Write-Allocate Operation

<p align="center">
<img src="Waveforms/cache_waveform.png.png" width="1000">
</p>

---

# Simulation Output

Simulation completed successfully without compilation or runtime errors.

<p align="center">
<img src="Results/simulation_output.png.png" width="900">
</p>

---

# Scoreboard Report

The self-checking scoreboard successfully verified all generated transactions.

### Final Verification Result

| Metric | Result |
|---------|--------|
| PASS | 20 |
| FAIL | 0 |

<p align="center">
<img src="Results/scoreboard_report.png.png" width="650">
</p>

---

# Tools Used

| Tool | Purpose |
|------|---------|
| SystemVerilog | RTL and Verification |
| QuestaSim 2025.2 | Simulation |
| EPWave | Waveform Viewing |
| GitHub | Version Control |

---

# Verification Highlights

- RTL Design Verification
- Class-Based Verification
- Modular Testbench Architecture
- Directed Testcases
- Constrained-Random Testing
- Automatic Scoreboard Checking
- Reference Model Based Verification
- Cache Hit/Miss Validation
- Write-Back Policy Verification
- Write-Allocate Policy Verification

---

# Future Enhancements

- Functional Coverage
- Code Coverage
- Assertion-Based Verification (SVA)
- UVM-Based Verification Environment
- Multi-Level Cache Verification
- Randomized Regression Testing

---

# Author

**Saniya Vafeeka**

Final Year B.E. Electronics and Communication Engineering

Interested in:

- Digital Design
- RTL Design
- SystemVerilog Verification
- VLSI Design Verification

GitHub: https://github.com/Saniyavafeeka09

---

## License

This project is licensed under the MIT License.
