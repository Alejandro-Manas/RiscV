`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2026 01:05:18 AM
// Design Name: 
// Module Name: Control_Unit
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
`include "ALU_header.svh"
import ALU_header::*;
import Imm_Gen_header::*;



module Control_Unit(
    input   logic [6:0]     op_code,            //Instruction parts

    output logic [2:0]      imm_cmd,             //Immediate Generator
    
    output logic            file_reg_we,

    output logic            branch,             //PC 
    output logic            jump,

    output logic [1:0]      ALU_control,        //ALU
    output logic [1:0]      ALU_a_selector,
    output logic            ALU_b_selector,
    
    output logic            mem_read,           //LSU
    output logic            mem_write,
    
    output logic [1:0]      wb_selector,        //WB
        
    output logic            target_ctr          //Target
    );
    
    //===============================    
    //Branch/JAL Target
    //===============================      
    assign target_ctr = (op_code == 7'b1100111) ? '1 : '0;
    //===============================
    
    
    //===============================
    //Writeback Selector
    //===============================
    always_comb begin
        case(op_code)
            7'b0000011  : wb_selector = 2'b01;
            7'b1101111  : wb_selector = 2'b10;
            default     : wb_selector = 2'b11;
        endcase
    end
    //===============================

    
    //===============================
    //Program Counter
    //===============================
    always_comb begin
        case(op_code)
            7'b1100011 : begin
                branch = '1;
                jump   = '0;
            end

            7'b1101111,
            7'b1100111 : begin
                branch = '0;
                jump   = '1;
            end

            default : begin
                branch = '0;
                jump   = '0;
            end
        endcase
    end
    //===============================


    //===============================
    // Immediate Generator mux
    //===============================
    always_comb begin
        case(op_code)
            7'b0000011,
            7'b0001111,
            7'b0010011,
            7'b1100111,
            7'b1110011 : imm_cmd = TYPE_I;

            7'b0010111,
            7'b0110111 : imm_cmd = TYPE_U;

            7'b0100011 : imm_cmd = TYPE_S;

            // 7'b0110011 : imm_cmd = TYPE_R  --> not necessary immediate

            7'b1100011 : imm_cmd = TYPE_B;

            7'b1101111 : imm_cmd = TYPE_J;

            default    : imm_cmd = TYPE_I;
        endcase
    end
    //===============================



    //===============================
    //ALU mux
    //===============================
    //Data a
    always_comb begin
        case(op_code)
            7'b0010111  : ALU_a_selector = 2'b01;
            7'b0110111  : ALU_a_selector = 2'b10;
            default     : ALU_a_selector = 2'b11;
            //01 -> p_ins_count
            //10 -> '0
            //11 -> reg_file_data_a
        endcase
    end
    
    //Data b
    always_comb begin
        case(op_code)
            7'b0110011  : ALU_b_selector = '0;
            7'b1100011  : ALU_b_selector = '0;
            default     : ALU_b_selector = '1;
            //0 -> reg_file_data_b
            //1 -> immediate
        endcase
    end

    //Control command
    always_comb begin
        case(op_code)
            7'b0000011  : ALU_control = 2'b00;
            7'b0100011  : ALU_control = 2'b00;
            7'b1100011  : ALU_control = 2'b01;
            7'b0110011  : ALU_control = 2'b10; 
            7'b0010011  : ALU_control = 2'b10; 
            default     : ALU_control = 2'b00;
        endcase
    end


    //===============================


    //===============================
    //File Register mux
    //===============================
    always_comb begin
        case(op_code)
            7'b0110011  :   file_reg_we = '1;
            7'b0010011  :   file_reg_we = '1;
            7'b0000011  :   file_reg_we = '1;
            7'b0110111  :   file_reg_we = '1;
            7'b0010111  :   file_reg_we = '1;
            7'b1101111  :   file_reg_we = '1;
            7'b1100111  :   file_reg_we = '1;

            default     :   file_reg_we = '0;
        endcase
    end
    //===============================


    //===============================
    //LSU mux
    //===============================
    always_comb begin
        case(op_code)
            7'b0000011  : begin
                mem_read    = '1;
                mem_write   = '0;
            end
            7'b0100011  : begin
                mem_read    = '0;
                mem_write   = '1;
            end
            default     : begin
                mem_read    = '0;
                mem_write   = '0;
            end 
        endcase
    end
    //===============================



endmodule
