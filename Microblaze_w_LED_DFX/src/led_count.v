`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2026 09:43:02 PM
// Design Name: 
// Module Name: led_count
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module led_count(
    input wire clk,
    input wire rst,
    input wire [3:0] btn,
    input wire [15:0] sw,
    output reg [15:0] led
    );
    
    reg [28:0] cntr;
    reg [28:0] max_cnt;
    
    always@(posedge clk)
        if(rst)
            cntr <= 27'd0;
        else if(cntr >= max_cnt)
            cntr <= 27'd0;
        else
            cntr <= cntr + 1;
            
    always@(posedge clk)
        if(rst)
            max_cnt <= 27'd100000000;
        else if(btn[0])
            max_cnt <= max_cnt - 1;
        else if(btn[1])
            max_cnt <= max_cnt + 1; 
            
    always@(posedge clk)
        if(rst)
            led <= 16'd0;
        else if(cntr >= max_cnt)
            led <= ~led;
endmodule
