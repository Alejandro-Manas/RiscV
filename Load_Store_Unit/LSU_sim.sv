`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2026 11:39:05 PM
// Design Name: 
// Module Name: LSU_sim
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


module LSU_sim(

    );

    logic [31:0]    addr;
    logic [31:0]    w_data;
    logic [2:0]     funct_3;
    logic           mem_read;
    logic           mem_write;

    logic [31:0]    dmem_adress;
    logic [31:0]    dmem_we;
    logic [31:0]    dmem_w_data;

    logic [31:0]    r_data;
    logic [31:0]    r_data_aligned;

    LSU uut(
        .addr           (addr),
        .w_data         (w_data),
        .funct_3        (funct_3),
        .mem_read       (mem_read),
        .mem_write      (mem_write),
        
        .dmem_adress    (dmem_adress),
        .dmem_we        (dmem_we),
        .dmem_w_data    (dmem_w_data),

        .r_data         (r_data),
        .r_data_aligned (r_data_aligned)
    );

//LOAD DATA TASK
    task load_data(
        logic [31:0]    addr_sim,
        logic [2:0]     funct_3_sim,
        
        logic [31:0]    r_data_sim
    );
    begin
        #1;
        addr        = addr_sim;
        w_data      = '0;
        funct_3     = funct_3_sim;
        mem_read    = '1;
        mem_write   = '0;
        r_data      = r_data_sim;
        #1;

        //funct 3 options
        case(funct_3_sim)
        //Signed

            //Byte
            3'b000 : begin
                case(addr_sim[1:0])
                    2'b00 : begin
                        assert(r_data_aligned === {{24 {r_data_sim[7]}}, r_data_sim[7:0] }) else
                            $error("[%0t] ASSERT FAILED: Function load byte. Loading byte %d of the word with adress %h does not correspond wuth expected result", $time, addr[1:0], addr);
                    end
                    2'b01 : begin
                        assert(r_data_aligned === {{24 {r_data_sim[15]}}, r_data_sim[15:8]}) else
                            $error("[%0t] ASSERT FAILED: Function load byte. Loading byte %d of the word with adress %h does not correspond with expected result", $time, addr[1:0], addr);
                    end
                    2'b10 : begin
                        assert(r_data_aligned === {{24 {r_data_sim[23]}}, r_data_sim[23:16]}) else
                            $error("[%0t] ASSERT FAILED: Function load byte. Loading byte %d of the word with adress %h does not correspond with expected result", $time, addr[1:0], addr);
                    end
                    2'b11 : begin
                        assert(r_data_aligned === {{24 {r_data_sim[31]}}, r_data_sim[31:24]}) else
                            $error("[%0t] ASSERT FAILED: Function load byte. Loading byte %d of the word with adress %h does not correspond with expected result", $time, addr[1:0], addr);
                    end
                endcase
            end

            //Half Word
            3'b001 : begin
                case(addr_sim[1])
                    1'b0 : begin
                        assert(r_data_aligned === {{16 {r_data_sim[15]}}, r_data_sim[15:0] }) else
                            $error("[%0t] ASSERT FAILED: Function load halfword. Loading halfword %d of the word with adress %h does not correspond with expected result", $time, addr[1], addr);
                    end
                    1'b1 : begin
                        assert(r_data_aligned === {{16 {r_data_sim[31]}}, r_data_sim[31:16]}) else
                            $error("[%0t] ASSERT FAILED: Function load halfword. Loading halfword %d of the word with adress %h does not correspond with expected result", $time, addr[1], addr);
                    end
                endcase
            end
            
            //Whole word
            3'b010 : begin
                assert(r_data_aligned === r_data_sim) else
                    $error("[%0t] ASSERT FAILED: Function load word, with adress %h does not correspond with expected result", $time, addr);
            end

        //Unsigned

            //Byte
            3'b100 : begin
                case(addr_sim[1:0])
                    2'b00 : begin
                        assert(r_data_aligned === {{24 {1'b0}}, r_data_sim[7:0] }) else
                            $error("[%0t] ASSERT FAILED: Function load byte unsigned. Loading byte %d of the word with adress %h does not correspond wuth expected result", $time, addr[1:0], addr);
                    end
                    2'b01 : begin
                        assert(r_data_aligned === {{24 {1'b0}}, r_data_sim[15:8]}) else
                            $error("[%0t] ASSERT FAILED: Function load byte unsigned. Loading byte %d of the word with adress %h does not correspond with expected result", $time, addr[1:0], addr);
                    end
                    2'b10 : begin
                        assert(r_data_aligned === {{24 {1'b0}}, r_data_sim[23:16]}) else
                            $error("[%0t] ASSERT FAILED: Function load byte unsigned. Loading byte %d of the word with adress %h does not correspond with expected result", $time, addr[1:0], addr);
                    end
                    2'b11 : begin
                        assert(r_data_aligned === {{24 {1'b0}}, r_data_sim[31:24]}) else
                            $error("[%0t] ASSERT FAILED: Function load byte unsigned. Loading byte %d of the word with adress %h does not correspond with expected result", $time, addr[1:0], addr);
                    end
                endcase
            end
         
            //Half Word
            3'b101 : begin
                case(addr_sim[1])
                    1'b0 : begin
                        assert(r_data_aligned === {{16 {1'b0}}, r_data_sim[15:0] }) else
                            $error("[%0t] ASSERT FAILED: Function load halfword unsigned. Loading halfword %d of the word with adress %h does not correspond with expected result", $time, addr[1], addr);
                    end
                    1'b1 : begin
                        assert(r_data_aligned === {{16 {1'b0}}, r_data_sim[31:16]}) else
                            $error("[%0t] ASSERT FAILED: Function load halfword unsigned. Loading halfword %d of the word with adress %h does not correspond with expected result", $time, addr[1], addr);
                    end
                endcase
            end
        endcase
    end
    endtask

//STORE DATA TASK
    task store_data (
        logic [31:0]    addr_sim,
        logic [31:0]    w_data_sim,
        logic [3:0]     funct_3_sim
    );
    begin
        #1;
        addr        = addr_sim;
        w_data      = w_data_sim;
        funct_3     = funct_3_sim;
        mem_read    = '0;
        mem_write   = '1;
        r_data      = '0;
        #1;

        //funct 3 cases
        case(funct_3_sim)

            //Byte
            3'b000 : begin
                assert (dmem_w_data === {{4 {w_data_sim[7:0]}}}) else
                    $error("[%0t] ASSERT FAILED: Expected format for the dmem_w_data for byte store is incorrect. The expected format is: %h. The recieved one is: %h.", $time, {4 {w_data_sim[7:0]}}, dmem_w_data);
                case(addr_sim[1:0])
                    2'b00 : begin
                        assert(dmem_we === 4'b0001) else
                            $error("[%0t] ASSERT FAILED: Expected value for dmem_we on a byte operation is: %h. Recieved one is: %h", $time, 4'b0001, dmem_we);
                    end
                    2'b01 : begin
                        assert(dmem_we === 4'b0010) else
                            $error("[%0t] ASSERT FAILED: Expected value for dmem_we on a byte operation is: %h. Recieved one is: %h", $time, 4'b0010, dmem_we);
                    end
                    2'b10 : begin
                        assert(dmem_we === 4'b0100) else
                            $error("[%0t] ASSERT FAILED: Expected value for dmem_we on a byte operation is: %h. Recieved one is: %h", $time, 4'b0100, dmem_we);
                    end
                    2'b11 : begin
                        assert(dmem_we === 4'b1000) else
                            $error("[%0t] ASSERT FAILED: Expected value for dmem_we on a byte opeartion is: %h. Recieved one is: %h", $time, 4'b10000, dmem_we);
                    end
                endcase
            end

            //Half Word
            3'b001 : begin
                assert (dmem_w_data === {{2 {w_data_sim[15:0]}}}) else
                    $error("[%0t] ASSERT FAILED: Expected format for the dmem_w_data for half word store is incorrect. The expected format is: %h. The recieved one is: %h.", $time, {2 {w_data_sim[15:0]}}, dmem_w_data);
                
                case(addr_sim[1])
                    1'b0 : begin
                        assert(dmem_we === 4'b0011) else
                            $error("[%0t] ASSERT FAILED: Expected value for dmem_we on a half word operation is: %h. Recieved one is: %h", $time, 4'b0011, dmem_we);
                    end

                    1'b1 : begin
                        assert(dmem_we === 4'b1100) else
                            $error("[%0t] ASSERT FAILED: Expected value for dmem_we on a half word operation is: %h. Recieved one is: %h", $time, 4'b1100, dmem_we);
                    end
                endcase
            end

            //Full Word
            3'b010 : begin
                assert (dmem_w_data === w_data_sim) else
                    $error("[%0t] ASSERT FAILED: Expected value for dmem_w_data on a full word operation is: %h. The recieved is: %h", $time, w_data_sim, dmem_w_data);
                
                assert (dmem_we === 4'b1111) else
                    $error("[%0t] ASSERT FAILED: Expected value for dmem_we on a full word operation is: %h. Recieved one is: %h", $time, 4'b1111, dmem_we); 
            end
        endcase
    end
    endtask


    initial begin

        //Testing the address thath enter vs the adress that goes out
        addr        = '0;
        w_data      = '0;
        funct_3     = '0;
        mem_read    = '0;
        mem_write   = '0;

        r_data      = '0;

        #1;

        for(int i = 0; i < 8; i++) begin
            addr = i;
            #1;
            assert (dmem_adress === {addr[31:2], 2'b00}) else
                $error("[%0t] ASSERT FAILED: dmem_adress does not work correctly. Expected adress: %h. Recieved adress %h", $time, {addr[31:2], 2'b00}, dmem_adress);
        end

    //Testing load functions
        //Byte
        for (int i = 0; i < 100_000; i++) begin
            load_data($urandom(), 3'b000, $urandom());
        end
        //Half Word
        for (int i = 0; i < 100_000; i++) begin
            load_data($urandom(), 3'b001, $urandom());
        end
        //Word
        for (int i = 0; i < 100_000; i++) begin
            load_data($urandom(), 3'b010, $urandom());
        end
        //Unsigned Byte
        for (int i = 0; i < 100_000; i++) begin
            load_data($urandom(), 3'b100, $urandom());
        end
        //Unsigned Half Word
        for (int i = 0; i < 100_000; i++) begin
            load_data($urandom(), 3'b101, $urandom());
        end
    
    //Testing store functions
        //Byte
        for (int i = 0; i < 100_000; i++) begin
            store_data($urandom(), $urandom(), 3'b000);
        end
        //Half Word
        for (int i = 0; i < 100_000; i++) begin
            store_data($urandom(), $urandom(), 3'b001);
        end
        //Word
        for (int i = 0; i < 100_000; i++) begin
            store_data($urandom(), $urandom(), 3'b010);
        end

        $finish;
    end
endmodule