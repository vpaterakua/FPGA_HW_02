`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module counter(
    input wire clk, rst, load, en, up_down,
    input wire [3:0] data_in,
    output reg [3:0] count
    );
    
    always @(posedge clk or posedge rst)
        begin
            if (rst)
                count <= 4'b0000;
            else if (load)
                count <= data_in;
            else if (en)
                begin
                    if (up_down)
                        count <= count + 1'b1;
                    else
                        count <= count - 1'b1;
                end
       end
    
endmodule
