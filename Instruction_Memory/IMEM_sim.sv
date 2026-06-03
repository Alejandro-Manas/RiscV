`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 06:36:57 PM
// Design Name: 
// Module Name: IMEM_sim
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


module IMEM_sim(

    );  

    logic [31:0]    adress;
    logic [31:0]    instruction;
    logic [31:0]    expected_instruction;

    IMEM uut (
        .adress         (adress),
        .instruction    (instruction)
    );
    
    initial begin

    //Testing adress 0. Mem directions from 3 to 0
    adress                  = 32'd0;
    expected_instruction    = 32'h0000_0013;
    #1;

    assert(instruction === expected_instruction) else
        $error("[%0t] ASSERT ERROR: In direction %d the vaalue should be %h and it is %h.", $time, adress, expected_instruction, instruction);


    //Testing adress 4. Mem direction from 7 to 4
    adress                  = 32'd4;
    expected_instruction    = 32'h0041_2083;
    #1;

    assert(instruction === expected_instruction) else
        $error("[%0t] ASSERT ERROR: In direction %d the vaalue should be %h and it is %h.", $time, adress, expected_instruction, instruction);


    //Testing addres 8. Mem direction from 11 to 8
    adress                  = 32'd8;
    expected_instruction    = 32'hFFFF_FFFF;
    #1;

    assert(instruction === expected_instruction) else
        $error("[%0t] ASSERT ERROR: In direction %d the vaalue should be %h and it is %h.", $time, adress, expected_instruction, instruction);
        
    $finish;

    end

endmodule