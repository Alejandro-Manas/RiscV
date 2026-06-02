`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2026 04:12:24 PM
// Design Name: 
// Module Name: Imm_Gen
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
`include "Imm_Gen_header.svh"
import Imm_Gen_header::*;

module Imm_Gen(
    input   logic [2:0]     cmd,
    input   logic [31:0]    instruction,

    output  logic [31:0]    immediate_out
    );

    always_comb begin
        case(cmd)
        
            TYPE_I  : immediate_out = { {20 {instruction[31]}}, instruction[31:20] };
            TYPE_S  : immediate_out = { {20 {instruction[31]}}, instruction[31:25], instruction[11:7] };
            TYPE_B  : immediate_out = { {20 {instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
            TYPE_U  : immediate_out = { instruction[31:12], 12'd0};
            TYPE_J  : immediate_out = { {12 {instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0 };

            default : immediate_out = 32'd0;
        endcase  
    end
endmodule
