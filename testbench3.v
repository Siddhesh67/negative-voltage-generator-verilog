`timescale 1ns/1ps

module Testbench3();
    reg clk, reset;
    wire Iout;
    wire [15:0] Vneg;

    NegativeVoltageGen uut (
        .clk(clk),
        .reset(reset),
        .Iout(Iout),
        .Vneg(Vneg)
    );

    // Fast clock: 3ns toggle simulates rapid operation
    always #3 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
        #250 $finish;
    end

    initial begin
        $dumpfile("testbench3.vcd");
        $dumpvars(0, Testbench3);
        $display("Time\tclk\treset\tIout\tVneg");
        $monitor("%0t\t%b\t%b\t%b\t%d", $time, clk, reset, Iout, Vneg);
    end
endmodule
