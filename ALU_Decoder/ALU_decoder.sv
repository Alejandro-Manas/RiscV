`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2026 02:16:30 AM
// Design Name: 
// Module Name: ALU_decoder
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

module ALU_decoder(
    input  logic [1:0]  ALU_control,
    input  logic [2:0]  funct_3,
    input  logic        funct_7_5,
    input  logic        op_code_5, 

    output logic [3:0]  instruction
    );

    always_comb begin
        case (ALU_control)
            2'b00   :   instruction = ALU_add;
    
            2'b01   :   instruction = ALU_sub;

            default : begin
                case (funct_3)
                    3'b000  : instruction = (funct_7_5 == '1 && op_code_5 == '1)? ALU_sub : ALU_add;

                    3'b001  : instruction = ALU_sll;

                    3'b010  : instruction = ALU_lt;

                    3'b011  : instruction = ALU_ltu;

                    3'b100  : instruction = ALU_xor;

                    3'b101  : instruction = (funct_7_5 == '0)? ALU_srl : ALU_sra;

                    3'b110  : instruction = ALU_or;

                    3'b111  : instruction = ALU_and;

                    default : instruction = ALU_add;
                endcase 
            end
        endcase
    end
endmodule
