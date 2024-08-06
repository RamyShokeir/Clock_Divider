module CLKDiv #(parameter INT_WIDTH=8)
(
    input wire i_ref_clk,
    input wire i_rst_n,
    input wire i_clk_en,
    input wire [INT_WIDTH-1:0] i_div_ratio,
    output reg o_div_clk
);

reg [INT_WIDTH-1:0] counter;
reg Flag;
wire is_even =(i_div_ratio[0]==1'b0)? 1:0;
wire [INT_WIDTH-1:0] even_count_max= (i_div_ratio[0]==1'b0)?(i_div_ratio>>1):('b0);
wire [INT_WIDTH-1:0] odd_count_max= (i_div_ratio[0]==1'b1)?(i_div_ratio>>1):('b0);
always @(posedge i_ref_clk or negedge i_rst_n) 
begin 
    if (!i_rst_n) 
    begin
        counter <= 'b0;
        o_div_clk <=1'b0;
        Flag <=1'b0;
    end 
    else if (i_clk_en && (i_div_ratio!='b0 || i_div_ratio!='b1)) 
    begin
       if(is_even && (i_div_ratio!='b0 || i_div_ratio!='b1))
        begin
            if(counter==(even_count_max-'b1))
            begin
                o_div_clk <= ~o_div_clk;
                counter <='b0;
            end
            else
            begin
                counter <= counter + 'b1;
            end
        end
        else if(!is_even && (i_div_ratio!='b0 || i_div_ratio!='b1))
        begin
            if(((counter ==(odd_count_max)) && !Flag) || ((counter== odd_count_max-'b1) && Flag ))
            begin
                o_div_clk <= ~o_div_clk;
                counter <= 'b0;
                Flag <= ~Flag;
            end
            else
            begin
                counter <= counter + 'b1;
            end
        end
        else
        begin
             o_div_clk <= o_div_clk;
        end
    end
    else
    begin
        o_div_clk <= o_div_clk;
        counter <= 'b0;
        Flag <= 1'b0;
    end
end
always @ (*)
begin
    if(!i_rst_n)
    begin
        o_div_clk <=1'b0;
    end
    else if (!i_clk_en && (i_div_ratio=='b0 || i_div_ratio=='b1))
        begin
            o_div_clk <=i_ref_clk;
        end
end
endmodule
