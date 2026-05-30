`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/30/2026 10:32:22 PM
// Design Name: 
// Module Name: ALU_Sim
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

module ALU_Sim(

    );

    localparam int num_random_test = 100_000; //Number of random test for each function

    //ALU declaration and configuration
    logic [31:0]    a_value;
    logic [31:0]    b_value;
    ALU_cmd         instruction;

    logic [31:0]    result;
    logic           zero_flag;

    ALU uut (
        .a_value        (a_value),
        .b_value        (b_value),
        .instruction    (instruction),

        .result         (result),  
        .zero_flag      (zero_flag)
    );

    localparam wait_calc = 10;
    logic [31:0]    expected_result;
    logic           expected_zero_flag;

    //Functions that emulates the ALU 
    function logic[31:0] get_verification_value (logic [31:0] a, logic [31:0] b, logic [3:0] instruction);
        case(instruction)
            ALU_add: return (a+b);
            ALU_sub: return (a-b);
            ALU_and: return (a&b);
            ALU_or : return (a|b);
            ALU_xor: return (a^b);
            ALU_srl: return (a          >>  b[4:0]);
            ALU_sra: return (signed'(a) >>> b[4:0]);
            ALU_sll: return (a          <<  b[4:0]);
            ALU_lt : return ((signed'(a) < signed'(b)) ? 32'd1 : '0);
            ALU_ltu: return ((a < b) ? 32'd1 : '0);
            default: return ('0);
        endcase
    endfunction

    function logic get_verification_zero_flag (logic [31:0] res);
            return ((res == '0) ? 32'd1 : '0);
    endfunction

    //Task to test an instruction with defined value
    task verify_instructions (
        logic [31:0]    a_value_test,
        logic [31:0]    b_value_test,
        ALU_cmd         instruction_test
    );
    begin
        a_value     = a_value_test;
        b_value     = b_value_test;
        instruction = instruction_test;

        #wait_calc;

        expected_result     =   get_verification_value(a_value_test, b_value_test, instruction_test);
        expected_zero_flag  =   get_verification_zero_flag(expected_result);

        assert(result == expected_result) else
            $error("[%0t] ASSERT FAILED. Operation: %s, Expected result: %h, Revieved: %h.", $time, instruction_test.name(), expected_result, result);
        
        
        assert(zero_flag == expected_zero_flag) else
            $error("[%0t] ASSERT FAILED. Operation: %s, Expected zero flag: %b, Recieved: %b", $time, instruction_test.name(), expected_zero_flag, zero_flag);
        
        #1;

    end
    endtask 


    initial begin
        a_value = '0;
        b_value = '0;
        instruction = ALU_sub; //4'b0000

        #wait_calc
        
        //Starting critical cases

        //Arithmetic
        verify_instructions(32'hFFFF_FFFF, 32'h0000_0001, ALU_add);
        verify_instructions(32'h7FFF_FFFF, 32'h0000_0001, ALU_add);

        verify_instructions(32'd100      , 32'd100      , ALU_sub);
        verify_instructions(32'h8000_0000, 32'h0000_0001, ALU_sub);

        //Logic
        verify_instructions(32'hAAAA_AAAA, 32'h5555_5555, ALU_and); //Alternated 0 and 1
        verify_instructions(32'hAAAA_AAAA, 32'h5555_5555, ALU_or );
        verify_instructions(32'hAAAA_AAAA, 32'h5555_5555, ALU_xor);

        verify_instructions(32'hFFFF_FFFF, 32'h5555_5555, ALU_and);

        verify_instructions(32'hAAAA_AAAA, 32'd0        , ALU_or );
        verify_instructions(32'hAAAA_AAAA, 32'd0        , ALU_xor);

        //Shifts
        verify_instructions(32'hFFFF_FFFF, 32'd00       , ALU_srl);
        verify_instructions(32'hFFFF_FFFF, 32'd31       , ALU_srl);
        verify_instructions(32'hFFFF_FFFF, 32'd32       , ALU_srl);

        verify_instructions(32'hFFFF_FFFF, 32'd00       , ALU_sll);
        verify_instructions(32'hFFFF_FFFF, 32'd31       , ALU_sll);
        verify_instructions(32'hFFFF_FFFF, 32'd32       , ALU_sll);

        verify_instructions(32'hFFFF_FFFF, 32'd00       , ALU_sra);
        verify_instructions(32'hFFFF_FFFF, 32'd31       , ALU_sra);
        verify_instructions(32'hFFFF_FFFF, 32'd32       , ALU_sra);

        //Comparisons
        verify_instructions(32'hFFFF_FFFF, 32'h0000_0001, ALU_lt );
        verify_instructions(32'h0000_0000, 32'h0000_0000, ALU_lt );

        verify_instructions(32'hFFFF_FFFF, 32'h0000_0001, ALU_ltu);
        verify_instructions(32'h0000_0000, 32'h0000_0000, ALU_ltu);

        for(int i = 0; i < num_random_test; i++) begin
            verify_instructions($urandom(), $urandom(), ALU_add);
            verify_instructions($urandom(), $urandom(), ALU_sub);

            verify_instructions($urandom(), $urandom(), ALU_or );
            verify_instructions($urandom(), $urandom(), ALU_xor);
            verify_instructions($urandom(), $urandom(), ALU_and);

            verify_instructions($urandom(), $urandom(), ALU_srl);
            verify_instructions($urandom(), $urandom(), ALU_sra);
            verify_instructions($urandom(), $urandom(), ALU_sll);

            verify_instructions($urandom(), $urandom(), ALU_lt );
            verify_instructions($urandom(), $urandom(), ALU_ltu);
        end

        $finish;
    end
endmodule
