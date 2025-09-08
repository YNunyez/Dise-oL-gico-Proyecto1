module blinky (
    input  logic        reloj,          // Señal de reloj
    input  logic [3:0]  dato_entrada,   // Dato original
    input  logic [3:0]  dato_error,     // Palabra forzada con error
    output logic [7:0]  palabra,        // Palabra Hamming codificada
    output logic [7:0]  recibido,       // Palabra con posible error
    output logic [3:0]  corregido,      // Dato corregido
    output logic        error_simple,
    output logic        error_doble,
    output logic        simplerror_detectado, // Indica si hubo error
    output logic        doblerror_detectado, // Indica si hubo 2 errores
    output logic        led_doblerror
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

    // Transmisión con posible error
    always_comb begin
    recibido = palabra;
        if (|dato_error) begin // si algún bit de dato_error es 1
            recibido[2] = dato_error[0];
            recibido[4] = dato_error[1];
            recibido[5] = dato_error[2];
            recibido[6] = dato_error[3];
        end
    end
    // Decodificación
    logic s1, s2, s3, st;
    logic [7:0] palabra_corregida;

    always_comb begin
        s1 = recibido[0] ^ recibido[2] ^ recibido[4] ^ recibido[6];
        s2 = recibido[1] ^ recibido[2] ^ recibido[5] ^ recibido[6];
        s3 = recibido[3] ^ recibido[4] ^ recibido[5] ^ recibido[6];
        st = recibido[0] ^ recibido[1] ^ recibido[2] ^ recibido[3] ^
             recibido[4] ^ recibido[5] ^ recibido[6] ^ recibido[7];

        error_simple = ( (s1 | s2 | s3) && (st == 1) );
        error_doble  = ( (s1 | s2 | s3) && (st == 0) );
    end

    // Corrección (solo si es error simple)
    always_comb begin
        led_doblerror = 0;
        palabra_corregida = recibido;
        if(error_doble) begin
                led_doblerror=1;
            end
        else if (error_simple) begin
            if(s1==1 && s2==0 && s3==0)begin
                palabra_corregida[2]=~recibido[2];       
            end
            else if(s1==0 && s2==1 && s3==0)begin
                palabra_corregida[4]=~recibido[4];       
            end
            else if(s1==1 && s2==1 && s3==0)begin
                palabra_corregida[5]=~recibido[5];        
            end
            else if(s1==0 && s2==0 && s3==1)begin
                palabra_corregida[6]=~recibido[6];       
            end
        end

    end

    // Extraer datos corregidos
    always_comb begin
        corregido[0] = palabra_corregida[2];
        corregido[1] = palabra_corregida[4];
        corregido[2] = palabra_corregida[5];
        corregido[3] = palabra_corregida[6];
    end

    // Avisar error
    assign simplerror_detectado = (error_simple);
    assign doblerror_detectado = (error_doble);
endmodule