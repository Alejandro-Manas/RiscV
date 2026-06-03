`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 08:18:11 PM
// Design Name: 
// Module Name: DMEM_sim
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


module DMEM_sim(

    );

    localparam clk_freq         = 100_000_000;

    localparam clk_period       = 1_000_000_000.0/clk_freq;
    localparam clk_semiperiod   = clk_period/2.0;

    logic           clk;
    logic           we;
    logic [31:0]    w_data;
    logic [31:0]    adress;

    logic [31:0]    r_data;

    DMEM uut (
        .clk        (clk),
        .we         (we),
        .w_data     (w_data),
        .adress     (adress),

        .r_data     (r_data)
    );

    always begin
        clk = '0;
        #clk_semiperiod;
        clk = '1;
        #clk_semiperiod;
    end

    initial begin
        we      = '0;
        w_data  = '0;
        adress  = '0;

        #(2*clk_period);

        //Testing the Writing functionality
        @(negedge clk);
        we      = '1;
        adress  = 32'd0;
        w_data  = 32'hAAAA_AAAA;
        @(negedge clk);
        adress  = 32'd0;
        assert(r_data === w_data) else
            $error("[%0t] ASSERT FAILED: Not writing even when we enabled.", $time);
        

        //Testing if "we" blocks the data input
        @(negedge clk);
        we      = '0;
        adress  = 32'd0;
        w_data  = 32'h5555_5555;
        @(negedge clk);
        assert(r_data === 32'hAAAA_AAAA) else
            $error("[%0t] ASSERT FAILED: Write enable capability does not work. Writing data even when we is not active.", $time);

        
        //Testing different adresses and if the interfer with eahcother
        @(negedge clk);
        we      = '1;
        adress  = 32'd4;
        w_data  = 32'h5555_5555;
        @(negedge clk);
        we      = '0;

        #1;
        adress = 32'd0;
        #1;
        assert(r_data === 32'hAAAA_AAAA) else
            $error("[%0t] ASSERT FAILED: Problems with adresses and data interference", $time);
        
        #1;
        adress = 32'd4;
        #1;
        assert(r_data === 32'h5555_5555) else
            $error("[%0t] ASSERT FAILED: Problems with adresses and data interference", $time);

        $finish;

    end

endmodule
