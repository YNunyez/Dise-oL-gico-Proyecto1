# Nombre del proyecto

## 1. Explicación de Subsistemas:
•	Codificador
Este módulo recibe los 4 bits de información original (dato_entrada) y los ubica en posiciones específicas dentro de la palabra Hamming (palabra[3], palabra[5], palabra[6], palabra[7]).

Luego calcula los bits de paridad (palabra[1], palabra[2], palabra[4]) mediante XOR de los datos correspondientes. Finalmente, se añade un bit de paridad global (palabra[0]) que cubre todos los demás bits. De esta forma, a partir de 4 bits de entrada se genera una palabra de 8 bits lista para transmisión, con redundancia suficiente para detección y corrección.

![Conexiones del módulo](/Imágenes/bloques_code.png)

![Resultados del tb](/Imágenes/Test_code.png)


•	Decodificador
Este modulo recibe la palabra transmitida (dato_error), que puede estar alterada por fallos. Primero la copia en la señal recibido, y luego recalcula los bits de control (s1, s2, s3, st). s1, s2, s3 corresponden a los síndromes de paridad que indican la posible posición de error, st corresponde al bit de paridad global. Con esta información, estos clasifican el error en:

Error simple si hay inconsistencias en los síndromes y la paridad global es 1.

Error doble si hay inconsistencias en los síndromes pero la paridad global es 0.

![Conexiones del módulo](/Imágenes/bloques_deco.png)

![Resultados del tb](/Imágenes/Test_deco.png)



•	Corrector de errores
En este módulo se utilizan los valores de los síndromes (s1, s2, s3) para localizar la posición del bit erróneo en caso de error simple. Dependiendo de la combinación, se invierte el bit correspondiente de palabra_corregida.
Si se detecta un error doble, no es posible corregirlo, pero se activa la señal led_doblerror para indicar la falla.

Finalmente, se extraen los 4 bits originales o corregidos (corregido).

![Conexiones del módulo](/Imágenes/bloques_error.png)

![Resultados del tb](/Imágenes/Test_error.png)

Para la simplificación de corrección de errores se debe de definir las entradas primero.

E (Error simple): Este se refiere a la salida generada en el subsistema de decodificador.

S1, S2, S3 y ST: Son bits generados también en el módulo de decodificador, tienen la función de ubicar el error.

Las salidas corresponden a:

A, B, C y D: Cada una de estas corresponden a un bit de información.

A=E*S1*S2*(S3)'

B=E*S1*(S2)'*S3

C=E*(S1)'*S2*S3

D=E*S1*S2*S3

Note que para las ecuaciones el valor de E corresponde a:

E=(S1+S2+S3)*ST

Así:

A=(S1+S2+S3)*ST*S1*S2*(S3)'

B=(S1+S2+S3)*ST*S1*(S2)'*S3

C=(S1+S2+S3)*ST*(S1)'*S2*S3

D=(S1+S2+S3)*ST*S1*S2*S3

Tomando de ejemplo a “A” se puede desarrollar de la siguiente forma:

A=S1*ST*S1*S2*(S3)'+S2*ST*S1*S2*(S3)'+S3*ST*S1*S2*(S3)'

A=ST*S1*S2*(S3)'+ST*S1*S2*(S3)'+ST*S1*S2*(S3)'

A=ST*S1*S2*(S3)'

Así se llega a las demás simplificaciones: 

B=ST*S1*(S2)'*S3

C=ST*(S1)'*S2*S3

D=ST*S1*S2*S3

•	Módulo de interpretación para display
El sistema recibe una palabra de cuatro bits que puede ser: la palabra resultante del módulo de corrección, la palabra con error o el síndrome, el código asigna cada palabra posible a un conjunto alfa de 7 bits, esos 7 bits encenderán un segmento del display cada uno y la palabra de 4 bits ingresada se verá representada con su equivalente en sistema hexadecimal en el display(ver imagen). Cabe decir que no hay una relación matemática entre la palabra de entrada y alfa, porque lo que alfa representa es el conjunto de leds a encender para formar un número hexadecimal en el display.
Variables:
- `s_mux`: es la palabra que sale del módulo selector, indica si lo que se representa es la palabra corregida(en caso de haber correción), la palabra que contiene uno o más errores ingresada a la fpga, o el síndrome calculado en el módulo de corrección. 
- `seg`: es una palabra de 7 bits, cada uno conectado a las terminales del display de 7 segmentos.
```SystemVerilog
module display7 (
    input  logic [3:0] s_mux,
    output logic [6:0] seg
);
```
![Conexiones del módulo](/Imágenes/case_mux_7seg.png)
La funcion que implementa el mux para asociar cada palabra de 4 bits a una de 7, $$D_k$$ representa la palabra de 7 bits que hace que se genere al numero k en el display, k es el valor decimal de la palabra de entrada. $$m_k$$ es el minitérmino binario que selecciona k.
![Conexiones del módulo](/Imágenes/7seg_funcion.png)

