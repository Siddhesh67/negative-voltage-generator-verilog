// Negative Voltage Generating Circuit with signed Vneg

// Charge Pump Module with signed output
module ChargePump(
    input clk, reset,
    output reg signed [15:0] Vneg
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            Vneg <= 16'sd0; // Start at 0V
        else if (Vneg > -16'sd32000)
            Vneg <= Vneg - 16'sd100; // Simulate stepwise drop to negative
        else
            Vneg <= -16'sd32000; // Clamp to -32000
    end
endmodule

// Current Mirror Module (threshold for turning Iout ON)
module CurrentMirror(
    input signed [15:0] Vneg,
    output reg Iout
);
    always @(*) begin
        if (Vneg < -16'sd10000) // When it's sufficiently negative
            Iout = 1;
        else
            Iout = 0;
    end
endmodule

// Top-Level Module
module NegativeVoltageGen(
    input clk, reset,
    output Iout,
    output signed [15:0] Vneg
);
    ChargePump cp (
        .clk(clk),
        .reset(reset),
        .Vneg(Vneg)
    );

    CurrentMirror cm (
        .Vneg(Vneg),
        .Iout(Iout)
    );
endmodule
