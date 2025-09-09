module Codificador (
    input  logic        reloj,          // Señal de reloj
    input  logic [3:0]  dato_entrada,   // Dato original
    output logic [7:0]  palabra        // Palabra Hamming codificada
);

    // Codificación Hamming (7,4) con bit de paridad global
    always_comb begin
        palabra[2] = dato_entrada[0]; // d1
        palabra[4] = dato_entrada[1]; // d2
        palabra[5] = dato_entrada[2]; // d3
        palabra[6] = dato_entrada[3]; // d4

        // Bits de paridad
        palabra[0] = palabra[2] ^ palabra[4] ^ palabra[6]; // p1
        palabra[1] = palabra[2] ^ palabra[5] ^ palabra[6]; // p2
        palabra[3] = palabra[4] ^ palabra[5] ^ palabra[6]; // p3
        palabra[7] = palabra[0] ^ palabra[1] ^ palabra[2] ^ palabra[3] ^ palabra[4] ^ palabra[5] ^ palabra[6]; // paridad total
    end
endmodule