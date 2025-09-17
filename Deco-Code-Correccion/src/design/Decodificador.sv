module Decodificador (
    input  logic        reloj,          // Señal de reloj
    input  logic [3:0]  dato_error,     // Palabra forzada con error
    input  logic [7:0]  palabra,        // Palabra Hamming codificada
    output logic [7:0]  recibido,       // Palabra con posible error
    output logic        error_simple,
    output logic        error_doble,
    output logic        s1,
    output logic        s2,
    output logic        s3,
    output logic        st
);

    // Transmisión con posible error 
    always_comb begin 
        recibido = palabra; 
        recibido[3] = dato_error[0]; 
        recibido[5] = dato_error[1]; 
        recibido[6] = dato_error[2]; 
        recibido[7] = dato_error[3]; 
    end 
    // Decodificación 
    always_comb begin 
        s1 = recibido[1] ^ recibido[3] ^ recibido[5] ^ recibido[7]; 
        s2 = recibido[2] ^ recibido[3] ^ recibido[6] ^ recibido[7]; 
        s3 = recibido[4] ^ recibido[5] ^ recibido[6] ^ recibido[7]; 
        st = recibido[0] ^ recibido[1] ^ recibido[2] ^ recibido[3] ^ 
        recibido[4] ^ recibido[5] ^ recibido[6] ^ recibido[7]; 
        error_simple = ((s1 | s2 | s3) && (st == 1)); 
        error_doble = ((s1 | s2 | s3) && (st == 0)); 
    end 
endmodule