`timescale 1ns / 1ps


/////////////////////////////////////////////////////////////////////////////////
/*
    Author: Ryan Cramer
    Date: May 2026
    
    Module: pmodMIC_Button
    
    Description: 
    
    On button hold for (DELAY_RATE/CLK_RATE) sec, reads the pmodMIC sample to the LEDs
    pmodMIC is connected to PMOD B's upper 6 pins (Basys3)
    
    This module wraps the AXIS_pmodMIC, which can be easily connected to AXI4-Stream IP 
    
*/
/////////////////////////////////////////////////////////////////////////////////


module pmodMIC_Button(
        input clk,
        input rst,
        input miso,
        input en,
        output logic ss,
        output logic sck,
        output logic [15:0] led
);
    
    // pulse_en    is high when button is held for the delay period 
    // update_leds is high when the sample is done and one delay period has occured 
    // done        is to notify us when the sample is done
    logic pulse_en, update_leds, done;
    
    // delay counter and the sample data
    logic [31:0] delay_counter, data;
    
    AXIS_pmodMIC_wrapper pmodMIC(
        .aclk(clk),
        .areset_n(!rst),
        .m_axis_tready(pulse_en),
        .miso(miso),
        .m_axis_tvalid(done),
        .m_axis_tdata(data),
        .m_axis_tlast(),
        .ss(ss),
        .sck(sck)
    );  
    
    // pulse_en happens when one delay period has occured and the enable is held
    assign pulse_en = (delay_counter == 32'd50000000) && en;
    // assign update_leds to when the sample is ready and one delay period has occurred
    assign update_leds = done && (delay_counter == 32'd50000000);
    
    // simple delay counter which is periodic 
    always_ff@(posedge clk)
        if(rst || (delay_counter == 32'd50000000))
            delay_counter <= 0;
        else
            delay_counter <= delay_counter + 1;
            
    // simple led register which updates when a sample is done and a delay period has occured
    always_ff@(posedge clk)
        if(rst)
            led <= 0;
        else if(update_leds)
            led <= data[15:0];
    
    
endmodule
