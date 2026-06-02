`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2026 07:30:55 PM
// Design Name: 
// Module Name: Imm_Gen_Sim
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

`include "/home/alejandro/Escritorio/RiscV/RiscV_1/RiscV_1.srcs/sources_1/new/Imm_Gen_header.svh"
import Imm_Gen_header::*;

module Imm_Gen_Sim(

    );


    logic   [2:0]   cmd;
    logic   [31:0]  instruction;

    logic   [31:0]  immediate_out;

    Imm_Gen uut (
        .cmd            (cmd),
        .instruction    (instruction),

        .immediate_out  (immediate_out)
    );

    task test_value (
        Imm_Gen_type    task_cmd,
        logic [31:0]    instruction_test,

        logic [31:0]    expected_result
    );
    begin
        cmd         = task_cmd;
        instruction = instruction_test;
        #1;
        assert (expected_result === immediate_out) else
            $error("[%0t] ASSERT FAILED. Expected reslt: %h. Recieved result: %h.", $time, expected_result, immediate_out);
    end
    endtask

    initial begin
        cmd         = '0;
        instruction = '0;

        //Testing full 0 and full 1
        $display("[%0t] TESTING: Testing full 0 and full 1", $time);

        test_value(TYPE_I, 32'h0000_0000, 32'h0000_0000);
        test_value(TYPE_S, 32'h0000_0000, 32'h0000_0000);
        test_value(TYPE_B, 32'h0000_0000, 32'h0000_0000);
        test_value(TYPE_U, 32'h0000_0000, 32'h0000_0000);
        test_value(TYPE_J, 32'h0000_0000, 32'h0000_0000);



        test_value(TYPE_I, 32'hFFFF_FFFF, 32'hFFFF_FFFF);
        test_value(TYPE_S, 32'hFFFF_FFFF, 32'hFFFF_FFFF);
        test_value(TYPE_B, 32'hFFFF_FFFF, 32'hFFFF_FFFE);
        test_value(TYPE_U, 32'hFFFF_FFFF, 32'hFFFF_F000);
        test_value(TYPE_J, 32'hFFFF_FFFF, 32'hFFFF_FFFE);


        //Testing alternated values
        $display("[%0t] TESTING: Testing alternated values", $time);

        test_value(TYPE_I, 32'hAAAA_AAAA, 32'hFFFF_FAAA);
        test_value(TYPE_S, 32'hAAAA_AAAA, 32'hFFFF_FAB5);
        test_value(TYPE_B, 32'hAAAA_AAAA, 32'hFFFF_FAB4);
        test_value(TYPE_U, 32'hAAAA_AAAA, 32'hAAAA_A000);
        test_value(TYPE_J, 32'hAAAA_AAAA, 32'hFFFA_A2AA);
        
        test_value(TYPE_I, 32'h5555_5555, 32'h0000_0555);
        test_value(TYPE_S, 32'h5555_5555, 32'h0000_054A);
        test_value(TYPE_B, 32'h5555_5555, 32'h0000_054A);
        test_value(TYPE_U, 32'h5555_5555, 32'h5555_5000);
        test_value(TYPE_J, 32'h5555_5555, 32'h0005_5D54);

        $finish;
    end
endmodule
