`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/02/2026 12:56:33 AM
// Design Name: 
// Module Name: File_Reg
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


module File_Reg(
    input   logic           clk,
    input   logic           we,         //Write enable
    input   logic [4:0]     reg_a,
    input   logic [4:0]     reg_b,
    input   logic [4:0]     reg_w,      //Register Write
    input   logic [31:0]    data_w, 

    output  logic [31:0]    data_a,
    output  logic [31:0]    data_b
    );

    logic [31:0] mem_reg [31:1];

    always_ff @(posedge clk) begin 
        if(we && (reg_w != 5'd0)) begin
            mem_reg [reg_w] <= data_w;
        end
    end

    always_comb begin 
        data_a = (reg_a == 5'd0) ? 32'd0 : mem_reg[reg_a];
        data_b = (reg_b == 5'd0) ? 32'd0 : mem_reg[reg_b];
    end
endmodule 
