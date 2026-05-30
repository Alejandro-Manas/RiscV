`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2026 06:50:20 PM
// Design Name: 
// Module Name: ALU
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
`include "ALU_header.svh"
import ALU_header::*;

module ALU (
    input   logic [31:0]    a_value,
    input   logic [31:0]    b_value,
    input   logic [3:0]     instruction,

    output  logic [31:0]    result,
    output  logic           zero_flag
    );

    always_comb begin
        case (instruction) 

            //Arithmetic    
            ALU_add :   result = a_value + b_value;
            ALU_sub :   result = a_value - b_value;

            //Logic          
            ALU_or  :   result = a_value | b_value;
            ALU_xor :   result = a_value ^ b_value;
            ALU_and :   result = a_value & b_value;

            //Shift s        
            ALU_srl :   result = a_value            >>  b_value[4:0];
            ALU_sra :   result = signed'(a_value)   >>> b_value[4:0];
            ALU_sll :   result = a_value            <<  b_value[4:0];

            //Comparison    
            ALU_lt  :   begin
                if (signed'(a_value) < signed'(b_value)) begin
                    result = 32'd1;
                end else begin
                    result = '0;
                end
            end

            ALU_ltu :   begin
                if (a_value < b_value) begin
                    result = 32'd1;
                end else begin
                    result = '0;
                end
            end

            default :   result = '0;

        endcase

        if(result == '0) begin
            zero_flag = '1;
        end else begin
            zero_flag = '0;
        end

    end

endmodule
