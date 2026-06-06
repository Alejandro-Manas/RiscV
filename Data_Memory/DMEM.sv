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
    input   logic           clk,
    input   logic [3:0]     we,
    input   logic [31:0]    w_data,
    input   logic [31:0]    adress,

    output  logic [31:0]    r_data
    );

    logic [31:0] ram [0:1023];
    
    assign r_data = ram[adress[31:2]];

    always_ff @(posedge clk) begin        
        if (we[0]) ram[adress[31:2]][7:0]   <= w_data[7:0];
        if (we[1]) ram[adress[31:2]][15:8]  <= w_data[15:8];
        if (we[2]) ram[adress[31:2]][23:16] <= w_data[23:16];
        if (we[3]) ram[adress[31:2]][31:24] <= w_data[31:24];
    end

endmodule
