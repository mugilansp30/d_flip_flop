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

        // Initialize signals
        clk = 0;
        reset = 1;
        d = 0;

        // Release reset
        #10 reset = 0;

        // Test Case 1: D = 1
        #10 d = 1;

        // Test Case 2: D = 0
        #10 d = 0;

        // Test Case 3: D = 1
        #10 d = 1;

        // Test Case 4: D = 0
        #10 d = 0;

        // Test asynchronous reset
        #3 reset = 1;
        #5 reset = 0;

        // Finish simulation
        #20 $finish;

    end

endmodule