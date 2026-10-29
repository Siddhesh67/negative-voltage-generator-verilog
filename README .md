# Negative Voltage Generator — Verilog Behavioral Model

A Verilog project exploring signed arithmetic, clocked state updates, threshold detection, and waveform-based simulation through a simplified negative-voltage-generation model.

The design represents a decreasing voltage as a signed 16-bit integer and asserts an output flag when that value passes a threshold. Three testbenches exercise startup and ramp behavior at different clock periods.

> **Scope:** This is a digital behavioral abstraction, not a transistor-level or analog simulation. `Vneg` is an integer with no defined conversion to volts, and `Iout` is a Boolean flag rather than a modeled current. The project does not establish physical voltage-generation capability or current regulation.

## Academic background

Developed for **DSM VLSI Design (16:332:578:01) at Rutgers University**, taught by Professor Yinglung Liang. The accompanying course report is titled *Negative Voltage Generating Circuit Having Automatic Voltage Adjustment Function* and identifies **US Patent 10,778,092** as its conceptual inspiration.

The learning goal was to translate selected circuit concepts into a modular digital model, connect the submodules, and inspect their behavior using simulation waveforms. This repository implements a simplified educational abstraction rather than a complete implementation of the patented circuit. The current RTL has no feedback path that adjusts the ramp based on `Iout`.

## Design overview

The top-level `NegativeVoltageGen` module connects two submodules:

| Module | Implemented behavior |
| --- | --- |
| `ChargePump` | Clears `Vneg` to zero on active-high asynchronous reset. Decreases it by 100 on each subsequent rising clock edge until it reaches −32000. |
| `CurrentMirror` | Asserts `Iout` when `Vneg` is strictly below −10000. |
| `NegativeVoltageGen` | Connects the ramp to the threshold detector and exposes both outputs. |

The submodule names reflect the circuit concepts that inspired the project. Their implementations model a numeric ramp and a comparison, not capacitor charge transfer or transistor current mirroring.

### Interface

| Signal | Direction | Type | Purpose |
| --- | --- | --- | --- |
| `clk` | Input | 1 bit | Rising-edge clock for the ramp |
| `reset` | Input | 1 bit | Active-high asynchronous reset |
| `Vneg` | Output | Signed 16 bits | Numeric representation of the negative ramp |
| `Iout` | Output | 1 bit | Indicates that `Vneg < -10000` |

### Expected behavior

Starting from reset, the ramp follows `0, -100, -200, ...` and saturates at `-32000`.

- After 100 active rising edges, `Vneg = -10000` and `Iout` remains low.
- After 101 active rising edges, `Vneg = -10100` and `Iout` becomes high.
- After 320 active rising edges, `Vneg = -32000`; subsequent updates hold this value until reset.

These values follow from the RTL. The supplied short simulations do not reach the threshold or saturation point.

## Repository contents

| File | Description |
| --- | --- |
| `negative_voltage_gen.v` | Ramp, threshold detector, and top-level module |
| `testbench1.v` | Startup simulation with a 10 ns clock period |
| `testbench2.v` | Startup simulation with a 14 ns clock period |
| `testbench3.v` | Startup simulation with a 6 ns clock period |

Each testbench prints signal values and generates a VCD waveform file when run.

## Running the simulations

Install **Icarus Verilog** (`iverilog` and `vvp`) and, optionally, **GTKWave** for waveform inspection. Run these commands from the repository directory.

### 1. Compile

```bash
iverilog -s Testbench1 -o test1.out negative_voltage_gen.v testbench1.v
iverilog -s Testbench2 -o test2.out negative_voltage_gen.v testbench2.v
iverilog -s Testbench3 -o test3.out negative_voltage_gen.v testbench3.v
```

### 2. Simulate

```bash
vvp test1.out
vvp test2.out
vvp test3.out
```

### 3. Inspect waveforms

```bash
gtkwave testbench1.vcd
gtkwave testbench2.vcd
gtkwave testbench3.vcd
```

Inspect `clk`, `reset`, `Vneg`, and `Iout`. Set the waveform radix for `Vneg` to **signed decimal** to see the negative values correctly.

## Testbench coverage

All three testbenches assert reset initially and release it after 10 ns.

| Testbench | Clock period | Run time after reset release | Focus |
| --- | --- | --- | --- |
| `Testbench1` | 10 ns | 100 ns | Initial reset and ramp behavior |
| `Testbench2` | 14 ns | 200 ns | Ramp behavior with a slower clock |
| `Testbench3` | 6 ns | 250 ns | Ramp behavior with a faster clock |

Changing the clock period changes how quickly the modeled value decreases in simulation time. It does not model analog propagation delay, switching losses, or transistor behavior.

The existing tests are waveform-based demonstrations rather than self-checking verification. They finish before the threshold is crossed, so `Iout` is expected to remain low during the post-reset ramp. They also do not exercise saturation or reset during an active ramp.

### Signed-value display

The design declares `Vneg` as signed, but the testbenches connect it to an unsigned `wire [15:0] Vneg`. Decimal console output can therefore display negative values as large positive numbers.

For signed console output, change the declaration in each testbench to:

```verilog
wire signed [15:0] Vneg;
```

Alternatively, pass `$signed(Vneg)` to the existing `$monitor` statement. These are suggested changes; the testbench files currently retain their original declarations.

## Relationship to the course report

The course report provides the motivation and modeling approach, but parts of its description differ from the current source code. This README documents the checked-in RTL.

| Topic | Course report description | Current repository implementation |
| --- | --- | --- |
| Numeric representation | Describes a high unsigned value, such as 65535, as a proxy for negative voltage | Signed 16-bit value reset to zero and decremented toward −32000 |
| Output condition | Describes `Iout` as high above a positive threshold of 10000 | `Iout` is high only when the signed value is below −10000 |
| Clock variations | Discusses delayed and high-load conditions | Changes clock period only; no gate-delay, load, or noise model is included |
| Transistor regions | Interprets the output flag in terms of transistor operating regions | Boolean threshold logic; no device equations establish physical operating regions |

The report's figures and conclusions should not be treated as verification results for the current RTL without reconciling the source versions and rerunning the simulations. In particular, the supplied test durations are too short to demonstrate threshold crossing or saturation in the current implementation.

## Skills demonstrated

- Modular Verilog design and top-level integration
- Signed arithmetic and saturation behavior
- Clocked logic with nonblocking assignments and asynchronous reset
- Combinational threshold detection
- Clock generation, console monitoring, and VCD waveform inspection

## Future improvements

- Extend simulations to at least 330 active clock cycles to observe threshold activation and saturation.
- Add automated checks for reset, decrement size, strict threshold behavior, and clamp stability.
- Exercise reset after threshold activation and after saturation.
- Correct signed signal declarations in the testbenches.
- Parameterize the decrement, threshold, and saturation level.
- Use an analog simulation environment for any future study of capacitor dynamics, output ripple, load response, or transistor-level current mirroring.

## Author

[Siddhesh Saraf](https://github.com/Siddhesh67)