El testbench ingresa estímulos sobre el módulo e imprime en la terminal los datos de salida.
![Resultados del testbench](/Imágenes/tb_terminal.png)

•	Módulo mux
El módulo consiste en un multiplexor 4x3:1 que recibe dos bits selectores y tres palabras de cuatro bits, la palabra corregida, la palabra con error y tres bits componentes del sindrome(se agrega un cero como bit más significativo), y saca una palabra de cuatro bits que será la selección entre las tres entradas. Para cada par de bits selectores: 
00->{0,0,0,0} 
01->palabra corregida
10->palabra con error
11->síndrome
Variables:
- `mux`:Es un par de bits que se encargan de seleccionar la palabra de salida
![Conexiones del módulo](/Imágenes/mod_mux.png)

![Conexiones del módulo](/Imágenes/mod_mux_funcion.png)

•	Módulo
## 2. Referencias
[0] David Harris y Sarah Harris. *Digital Design and Computer Architecture. RISC-V Edition.* Morgan Kaufmann, 2022. ISBN: 978-0-12-820064-3

## 3. Simplificación de ecuaciones booleanas corrección de error

## 4.  Ejemplo y análisis de una simulación funcional del sistema completo
Para este caso se tiene:

Dato entrada = 0010

Para la cual genera la siguiente palabra con bits de paridad:

Codificado= 00110011 

Para el dato con error se ingresa el valor:

Dato recibido=00010011

Para lo cual se generarían las siguientes salidas:

Sindrome=101| Corregido=0010 | ErrS=1 | ErrD=0

De lo cual podemos extraer lo siguiente:
	
El error se dio en el bit 5, el cual efectivamente es el bit ingresado de forma errónea,
	Tenemos un 1 en la salida de error simple (ErrS) y un 0 en la salida de error doble (ErrD), lo cual refleja lo visto en este caso.
	Se pudo corregir el bit erróneo y llegar a la palabra original


## 5. Consumo de recursos

Se puede llegar a observar en la siguiente imagen los recursos gastados para la ejecucion del proyecto:

![Resultados del testbench](/Imágenes/Recursos.png)

## 6. Problemas encontrados durante el proyecto

Para este proyecto hubo bastantes problemas que se dieron en el desarrollo de este, un ejemplo de este es errores generados por parte del makefile cuando se cambio los nombres de las carpetas y documentos, para solucionar esto se tuvo que buscar y editar el documento para que las direcciones y nombres coincidieran con los utilizados.
Otro ejemplo de esto es en el actualizar los datos en el github, la mayoría de los casos fueron únicos, pero en su mayoría se buscaba, cancelar, abortar o detener las acciones realizadas para inicializar el proceso de guardado nuevamente. 

## Bitacora 1 (Yair)

![Bitacora](/Imágenes/bitacora1.jpg)
![Bitacora](/Imágenes/bitacora2.jpg)
![Bitacora](/Imágenes/bitacora3.jpg)
## Bitacora 2 (Sebastián)

![Bitacora](/Imágenes/Bitacora_1.png)
![Bitacora](/Imágenes/Bitacora_2.png)
![Bitacora](/Imágenes/Bitacora_3.png)
![Bitacora](/Imágenes/Bitacora_4.png)
![Bitacora](/Imágenes/Bitacora_5.png)

## Parte 2
El retardo de propagación ($$t_PD$$) se entiende como el intervalo de tiempo que pasa desde que la señal de entrada de una compuerta cruza el punto medio de su variación de voltaje (es decir, el 50 % de su amplitud) hasta que la señal de salida alcanza también ese 50 % durante su propia transición.
$$t_PD=(t_PLH+t_PHL)/2
el período total $$T$$ de la oscilación es la suma de todos esos retardos:
$$T=2Nt_PD$$
Según la figura 8: 

$$
T=124,4ns\\
$$

$$t_PLH=22,04ns$$

$$
t_PHL=19,24ns
$$
entonces:

$$T=2Nt_PD=2N((t_PLH+t_PHL)/2)$$


N=5
$$124,4ns= 2 \cdot 5 \cdot ((22,04ns+19,24)/2)$$
Figura 1:
![Captura](/Imágenes/DS0001.PNG)
Figura 2:
![Captura](/Imágenes/DS0002.PNG)
Figura 3:
![Captura](/Imágenes/DS0003.PNG)
Figura 4:
![Captura](/Imágenes/DS0004.PNG)
Figura 5:
![Captura](/Imágenes/DS0005.PNG)
Figura 6:
![Captura](/Imágenes/DS0006.PNG)
Figura 7:
![Captura](/Imágenes/DS0007.PNG)
Figura 8:
![Captura](/Imágenes/DS0008.PNG)
Figura 9:
![Captura](/Imágenes/DS0009.PNG)


