`ifndef ALU_HEADER_SVH
`define ALU_HEADER_SVH

package ALU_header;
    typedef enum logic[3:0] { 
        
        //Arithmetic    -> 00xx
        ALU_add =   4'b0001,
        ALU_sub =   4'b0000,

        //Logic         -> 01xx
        ALU_or  =   4'b0100,
        ALU_xor =   4'b0101,
        ALU_and =   4'b0111,

        //Shifts        -> 10xx
        ALU_srl =   4'b1000,//Shift right logic
        ALU_sra =   4'b1001,//Shift right aritmetic
        ALU_sll =   4'b1011,//Shift left logic

        //Comparison    -> 11xx
        ALU_lt  =   4'b1100,//Less than
        ALU_ltu =   4'b1101//Lass than Unsigned

    } ALU_cmd;    
endpackage

`endif