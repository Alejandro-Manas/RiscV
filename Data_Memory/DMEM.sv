`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2026 07:58:32 PM
// Design Name: 
// Module Name: DMEM
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


module DMEM(
    input   logic   clk,
    input   logic   we,
    input   logic [31:0]    w_data,
    input   logic [31:0]    adress,

    output  logic [31:0]    r_data
    );

    logic [31:0] ram [0:1023];
    
    assign r_data = ram[adress[31:2]];

    always_ff @(posedge clk) begin        
        if (we) begin
            ram[adress[31:2]] <= w_data;
        end 
    end

endmodule
