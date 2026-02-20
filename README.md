
Topic: Verilog Design For A Partial Circuit

INTRODUCTION:
This project implements a Negative Voltage Generator using Verilog, designed with two key submodules:
Charge Pump – Used to generate negative voltage.
Current Mirror – Helps maintain a stable current.
The design is tested using three different testbenches to check its functionality under various conditions

Files In This Projects:
(Verilog Source File)- 
negative_voltage_gen.v → Main module for the negative voltage generator.

(Testbenches)
testbench1.v → Basic test without delays.
testbench2.v → Includes delays to simulate real-world behavior.
testbench3.v → Tests transistor behavior in different states.

(Output Files)-
testbench1.vcd
testbench2.vcd
testbench3.vcd

How To Run-
Run These Commands in the terminal
iverilog -o test1.out negative_voltage_gen.v testbench1.v
iverilog -o test2.out negative_voltage_gen.v testbench2.v
iverilog -o test3.out negative_voltage_gen.v testbench3.v

Running The Simulation
vvp test1.out
vvp test2.out
vvp test3.out

How To View The Waveforms (GTK Waves)
gtkwave testbench1.vcd
gtkwave testbench2.vcd
gtkwave testbench3.vcd

Final Notes:-
The project is structured to be modular and easy to debug.
Each component is tested separately before integrating into the final design.
The testbenches help analyze performance under different conditions.

