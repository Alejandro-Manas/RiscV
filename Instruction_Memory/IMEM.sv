`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 06:13:04 PM
// Design Name: 
// Module Name: IMEM
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


module IMEM(
    input   logic [31:0]    adress,
    output  logic [31:0]    instruction   
    );

    logic [31:0] instruction_memory [0:2047];

    initial begin
        $readmemh("program.hex", instruction_memory);
    end

    assign instruction = instruction_memory[adress[31:2]];
endmodule
