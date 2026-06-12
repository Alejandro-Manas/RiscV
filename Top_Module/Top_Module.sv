`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/10/2026 07:40:13 PM
// Design Name: 
// Module Name: Top_Module
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


module Top_Module(
    input logic     clk,
    input logic     rst_n
    );
    
    logic [1:0]     wb_selector;

    logic [31:0]    p_instruction;
    logic [2:0]     funct_3;
    logic           funct_7_5;
    logic [6:0]     op_code;
    logic           op_code_5;
    logic [4:0]     rs1;
    logic [4:0]     rs2;
    logic [4:0]     rd;


    assign funct_3      = p_instruction [14:12];
    assign funct_7_5    = p_instruction [30];
    assign op_code      = p_instruction [6:0];
    assign op_code_5    = p_instruction [5];
    assign rs1          = p_instruction [19:15];
    assign rs2          = p_instruction [24:20];
    assign rd           = p_instruction [11:7];


    //===============================
    //Control Unit
    //===============================
    Control_Unit CU (
        .op_code        (op_code),

        .imm_cmd        (imm_cmd),

        .file_reg_we    (reg_file_we),

        .jump           (jump),
        .branch         (branch),

        .ALU_control    (ALU_control),
        .ALU_a_selector (ALU_a_selector),
        .ALU_b_selector (ALU_b_selector),

        .mem_read       (mem_read),
        .mem_write      (mem_write),

        .wb_selector    (wb_selector),
        
        .target_ctr     (target_ctr)
    );
    //===============================    

    //===============================    
    //Branch/JAL Target
    //===============================      
    logic [31:0] target_address;
    assign target_address = (target_ctr) ? ALU_result : p_ins_count + immediate;
    //=============================== 

    //=============================== 
    //Program Counter Source
    //=============================== 
    logic   jump;
    logic   branch;
    logic   pc_src;
    logic   take_branch;
    always_comb begin
        if (branch) begin
            case(funct_3)
            3'b000  : take_branch = ALU_zero_flag;                  //BEQ
            3'b001  : take_branch = ~ALU_zero_flag;                 //BNE
            3'b100  : take_branch = ALU_result[31];                 //BLT
            3'b101  : take_branch = ~ALU_result[31] | ALU_zero_flag;//BGE
            3'b110  : take_branch = ALU_result[0 ];                 //BLTU
            3'b111  : take_branch = ~ALU_result[0 ] | ALU_zero_flag;//BGEU
            default : take_branch = '0;
            endcase
        end
        else begin
        take_branch = '0;
        end
    end

    assign pc_src = jump | (branch & take_branch);
    //=============================== 


    //===============================
    //Program Counter
    //===============================
    logic [31:0]    p_ins_count;
    logic [31:0]    pc_next;

    logic           pc_en;
    assign pc_en = '1;

    assign pc_next = (pc_src == 1'b1) ? target_address : (p_ins_count + 4);

    Program_Counter PC (
        .clk        (clk),
        .rst_n      (rst_n),
        .pc_en      (pc_en),     
        .pc_next    (pc_next),     

        .pc_out     (p_ins_count)
    );
    //===============================


    //===============================
    //WB Selector
    //===============================
    logic [1:0]     wb_selector;
    logic [31:0]    writeback_data;
    
    assign writeback_data = (wb_selector == 2'b01) ? r_data_lsu:
                            (wb_selector == 2'b10) ? p_ins_count + 4 : ALU_result;
    //===============================


    //===============================
    //IMEM
    //===============================
    IMEM instruction_memory (
        .adress         (p_ins_count),
        .instruction    (p_instruction)
    );
    //===============================


    //===============================
    //Immeidate Generator
    //===============================
    logic [2:0]     imm_cmd;
    logic [31:0]    immediate;
    Imm_Gen Imm_Gen (
        .cmd            (imm_cmd),                
        .instruction    (p_instruction),

        .immediate_out  (immediate)
    );
    //===============================


    //===============================
    //Register File
    //===============================
    logic        file_reg_we;
    //logic [31:0] reg_file_data_w; Substited for wirtebakx data
    logic [31:0] reg_file_data_a;
    logic [31:0] reg_file_data_b;
    File_Reg File_Reg (
        .clk            (clk),
        .we             (reg_file_we),
        .reg_a          (rs1),
        .reg_b          (rs2),
        .reg_w          (rd),

        .data_w         (writeback_data),
        .data_a         (reg_file_data_a),
        .data_b         (reg_file_data_b)    
    );
    //===============================


    //===============================
    //ALU and ALU_Decoder
    //===============================
    logic [1:0]     ALU_control;

    logic [3:0]     ALU_instruction;

    logic [31:0]    ALU_result;
    logic           ALU_zero_flag;

    logic [31:0]    ALU_a_value;
    logic [31:0]    ALU_b_value;
    logic [1:0]     ALU_a_selector;
    logic           ALU_b_selector;

    assign ALU_a_value = (ALU_a_selector == 2'b01) ? p_ins_count : 
                            (ALU_a_selector == 2'b10) ? '0 : reg_file_data_a;

    assign ALU_b_value = (ALU_b_selector == 1'b0 ) ? reg_file_data_b : immediate;

    ALU_decoder alu_c (
        .ALU_control        (ALU_control),
        .funct_3            (funct_3),
        .funct_7_5          (funct_7_5),
        .op_code_5          (op_code_5),

        .instruction        (ALU_instruction)
    );

    ALU alu (
        .a_value            (ALU_a_value), 
        .b_value            (ALU_b_value), 
        .instruction        (ALU_instruction),

        .result             (ALU_result),
        .zero_flag          (ALU_zero_flag)
    );
    //===============================


    //================================
    //LSU SIGNALS
    //================================
    logic           mem_read;     
    logic           mem_write;

    logic [31:0]    addr_lsu;          
    logic [31:0]    w_data_lsu; 
            
    logic [31:0]    r_data_lsu; 

    LSU RAM_ADMIN (
        .addr               (ALU_result),
        .w_data             (reg_file_data_b),
        .funct_3            (funct_3),
        .mem_read           (mem_read),     
        .mem_write          (mem_write),    

        .dmem_adress        (adress_ram),
        .dmem_we            (we_ram),
        .dmem_w_data        (w_data_ram),

        .r_data             (r_data_ram),
        .r_data_aligned     (r_data_lsu)
    );
    
    logic [3:0]     we_ram;
    logic [31:0]    w_data_ram;
    logic [31:0]    adress_ram;

    logic [31:0]    r_data_ram;

    DMEM RAM ( //ok
        .clk        (clk),
        .we         (we_ram),
        .w_data     (w_data_ram),
        .adress     (adress_ram),
        
        .r_data     (r_data_ram)
    );
    //===============================


endmodule
