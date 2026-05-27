`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Verilog Wrapper for the AXIS_pmodMIC (written in SystemVerilog)

/* 
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


module AXIS_pmodMIC_wrapper(
    input aclk,
    input areset_n,
    input m_axis_tready,
    input miso,
    
    output m_axis_tvalid,
    output [31:0] m_axis_tdata,
    output m_axis_tlast,
    output sck,
    output ss
);
    
    AXIS_pmodMIC AXIS_pmodMIC_SPI(
        .aclk(aclk),
        .areset_n(areset_n),
        .m_axis_tready(m_axis_tready),
        .miso(miso),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tlast(m_axis_tlast),
        .sck(sck),
        .ss(ss)
    );    
    
endmodule
