`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/07/2026 03:02:54 AM
// Design Name: 
// Module Name: ALU_decoder_sim
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

`include "/home/alejandro/Escritorio/RiscV/RiscV_1/RiscV_1.srcs/sources_1/new/ALU_header.svh"
import ALU_header::*;

module ALU_decoder_sim(

    );

    logic [1:0] ALU_control;
    logic [2:0] funct_3;
    logic       funct_7_5;
    logic       op_code_5;

    logic [3:0] instruction;

    ALU_decoder uut (
        .ALU_control    (ALU_control),
        .funct_3        (funct_3),
        .funct_7_5      (funct_7_5),
        .op_code_5      (op_code_5),

        .instruction    (instruction)
    );

    initial begin
        ALU_control = '0;
        funct_3     = '0;
        funct_7_5   = '0;
        op_code_5   = '0;

        //Testing ALU control for addi function. ADD order 
        #1;
        ALU_control = 2'b00;
        funct_3     = '0;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1
        assert(instruction === ALU_add) else
            $error("[%0t] ASSERT ERROR: ALU control does not work for add instruction.", $time);

            //Testing that ALU control is not interfered by other inputs when it is not necessary
        #1;
        ALU_control = 2'b00;
        funct_3     = '1;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_add) else
            $error("[%0t] ASSERT ERROR: ALU control is interfered by other signals", $time);

        //Testing ALU control for addi fucntion. SUB order
        #1;
        ALU_control = 2'b01;
        funct_3     = '0;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_sub) else
            $error("[%0t] ASSERT ERROR: ALU control does not work for sub instruction.", $time);

        //Testing normal ALU functions

        //ADD
        #1;
        ALU_control = '1;
        funct_3     = '0;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_add) else
            $error("[%0t] ASSERT ERROR: ALU add function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = '0;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_add) else
            $error("[%0t] ASSERT ERROR: ALU add function does not work", $time);

        #1;
        ALU_control = '1;
        funct_3     = '0;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_add) else
            $error("[%0t] ASSERT ERROR: ALU add function does not work", $time);

        //SUB
        #1;
        ALU_control = '1;
        funct_3     = '0;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_sub) else
            $error("[%0t] ASSERT ERROR: ALU sub function does not work", $time);
        
        //SLL
        #1;
        ALU_control = '1;
        funct_3     = 3'b001;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_sll) else
            $error("[%0t] ASSERT ERROR: ALU sll function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b001;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_sll) else
            $error("[%0t] ASSERT ERROR: ALU sll function does not work", $time);

        #1;
        ALU_control = '1;
        funct_3     = 3'b001;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_sll) else
            $error("[%0t] ASSERT ERROR: ALU sll function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b001;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_sll) else
            $error("[%0t] ASSERT ERROR: ALU sll function does not work", $time);

        //SLT
        #1;
        ALU_control = '1;
        funct_3     = 3'b010;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_lt) else
            $error("[%0t] ASSERT ERROR: ALU slt function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b010;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_lt) else
            $error("[%0t] ASSERT ERROR: ALU slt function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b010;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_lt) else
            $error("[%0t] ASSERT ERROR: ALU slt function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b010;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_lt) else
            $error("[%0t] ASSERT ERROR: ALU slt function does not work", $time);
        
        //SLTU
        #1;
        ALU_control = '1;
        funct_3     = 3'b011;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_ltu) else
            $error("[%0t] ASSERT ERROR: ALU sltu function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b011;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_ltu) else
            $error("[%0t] ASSERT ERROR: ALU sltu function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b011;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_ltu) else
            $error("[%0t] ASSERT ERROR: ALU sltu function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b011;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_ltu) else
            $error("[%0t] ASSERT ERROR: ALU sltu function does not work", $time);
        

        //XOR
        #1;
        ALU_control = '1;
        funct_3     = 3'b100;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_xor) else
            $error("[%0t] ASSERT ERROR: ALU xor function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b100;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_xor) else
            $error("[%0t] ASSERT ERROR: ALU xor function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b100;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_xor) else
            $error("[%0t] ASSERT ERROR: ALU xor function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b100;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_xor) else
            $error("[%0t] ASSERT ERROR: ALU xor function does not work", $time);

        //SRL
        #1;
        ALU_control = '1;
        funct_3     = 3'b101;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_srl) else
            $error("[%0t] ASSERT ERROR: ALU srl function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b101;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_srl) else
            $error("[%0t] ASSERT ERROR: ALU srl function does not work", $time);

        //SRA
        #1;
        ALU_control = '1;
        funct_3     = 3'b101;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_sra) else
            $error("[%0t] ASSERT ERROR: ALU sra function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b101;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_sra) else
            $error("[%0t] ASSERT ERROR: ALU sra function does not work", $time);
        
        //OR
        #1;
        ALU_control = '1;
        funct_3     = 3'b110;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_or) else
            $error("[%0t] ASSERT ERROR: ALU or function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b110;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_or) else
            $error("[%0t] ASSERT ERROR: ALU or function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b110;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_or) else
            $error("[%0t] ASSERT ERROR: ALU or function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b110;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_or) else
            $error("[%0t] ASSERT ERROR: ALU or function does not work", $time);
        
        //AND
        #1;
        ALU_control = '1;
        funct_3     = 3'b111;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_and) else
            $error("[%0t] ASSERT ERROR: ALU and function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b111;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_and) else
            $error("[%0t] ASSERT ERROR: ALU and function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b111;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_and) else
            $error("[%0t] ASSERT ERROR: ALU and function does not work", $time);
        
        #1;
        ALU_control = '1;
        funct_3     = 3'b111;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_and) else
            $error("[%0t] ASSERT ERROR: ALU and function does not work", $time);

    end

endmodule



