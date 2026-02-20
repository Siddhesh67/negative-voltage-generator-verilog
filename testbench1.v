`timescale 1ns/1ps

module Testbench1();
    reg clk, reset;
    wire Iout;
    wire [15:0] Vneg;

    // Connect to DUT
    NegativeVoltageGen uut (
        .clk(clk),
        .reset(reset),
        .Iout(Iout),
        .Vneg(Vneg)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Initialization
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
        #100 $finish;
    end

    // Output monitoring
    initial begin
        $dumpfile("testbench1.vcd");
        $dumpvars(0, Testbench1);
        $display("Time\tclk\treset\tIout\tVneg");
        $monitor("%0t\t%b\t%b\t%b\t%d", $time, clk, reset, Iout, Vneg);
    end
endmodule
