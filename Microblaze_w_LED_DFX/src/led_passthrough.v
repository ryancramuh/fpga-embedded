`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/28/2026 09:43:02 PM
// Design Name: 
// Module Name: led_passthrough
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


module led_passthrough(
    input wire clk,
    input wire rst,
    input wire [3:0] btn,
    input wire [15:0] sw,
    output reg [15:0] led
    );
    
    always@(posedge clk)
        if(rst)
            led <= 0;
        else
            led <= {sw[11:0],btn};
endmodule
