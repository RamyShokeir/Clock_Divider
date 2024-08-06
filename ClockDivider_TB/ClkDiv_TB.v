`include "ClkDiv.v"
`timescale 1us/1ns
module CLKDiv_TB #(parameter INT_WIDTH=8);

reg i_ref_clk_TB;
reg i_rst_n_TB;
reg i_clk_en_TB;
reg [INT_WIDTH-1:0] i_div_ratio_TB;
wire o_div_clk_TB;

parameter CLK_PERIOD= 10;

initial
begin

initialize;
reset;
//Initial Division by 0 
#(20*CLK_PERIOD);
i_div_ratio_TB='b1;
//Division by 1
#(20*CLK_PERIOD);

#(CLK_PERIOD/2);
i_clk_en_TB=1'b1;
//Division by 2
i_div_ratio_TB='b10;
#(20*CLK_PERIOD);

//Division by 3
i_div_ratio_TB='b11;
#(20*CLK_PERIOD);

//Division by 4
i_div_ratio_TB='b100;
#(20*CLK_PERIOD);

//Division by 5
i_div_ratio_TB='b101;
# (20*CLK_PERIOD);
$stop;
end
//Initialize Inputs
task initialize;
begin
    i_ref_clk_TB = 0;
    i_rst_n_TB = 0;
    i_clk_en_TB = 0;
    i_div_ratio_TB = 'b0; // Division ratio
end
endtask
// Reset
task reset;
begin
    #(CLK_PERIOD);
    i_rst_n_TB = 1'b0;
    #(CLK_PERIOD);
    i_rst_n_TB = 1'b1;
end
endtask
//CLOCK PERIOD
always #(CLK_PERIOD/2) i_ref_clk_TB = ~i_ref_clk_TB; 
CLKDiv #(8) DUT (
    .i_ref_clk(i_ref_clk_TB),
    .i_rst_n(i_rst_n_TB),
    .i_clk_en(i_clk_en_TB),
    .i_div_ratio(i_div_ratio_TB),
    .o_div_clk(o_div_clk_TB)
);
endmodule
