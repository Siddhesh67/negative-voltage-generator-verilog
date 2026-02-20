`timescale 1ns/1ps

module Testbench2();
    reg clk, reset;
    wire Iout;
    wire [15:0] Vneg;

    NegativeVoltageGen uut (
        .clk(clk),
        .reset(reset),
        .Iout(Iout),
        .Vneg(Vneg)
    );

    // Clock with slightly slower toggle to simulate delay
    always #7 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;
        #200 $finish;
    end

    initial begin
        $dumpfile("testbench2.vcd");
        $dumpvars(0, Testbench2);
        $display("Time\tclk\treset\tIout\tVneg");
        $monitor("%0t\t%b\t%b\t%b\t%d", $time, clk, reset, Iout, Vneg);
    end
endmodule
