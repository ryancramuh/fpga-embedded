`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
    Testbench for AXIS_pmodMIC 

    You can configure this how you want

    It is a simple SPI driver and drives out 4 samples 
*/
//////////////////////////////////////////////////////////////////////////////////


module tb_AXIS_pmodMIC;
    
    logic clk;
    logic reset;
    
    logic s_axis_tready;
    logic miso;
    logic tvalid;
    logic [31:0] tdata;
    logic tlast;
    
    logic [15:0] data;
    
    logic ss;
    logic sck;
    
    AXIS_pmodMIC DUT(
        .aclk(clk),
        .areset_n(!reset),
        .m_axis_tready(s_axis_tready),
        .miso(miso),
        .m_axis_tvalid(tvalid),
        .m_axis_tdata(tdata),
        .m_axis_tlast(tlast),
        .sck(sck),
        .ss(ss)
    );
    
    initial begin
        data = {4'd0000, 12'($urandom_range(4095, 0))};
        miso = data[15];
    end
    
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        s_axis_tready = 1'b0;
        forever #5 clk = ~clk;
    end
    
    always_ff@(negedge sck) begin
        if(!ss) begin
            miso <= data[15];
            data <= data << 1;
        end
        else if(tvalid && s_axis_tready) begin
            data <= {4'd0000, 12'($urandom_range(4095, 0))};
        end
    end 
    
    int i = 0;
    
    always begin
        #10;
        reset = 1'b0;
        #10;
        for(i = 0; i < 4; i++) begin
            s_axis_tready <= 1'b1;
            #10;
            while(!tvalid) begin
                #10;
            end
            s_axis_tready <= 1'b0;
            #10;
        end
        
        #10;
        $finish();
    end
    
endmodule
