`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2026 01:53:32 AM
// Design Name: 
// Module Name: LSU
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


module LSU(
    input   logic [31:0]    addr,           //usado
    input   logic [31:0]    w_data,         //usado
    input   logic [2:0]     funct_3,        //usado
    input   logic           mem_read,       //usado
    input   logic           mem_write,      //usado

    output  logic [31:0]    dmem_adress,    //usado
    output  logic [3:0]     dmem_we,        //usado
    output  logic [31:0]    dmem_w_data,    //usado

    input   logic [31:0]    r_data,         //usado
    output  logic [31:0]    r_data_aligned  //usado
    );

    assign dmem_adress = {addr[31:2], 2'b00};

    always_comb begin

        //Load Functions
        if(mem_read) begin
            case(funct_3)

                //Byte
                3'b000 : begin
                    case(addr[1:0])
                        2'b00   : r_data_aligned = {{24{r_data[ 7]}}, r_data[7:0]};
                        2'b01   : r_data_aligned = {{24{r_data[15]}}, r_data[15:8]};
                        2'b10   : r_data_aligned = {{24{r_data[23]}}, r_data[23:16]};
                        2'b11   : r_data_aligned = {{24{r_data[31]}}, r_data[31:24]};
                        default : r_data_aligned = '0;
                    endcase
                end
                
                //Half Word
                3'b001 : begin
                    case(addr[1])
                        1'b0    : r_data_aligned  = {{16{r_data[15]}}, r_data[15:0]};
                        1'b1    : r_data_aligned  = {{16{r_data[31]}}, r_data[31:16]}; 
                        default : r_data_aligned = '0;
                    endcase
                end

                //Word
                3'b010 : begin
                    r_data_aligned = r_data;
                end

                //Byte Unsigned
                3'b100 : begin 
                    case(addr[1:0])
                        2'b00   : r_data_aligned = {24'd0, r_data[7:0]};
                        2'b01   : r_data_aligned = {24'd0, r_data[15:8]};
                        2'b10   : r_data_aligned = {24'd0, r_data[23:16]};
                        2'b11   : r_data_aligned = {24'd0, r_data[31:24]};
                        default : r_data_aligned = '0;
                    endcase
                end

                //Half Word Unsigned
                3'b101 : begin
                    case(addr[1])
                    1'b0    : r_data_aligned = {16'd0, r_data[15:0]};
                    1'b1    : r_data_aligned = {16'd0, r_data[31:16]};
                    default : r_data_aligned = '0;
                    endcase
                end

                default : r_data_aligned = '0;
            endcase
        end else begin
            r_data_aligned = '0;
        end

        //Store
        if(mem_write) begin

            case(funct_3)
                //Byte
                3'b000 : begin
                    dmem_w_data = {w_data[7:0], w_data[7:0], w_data[7:0],w_data[7:0]};
                    case(addr[1:0])
                        2'b00   : dmem_we = 4'b0001;
                        2'b01   : dmem_we = 4'b0010;
                        2'b10   : dmem_we = 4'b0100;
                        2'b11   : dmem_we = 4'b1000;
                        default : dmem_we = '0;
                    endcase
                end

                //Half Word
                3'b001 : begin
                    dmem_w_data = {w_data[15:0], w_data[15:0]};
                    case(addr[1])
                    1'b0    : dmem_we = 4'b0011;
                    1'b1    : dmem_we = 4'b1100;
                    default : dmem_we = '0;
                    endcase
                end

                //Wprd
                3'b010 : begin
                    dmem_w_data = w_data;
                    dmem_we = 4'b1111;
                end

                default : begin
                    dmem_we     = '0;
                    dmem_w_data = '0;
                end
            endcase
        end else begin
            dmem_we     = '0;
            dmem_w_data = '0;
        end
        
    end



endmodule
