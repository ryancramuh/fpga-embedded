`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2026 09:43:02 PM
// Design Name: 
// Module Name: led_shift
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


module led_shift(
    input wire clk,
    input wire rst,
    input wire [3:0] btn,
    input wire [15:0] sw,
    output reg [15:0] led
    );
    
    reg [31:0] cntr;
    wire en = (cntr >= 32'd33333333);
    
    always@(posedge clk)
        if(rst)
            cntr <= 32'd0;
        else if(en)
            cntr <= 32'd0;
        else 
            cntr <= cntr + 1;
            
    always@(posedge clk)
        if(rst)
            led <= 16'd0;
        else if(btn[0] && en)
            led <= (led == 16'd0) ? ({1'b1, led[15:1]}) : (led >> 1);
        else if(btn[1] && en)
            led <= (led == 16'd0) ? ({led[14:0], 1'b1}) : (led << 1);
            
endmodule
