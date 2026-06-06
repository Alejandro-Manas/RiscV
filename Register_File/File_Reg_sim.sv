`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2026 01:56:12 AM
// Design Name: 
// Module Name: File_Reg_sim
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


module File_Reg_sim(

    );

    localparam clk_freq = 100_000_000;
    
    localparam clk_period           = 1000000000.0/clk_freq;
    localparam clk_semiperiod       = clk_period / 2.0;


    logic           clk;
    logic           we;
    logic [4:0]     reg_a;
    logic [4:0]     reg_b;
    logic [4:0]     reg_w;
    logic [31:0]    data_w;

    logic [31:0]    data_a;
    logic [31:0]    data_b;

    File_Reg uut (
        .clk        (clk),
        .we         (we),
        .reg_a      (reg_a),
        .reg_b      (reg_b),
        .reg_w      (reg_w),
        .data_w     (data_w),

        .data_a     (data_a),
        .data_b     (data_b)
    );


    always begin
        clk = 0;
        #clk_semiperiod;
        clk = 1;
        #clk_semiperiod;
    end

    task write_data (
        logic [4:0]     reg_direction,
        logic [31:0]    data
    );
    begin
        @(negedge clk);
        we      = '1;
        reg_w   = reg_direction;
        data_w  = data;
        @(negedge clk);
        we      = '0;
    end
    endtask

    task read_data_a (
        logic [4:0]     reg_direction
    );
    begin
        reg_a   = reg_direction;
        #1;
    end
    endtask

    task read_data_b (
        logic [4:0]     reg_direction
    );
    begin
        reg_b   = reg_direction;
        #1;
    end
    endtask
    
    int test_values [31];
    
    initial begin
        we = '0;
        reg_a = '0;
        reg_b = '0;
        reg_w = '0;
        data_w = '0;
        

        //Testing reg number 0
        write_data  (4'h0, 32'hFFFF_FFFF);
        read_data_a (4'h0);

        assert(data_a == 32'h0000_0000) else
            $error("[%0t] ASSERT FAILED. Register 0 with a different value than 0.", $time);

        
        // Testing write enable
        write_data  (4'd1, 32'h5555_5555);
        we = '0;
        for(int i = 0; i < 17; i++) begin
            reg_w = 4'd1;
            data_w = i;
            @(negedge clk);
        end
        read_data_a (4'd1);

        assert(data_a == 32'h5555_5555) else
            $error("[%0t] ASSERT FAILED. Write enable not bloking the write function.", $time);

        
        // Testing reading and write conflicts
        write_data  (4'd2, 32'h5555_5555);
        @(negedge clk);
        read_data_a (4'd2);
        we      = '1;
        reg_w   = 4'd2;
        data_w  = 32'hAAAA_AAAA;

        assert(data_a == 32'h5555_5555) else
            $error("[%0t] ASSERT FAILED. Reading/Write conflict.", $time);
        
        @(negedge clk);

        read_data_a (4'd2);

        assert(data_a == 32'hAAAA_AAAA) else
            $error("[%0t] ASSERT FAILED. Reading/Write conflict.", $time);
        we  = '0;


        //Testing double reading
        write_data  (4'd3, 32'hA5A5_A5A5);
        @(negedge clk)
        read_data_a (4'd3);
        read_data_b (4'd3);
        assert(data_a == data_b) else
            $error("[%0t] ASSERT FAILED. A and B reading the same direction but recieveng different data.", $time);

        //Testing random values, reading and writing using test values
        for (int reg_adress = 1; reg_adress < 32; reg_adress++) begin
            test_values [reg_adress - 1] = $urandom();
            write_data (reg_adress, test_values[reg_adress - 1]);
        end

        for (int reg_adress = 1; reg_adress < 32; reg_adress++) begin
            @(negedge clk);
            read_data_a (reg_adress);
            assert(data_a == test_values[reg_adress - 1]) else
                $error("[%0t] ASSERT FAILED. Random values testing erro. Addres direction: %d. Expected data: %h. Data read: %h.", $time, reg_adress, test_values[reg_adress - 1], data_a);
        end

    end

endmodule
