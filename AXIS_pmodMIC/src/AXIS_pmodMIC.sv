`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
    Author: Ryan Cramer
    Date: May 2026
    
    Module: AXIS_pmodMIC
    
    Description:

    AXIS interface to the pmodSPI MIC 

    Can be driven using IP or any custom wrapper

    Instantiation Template:

    AXIS_pmodMIC AXI_SPI_pmodMIC(
        .aclk(),
        .areset_n(),
        .m_axis_tready(),
        .miso(),
        .m_axis_tvalid(),
        .m_axis_tdata(),
        .m_axis_tlast(),
        .sck(),
        .ss()
    );
    
*/
//////////////////////////////////////////////////////////////////////////////////


module AXIS_pmodMIC(

    input aclk,
    input areset_n,
    input m_axis_tready,
    input miso,
    
    output logic m_axis_tvalid,
    output logic [31:0] m_axis_tdata,
    output logic m_axis_tlast,
    output logic sck,
    output logic ss
    
);

    typedef enum logic [1:0] {
        
        INIT,
        SAMPLING,
        DONE
        
    } state_t;
    
    state_t NS, PS;
    
    logic [15:0] data;
    logic [3:0] clk_div_cntr, bit_cntr;
    logic [7:0] sample_cntr;
    logic toggle_rate;    
    logic sck_enabled;
    logic sample;
    logic sampling_done;
    logic sample_ready;
    
    assign toggle_rate = (clk_div_cntr == 9);
    assign sample = ((sck == 1'b0) && (toggle_rate));
    assign sampling_done = ((bit_cntr == 4'd15) && sample);
    assign m_axis_tlast = (PS == DONE) && (sample_cntr == 8'd255);
    assign sample_ready = m_axis_tvalid && m_axis_tready;
    
    always_ff@(posedge aclk or negedge areset_n)
        if(!areset_n)
            clk_div_cntr <= 0;
        else if(sampling_done || toggle_rate)
            clk_div_cntr <= 0;
        else if(sck_enabled)
            clk_div_cntr <= clk_div_cntr + 1;
    
    always_ff@(posedge aclk or negedge areset_n)
        if(!areset_n)
            bit_cntr <= 0;
        else if(sample)
            bit_cntr <= bit_cntr + 1;
            
    always_ff@(posedge aclk or negedge areset_n)
        if(!areset_n || ~sck_enabled)
            sck <= 1'b1;
        else if(sck_enabled && toggle_rate)
            sck <= ~sck;
    
    always_ff@(posedge aclk or negedge areset_n)
        if(!areset_n)
            PS <= INIT;
        else
            PS <= NS;
    
    always_ff@(posedge aclk or negedge areset_n)
        if(!areset_n)
            data <= 0;
        else if(sample)
            data <= {data[14:0], miso};
    
    always_ff@(posedge aclk or negedge areset_n)
        if(!areset_n)
            sample_cntr <= 0;
        else if(sample_ready)
            sample_cntr <= sample_cntr + 1;
            
    always_comb begin 
    
        NS = INIT;
        ss = 1'b1;
        sck_enabled = 1'b0;
        m_axis_tvalid = 1'b0;
        m_axis_tdata = 32'b0;
        
        case(PS)
        
            INIT: begin
                if(m_axis_tready) begin
                    ss = 1'b0;
                    NS = SAMPLING;
                end else begin
                    NS = INIT;
                end
            end
            
            SAMPLING: begin
                sck_enabled = 1'b1;
                ss = 1'b0;
                if(sampling_done)
                    NS = DONE;
                else
                    NS = SAMPLING;
            end
            
            DONE: begin
                ss = 1'b1;
                m_axis_tvalid = 1'b1;
                m_axis_tdata = {16'd0, data};
                if(m_axis_tready)
                    NS = SAMPLING;
                else 
                    NS = DONE;
            end
            
            default: begin
                ss = 1'b1;
                sck_enabled = 1'b0;
                m_axis_tvalid = 1'b0;
                m_axis_tdata = 32'b0;
                NS = INIT;
            end 
            
        endcase
        
   end 
endmodule
