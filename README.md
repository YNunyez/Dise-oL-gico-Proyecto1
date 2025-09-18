1. Subsistemas:
•	Codificador
Este bloque recibe los bits de información originales y genera los bits de paridad correspondientes. La finalidad es permitir la detección y corrección de errores posteriores. En este caso particular, se parte de 4 bits de datos y se obtienen 4 bits adicionales de paridad.
•	Decodificador
Su función es recibir tanto los bits de datos como los de paridad. A partir de ellos, vuelve a calcular los bits de control para comprobar inconsistencias. Con esa información es posible detectar si ocurrió un error y clasificarlo como simple o doble.
•	Corrector de errores
Cuando el decodificador indica que hay un error simple, este módulo utiliza la información del síndrome para localizar la posición del bit alterado y corregirlo, de manera que se recupere la palabra original.


3. Simplificación de ecuaciones booleanas corrección de error
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

5.  Ejemplo y análisis de una simulación funcional del sistema completo
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
7. Análisis de principales problemas hallados durante el trabajo y de las soluciones aplicadas.
Para este proyecto hubo bastantes problemas que se dieron en el desarrollo de este, un ejemplo de este es errores generados por parte del makefile cuando se cambio los nombres de las carpetas y documentos, para solucionar esto se tuvo que buscar y editar el documento para que las direcciones y nombres coincidieran con los utilizados.
Otro ejemplo de esto es en el actualizar los datos en el github, la mayoría de los casos fueron únicos, pero en su mayoría se buscaba, cancelar, abortar o detener las acciones realizadas para inicializar el proceso de guardado nuevamente. 
