# ALU Decoder

## 1. Descripción
El decodificador de la ALU (`ALU_decoder`) actúa como un controlador secundario. Recibe una orden general de la Unidad de Control Principal (`ALU_control` o `ALUOp`) y, combinándola con los bits de la instrucción actual (`funct_3`, bit 30 y bit 5), determina la operación matemática o lógica exacta que debe ejecutar la ALU de RISC-V.

## 2. Entradas y Salidas
*   **`ALU_control` [1:0]**: Señal maestra. `00` (Memoria), `01` (Saltos/Branch), `10` (Aritmética).
*   **`funct_3` [2:0]**: Bits [14:12] de la instrucción. Define la operación (suma, shifts, xor...).
*   **`funct_7_5`**: Bit 30 de la instrucción. Distingue entre operaciones como `add` (0) y `sub` (1), o `srl` (0) y `sra` (1).
*   **`op_code_5`**: Bit 5 de la instrucción. Diferencia las instrucciones Tipo-R (operaciones entre registros) de las Tipo-I (operaciones con inmediatos) para evitar restas erróneas con inmediatos negativos.
*   **`instruction` [3:0]**: Salida conectada a la ALU indicando el comando final.

---

## 3. Código en SystemVerilog (`ALU_decoder.sv`)

```systemverilog
`timescale 1ns / 1ps

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
            2'b00   :   instruction = ALU_add; // Memoria: Siempre suma base + offset
    
            2'b01   :   instruction = ALU_sub; // Branch: Siempre resta para comparar

            default : begin                    // Aritmética (ALU_control == 2'b10)
                case (funct_3)
                    // Solo resta si es Tipo-R (bit 5 a '1') y el bit 30 es '1'
                    3'b000  : instruction = (funct_7_5 == 1'b1 && op_code_5 == 1'b1)? ALU_sub : ALU_add;

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
```

---

## 4. Testbench con SVA (`ALU_decoder_sim.sv`)
Testbench autocomprobable utilizando *SystemVerilog Assertions* (SVA) para validar el comportamiento combinacional del módulo y evitar regresiones.

```systemverilog
`timescale 1ns / 1ps

`include "ALU_header.svh"
import ALU_header::*;

module ALU_decoder_sim();

    logic [1:0] ALU_control;
    logic [2:0] funct_3;
    logic       funct_7_5;
    logic       op_code_5;

    logic [3:0] instruction;

    ALU_decoder uut (
        .ALU_control    (ALU_control),
        .funct_3        (funct_3),
        .funct_7_5      (funct_7_5),
        .op_code_5      (op_code_5)
    );

    initial begin
        ALU_control = '0;
        funct_3     = '0;
        funct_7_5   = '0;
        op_code_5   = '0;

        // Testing ALU control for memory functions (ALU_control = 00). ADD order 
        #1;
        ALU_control = 2'b00;
        funct_3     = '0;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1
        assert(instruction === ALU_add) else
            $error("[%0t] ASSERT ERROR: ALU control does not work for memory add instruction.", $time);

        // Testing that ALU control is not interfered by other inputs when it is not necessary
        #1;
        ALU_control = 2'b00;
        funct_3     = '1;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_add) else
            $error("[%0t] ASSERT ERROR: ALU control is interfered by other signals", $time);

        // Testing ALU control for branch functions (ALU_control = 01). SUB order
        #1;
        ALU_control = 2'b01;
        funct_3     = '0;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_sub) else
            $error("[%0t] ASSERT ERROR: ALU control does not work for branch sub instruction.", $time);

        // Testing normal ALU functions (ALU_control = 10)

        // ADD / ADDI
        #1;
        ALU_control = 2'b10;
        funct_3     = '0;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_add) else
            $error("[%0t] ASSERT ERROR: ALU add function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = '0;
        funct_7_5   = '1;
        op_code_5   = '0; // ADDI con inmediato negativo
        #1;
        assert(instruction === ALU_add) else
            $error("[%0t] ASSERT ERROR: ALU add function fails on negative immediate", $time);

        #1;
        ALU_control = 2'b10;
        funct_3     = '0;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_add) else
            $error("[%0t] ASSERT ERROR: ALU add function does not work", $time);

        // SUB
        #1;
        ALU_control = 2'b10;
        funct_3     = '0;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_sub) else
            $error("[%0t] ASSERT ERROR: ALU sub function does not work", $time);
        
        // SLL
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b001;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_sll) else
            $error("[%0t] ASSERT ERROR: ALU sll function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b001;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_sll) else
            $error("[%0t] ASSERT ERROR: ALU sll function does not work", $time);

        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b001;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_sll) else
            $error("[%0t] ASSERT ERROR: ALU sll function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b001;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_sll) else
            $error("[%0t] ASSERT ERROR: ALU sll function does not work", $time);

        // SLT
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b010;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_lt) else
            $error("[%0t] ASSERT ERROR: ALU slt function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b010;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_lt) else
            $error("[%0t] ASSERT ERROR: ALU slt function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b010;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_lt) else
            $error("[%0t] ASSERT ERROR: ALU slt function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b010;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_lt) else
            $error("[%0t] ASSERT ERROR: ALU slt function does not work", $time);
        
        // SLTU
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b011;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_ltu) else
            $error("[%0t] ASSERT ERROR: ALU sltu function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b011;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_ltu) else
            $error("[%0t] ASSERT ERROR: ALU sltu function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b011;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_ltu) else
            $error("[%0t] ASSERT ERROR: ALU sltu function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b011;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_ltu) else
            $error("[%0t] ASSERT ERROR: ALU sltu function does not work", $time);

        // XOR
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b100;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_xor) else
            $error("[%0t] ASSERT ERROR: ALU xor function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b100;
        funct_7_5   = '1;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_xor) else
            $error("[%0t] ASSERT ERROR: ALU xor function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b100;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_xor) else
            $error("[%0t] ASSERT ERROR: ALU xor function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b100;
        funct_7_5   = '1;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_xor) else
            $error("[%0t] ASSERT ERROR: ALU xor function does not work", $time);

        // SRL
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b101;
        funct_7_5   = '0;
        op_code_5   = '0;
        #1;
        assert(instruction === ALU_srl) else
            $error("[%0t] ASSERT ERROR: ALU srl function does not work", $time);
        
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b101;
        funct_7_5   = '0;
        op_code_5   = '1;
        #1;
        assert(instruction === ALU_srl) else
            $error("[%0t] ASSERT ERROR: ALU srl function does not work", $time);

        // SRA
        #1;
        ALU_control = 2'b10;
        funct_3     = 3'b10
