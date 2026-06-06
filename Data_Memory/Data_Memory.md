# RISC-V Data Memory (DMEM)

Este directorio contiene la implementación en SystemVerilog de la Memoria de Datos (Data Memory) para un procesador basado en la arquitectura RISC-V, junto con su respectivo banco de pruebas (testbench).

## Características Principales

* **Capacidad:** 4 KB (1024 palabras de 32 bits).
* **Lectura Asíncrona:** El bus de datos de lectura (`r_data`) es combinacional y refleja instantáneamente el contenido de la dirección solicitada.
* **Escritura Síncrona con Máscara de Bytes:** Utiliza una señal `we` (Write Enable) de 4 bits para permitir la escritura independiente de cada uno de los 4 bytes que componen una palabra de 32 bits. Esto es fundamental para dar soporte a las instrucciones de almacenamiento de RISC-V (`sb`, `sh`, `sw`).
* **Alineación de Memoria:** El acceso interno ignora los dos bits menos significativos de la dirección (`adress[31:2]`), garantizando la correcta alineación a palabras de 32 bits.

## Puertos del Módulo

| Señal | Dirección | Ancho (bits) | Descripción |
| :--- | :--- | :---: | :--- |
| `clk` | Input | 1 | Reloj del sistema. |
| `we` | Input | 4 | Señales de habilitación de escritura (un bit por cada byte de la palabra). |
| `w_data` | Input | 32 | Datos a escribir en memoria. |
| `adress` | Input | 32 | Dirección de memoria solicitada. |
| `r_data` | Output| 32 | Datos leídos de la memoria. |

## Simulación y Verificación (`DMEM_sim`)

El diseño incluye un testbench exhaustivo (`DMEM_sim.sv`) que verifica la integridad de las operaciones de lectura y escritura. El entorno de simulación realiza lo siguiente:

1. **Inicialización:** Recorre toda la memoria inicializando los valores a cero.
2. **Pruebas de Estrés Aleatorias:** Ejecuta 10,000 iteraciones con datos y direcciones aleatorias (`$urandom()`) para cada una de las 16 combinaciones posibles de la máscara de escritura (`we`).
3. **Aserciones Automáticas:** Comprueba de forma estricta mediante aserciones (`assert`) que:
   * Los bytes con el bit `we` activado se escriben correctamente.
   * Los bytes con el bit `we` desactivado mantienen su estado previo sin corromperse.
