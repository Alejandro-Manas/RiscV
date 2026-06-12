`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/11/2026 03:39:55 AM
// Design Name: 
// Module Name: Top_Module_sim
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


module Top_Module_sim(

    );

    logic clk;
    logic rst_n;

    Top_Module uut (
        .clk(clk),
        .rst_n(rst_n)
    );

    always #20 clk = ~clk;

    initial begin
        clk = 0;
        rst_n = 0;        
        

        #50 rst_n = 1;

        #100000000; 
        $display("ERROR: El test ha tardado demasiado y ha sido abortado.");
        $finish;
    end

    always @(posedge clk) begin
        if (rst_n && (uut.File_Reg.mem_reg[3] == 32'd1)) begin
            $display("========================================");
            $display("   ¡TEST PASADO CON ÉXITO! (gp == 1)   ");
            $display("========================================");
            $finish;
        end
    end

endmodule
