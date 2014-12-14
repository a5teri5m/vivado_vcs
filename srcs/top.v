
`default_nettype none

module top (
    input wire clk,
    input wire [15:0]  sw,
    output reg [7:0] led
);

    wire clk_50MHz;
    wire [7:0] sw0, sw1, rev_sw0;
    wire [7:0] add;

    assign {sw1, sw0} = sw;

    always @(posedge clk_50MHz) begin
        led <= add;
    end

    clk_50MHz clk_50MHz_i (
        .clk_in1(clk),
        .clk_out1(clk_50MHz)
    );

    design_sample_wrapper design_sample_wrapper_i (
        .in0(sw0),
        .out0(rev_sw0)
    );

    adder #(
        .WIDTH(8)
    ) adder_i (
        .in0(rev_sw0),
        .in1(sw1),
        .out(add),
        .carry()
    );

endmodule
`default_nettype wire

