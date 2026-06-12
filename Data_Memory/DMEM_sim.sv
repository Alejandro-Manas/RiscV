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
    logic [3:0]          we;
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

    task send_data (
        logic [3:0]     we_sim,
        logic [31:0]    data_sim,
        logic [31:0]    adress_sim
    );

    logic [31:0] prev_data;

    begin
        @(negedge clk);
        we          = '0;
        adress      = adress_sim;
        @(negedge clk);
        prev_data   = r_data;
        we          = we_sim;
        w_data      = data_sim;
        @(negedge clk);
        we          = '0;
        for(int i = 0; i < 4; i++) begin
            case(we_sim[i])
            1'b0 : begin
                assert (r_data[i*8+:8] === prev_data[i*8+:8]) else
                    $error("[%0t] ASSERT FAILED: we in position %d writed the data even when we was not active in adress %h.", $time, i, adress);
            end
            1'b1 : begin
                assert (r_data[i*8+:8] === data_sim[i*8+:8]) else
                    $error("[%0t] ASSERT FAILED: we in position %d did not write the data even when we was active in adress %h.", $time, i, adress);
            end
            endcase
        end
    end
    endtask



    initial begin
        we      = '0;
        w_data  = '0;
        adress  = '0;

        //Inicializating all values
        for(int i = 0; i < 2047; i++) begin
            @(negedge clk);
            we      = '1;
            adress  = i * 4;
            w_data  = '0;
        end
        @(negedge clk);
        we = '0;

        for(int y = 0; y < 2**4; y ++)begin
            for(int j = 0; j < 10_000; j++) begin
                send_data(y, $urandom(), (($urandom()%4096) & 32'hFFFFFFFC));
            end
        end

        $finish;
    end

endmodule
