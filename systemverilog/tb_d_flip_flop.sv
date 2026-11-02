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

    // Clock generation
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