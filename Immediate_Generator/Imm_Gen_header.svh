`ifndef IMM_GEN_HEADER_SVH
`define IMM_GEN_HEADER_SVH

package Imm_Gen_header;
    typedef enum logic[2:0] { 
        
        // Load and immediate arthmetic
        TYPE_I = 3'b000,

        // Storage
        TYPE_S = 3'b001,

        // Conditional Branches
        TYPE_B = 3'b010,

        //Load-Add upper intermiediate
        TYPE_U = 3'b011,

        // Jump Add Link
        TYPE_J = 3'b100

    } Imm_Gen_type;    
endpackage

`endif