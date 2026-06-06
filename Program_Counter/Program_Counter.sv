`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2026 11:53:40 PM
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter(
    input   logic           clk,
    input   logic           rst_n,
    input   logic           pc_en,
    input   logic [31:0]    pc_next,

    output  logic [31:0]    pc_out
    );

    always_ff @(posedge clk) begin
        if(rst_n == '0) begin
            pc_out <= 32'h0000_0000;
        end
        else if (pc_en) begin
            pc_out <= pc_next;
        end 
    end
endmodule
