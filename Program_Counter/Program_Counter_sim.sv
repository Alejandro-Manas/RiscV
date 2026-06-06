`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 12:01:39 AM
// Design Name: 
// Module Name: Program_Counter_sim
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


module Program_Counter_sim(

    );

    localparam clk_freq             = 100000000.0;

    localparam clk_period           = 1000000000.0/clk_freq;
    localparam clk_semiperiod       = clk_period / 2.0;


    logic           clk;
    logic           rst_n;
    logic           pc_en;
    logic [31:0]    pc_next;

    logic [31:0]    pc_out;

    Program_Counter uut (
        .clk        (clk),
        .rst_n      (rst_n),
        .pc_en      (pc_en),
        .pc_next    (pc_next),

        .pc_out     (pc_out)
    );

    always begin
        clk = '0;
        #clk_semiperiod;
        clk = '1;
        #clk_semiperiod;
    end


    initial begin
        rst_n   = '0;
        pc_en   = '0;
        pc_next = '0;

        #(4*clk_period);

        //Testing the reset
        assert (pc_out === 32'd0) else
            $error("[%0t] ASSERT FAILED. Reset not working.", $time);


        #clk_period;
        @(negedge clk)
        rst_n   = '1;
        pc_next = '1;
        @(negedge clk)

        //Testing enable functionality
        assert (pc_out === 32'd0) else
            $error("[%0t] ASSERT FAILED. Enable not working when not active.", $time);
        
        @(negedge clk)
        pc_en = '1;
        @(negedge clk)
        assert (pc_out === 32'hFFFF_FFFF) else
            $error("[%0t] ASSERT FAILED. Enable not working when active.", $time);

        //Testing the reset priority
        @(negedge clk)
        rst_n   = '0;
        pc_en   = '1;  
        pc_next = '1;
        @(negedge clk)
        assert (pc_out === 32'h0000_0000) else
            $error("[%0t] ASSERT FAILED. Reset priority not working.", $time);

        $finish;
    end

endmodule
