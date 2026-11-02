module d_flip_flop (
    input  logic clk,
    input  logic reset,
    input  logic d,
    output logic q,
    output logic q_bar
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            q <= 1'b0;
        else
            q <= d;
    end

    assign q_bar = ~q;

endmodule