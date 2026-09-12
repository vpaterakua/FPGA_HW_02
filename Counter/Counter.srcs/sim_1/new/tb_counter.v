`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module tb_counter();

    reg clk, rst, load, en, up_down;
    reg [3:0] data_in;
    wire [3:0] count;
    
    counter dut (.clk(clk), .rst(rst), .load(load),
                 .en(en), .up_down(up_down), .data_in(data_in),
                 .count(count));
    
    
    task automatic check_count;
        input [3:0] expected;
        input [8*22-1:0] name;
        begin
            if (expected === count)
                $display("PASS: %0s", name);
            else
                $display("FAIL: %0s, exp=%0d got=%0d", name, expected, count);
        end
    endtask
        
    initial
        begin
            clk = 1'b0;
            rst = 1'b0;
            load = 1'b0;
            en = 1'b0;
            up_down = 1'b0;
            data_in = 4'b0000;
        end
    
    always
        begin
            #10 clk = ~clk;
        end
    
    always
        begin         
            //3 LOAD TEST 
            @(posedge clk);  #1 rst = 1'b1;
            @(posedge clk); #1 rst = 1'b0;
            #10 load = 1'b1; data_in = 4'd10;   
            @(posedge clk); #1 load = 1'b0;
            #1
            check_count(4'd10, "LOAD TEST");
                
            //4 COUNT UP & OVERFLOW TEST    
            @(posedge clk);
            #1 en = 1'b1; up_down = 1'b1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1
            check_count(4'd13, "COUNT UP to 13");    
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1
            check_count(4'd0, "COUNT UP & OVERFLOW");
            
            //5 HOLD EN    
            en = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #1
            check_count(4'd0, "HOLD EN");
            
            //6 COUNT DOWN & OVERFLOW    
            en = 1'b1; up_down = 1'b0;
            @(posedge clk);
            #1
            check_count(4'd15, "COUNT DOWN & OVERFLOW");
            
            //7 PRIORITY LOAD & EN    
            load = 1'b1; data_in = 4'd5; en=1'b1; up_down=1'b1;
            @(posedge clk);
            #1
            check_count(4'd5, "PRIORITY LOAD & EN");
            
            #10    
            // BONUS TEST
            load = 1'b1; data_in = 4'd9;
            @(posedge clk); #1 load = 1'b0;
            en = 1'b1;
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            #1
            check_count(4'd13, "BONUS TEST UP");
            up_down = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #1
            check_count(4'd11, "BONUS TEST DOWN");
            rst = 1'b1;
            #1
            check_count(4'd0, "BONUS TEST RST");
            $finish;    
                
        end 
endmodule
