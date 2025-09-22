module Decodificador (
    //input  logic        reloj,          // Señal de reloj
    input  logic [3:0]  p_error,     // Palabra forzada con error
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
    recibido[2] = p_error[0];
    recibido[4] = p_error[1];
    recibido[5] = p_error[2];
    recibido[6] = p_error[3];
    end
    // Decodificación
    always_comb begin
        s1 = recibido[0] ^ recibido[2] ^ recibido[4] ^ recibido[6];
        s2 = recibido[1] ^ recibido[2] ^ recibido[5] ^ recibido[6];
        s3 = recibido[3] ^ recibido[4] ^ recibido[5] ^ recibido[6];
        st = recibido[0] ^ recibido[1] ^ recibido[2] ^ recibido[3] ^
             recibido[4] ^ recibido[5] ^ recibido[6] ^ recibido[7];

        error_simple = ((s1 | s2 | s3) && (st == 1));
        error_doble  = ((s1 | s2 | s3) && (st == 0));
    end
endmodule