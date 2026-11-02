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