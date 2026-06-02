# RISC-V 32I - Register File (Banco de Registros)

Este módulo implementa un banco de registros (`File_Reg`) estándar de 32x32 bits para un procesador RISC-V (Arquitectura RV32I), escrito en SystemVerilog.

## Características Principales

* **32 Registros de 32 bits:** Diseño estándar de la ISA.
* **Registro Cero (x0):** Cableado siempre a `0`. Las escrituras dirigidas a este registro se ignoran automáticamente.
* **Lectura Asíncrona:** 2 puertos de lectura combinacionales (`data_a`, `data_b`) para obtener operandos en un solo ciclo.
* **Escritura Síncrona:** 1 puerto de escritura secuencial (`data_w`) habilitado por la señal `we` (*Write Enable*) en el flanco de subida del reloj.

## Banco de Pruebas (Testbench)

Se incluye el módulo de simulación `File_Reg_sim`, el cual realiza validaciones automáticas mediante *assertions* para garantizar la integridad del hardware:

1. **Test del Registro 0:** Verifica que `x0` sea inmutable.
2. **Test de Write Enable:** Comprueba que no se sobrescriben datos si `we` es `0`.
3. **Conflictos Lectura/Escritura:** Valida el comportamiento al intentar leer y escribir en la misma dirección simultáneamente.
4. **Lectura Doble:** Asegura que ambos puertos de lectura funcionen correctamente al apuntar al mismo registro.
5. **Prueba de Estrés Aleatoria:** Escribe valores aleatorios en los 31 registros disponibles y verifica su correcta lectura.
