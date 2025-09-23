# Nombre del proyecto

## 1. Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays

## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Desarrollo

### 3.0 Descripción general del sistema

### 3.1 Módulo 1
#### 1. Encabezado del módulo
```SystemVerilog
module mi_modulo(
    input logic     entrada_i,      
    output logic    salida_i 
    );
```
#### 2. Parámetros
- Lista de parámetros

#### 3. Entradas y salidas:
- `entrada_i`: descripción de la entrada
- `salida_o`: descripción de la salida

#### 4. Criterios de diseño
Diagramas, texto explicativo...

#### 5. Testbench
Descripción y resultados de las pruebas hechas

### 3.4 Módulo de interpretación para display
```SystemVerilog
module display7 (
    input  logic [3:0] s_mux,
    output logic [6:0] seg
);
```
#### 2. Parámetros
- Lista de parámetros

#### 3. Entradas y salidas:
- `s_mux`: es la palabra que sale del módulo selector, indica si lo que se representa es la palabra corregida(en caso de haber correción), la palabra que contiene uno o más errores ingresada a la fpga, o el síndrome calculado en el módulo de corrección. 
- `seg`: es una palabra de 7 bits, cada uno conectado a las terminales del display de 7 segmentos.

#### 4. Criterios de diseño
El sistema recibe una palabra de cuatro bits que puede ser: la palabra resultante del módulo de corrección, la palabra con error o el síndrome, el código asigna cada palabra posible a un conjunto alfa de 7 bits, esos 7 bits encenderán un segmento del display cada uno y la palabra de 4 bits ingresada se verá representada con su equivalente en sistema hexadecimal en el display(ver imagen). Cabe decir que no hay una relación matemática entre la palabra de entrada y alfa, porque lo que alfa representa es el conjunto de leds a encender para formar un número hexadecimal en el display.
![Conexiones del módulo](/Imágenes/case_mux_7seg.png)

#### 5. Testbench
![Resultados del testbench](/Imágenes/tb_terminal.png)


## 4. Consumo de recursos

## 5. Problemas encontrados durante el proyecto

## Apendices:
### Apendice 1:
texto, imágen, etc
