module Codificador ( 
    input logic reloj, // Señal de reloj 
    input logic [3:0] dato_entrada, // Dato original 
    output logic [7:0] palabra, // Palabra Hamming codificada 
    output logic [5:0] led, //LEDS posiciones 1-6 
    output logic [1:0] leds_6_7 //LEDS posiciones 7-8 
    ); 
    // Codificación Hamming (7,4) con bit de paridad global 
    always_comb begin 
        palabra[3] = dato_entrada[0]; // d1 
        palabra[5] = dato_entrada[1]; // d2 
        palabra[6] = dato_entrada[2]; // d3 
        palabra[7] = dato_entrada[3]; // d4 
        // Bits de paridad 
        palabra[1] = palabra[3] ^ palabra[5] ^ palabra[7]; // p1 
        palabra[2] = palabra[3] ^ palabra[6] ^ palabra[7]; // p2 
        palabra[4] = palabra[5] ^ palabra[6] ^ palabra[7]; // p3 
        palabra[0] = palabra[1] ^ palabra[2] ^ palabra[3] ^ 
        palabra[4] ^ palabra[5] ^ palabra[6] ^ palabra[7]; // paridad total 
    end 

    assign led[5:0] = palabra[5:0]; // Muestran los primero 6 bits 
    assign leds_6_7[0] = palabra[6]; // LED adicional con bit 6 
    assign leds_6_7[1] = palabra[7]; // LED adicional con bit 7 

 endmodule