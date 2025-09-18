module Correccion_de_error (
    input  logic        reloj,          // Señal de reloj
    input  logic [7:0]  recibido,       // Palabra con posible error
    input  logic        error_simple,
    input  logic        error_doble,
    input  logic        s1,
    input  logic        s2,
    input  logic        s3,
    input  logic        st,
    output logic [3:0]  corregido,      // Dato corregido
    output logic [7:0]  palabra_corregida,
    output logic        simplerror_detectado, // Indica si hubo error
    output logic        doblerror_detectado, // Indica si hubo 2 errores
    output logic        led_doblerror
);
    // Corrección (solo si es error simple)
    always_comb begin
        led_doblerror = 0;
        palabra_corregida = recibido;
        if(error_doble) begin
                led_doblerror=1;
            end
        else if (error_simple) begin
            if(s1==1 && s2==1 && s3==0)begin
                palabra_corregida[2]=~recibido[2];       
            end
            else if(s1==1 && s2==0 && s3==1)begin
                palabra_corregida[4]=~recibido[4];       
            end
            else if(s1==0 && s2==1 && s3==1)begin
                palabra_corregida[5]=~recibido[5];        
            end
            else if(s1==1 && s2==1 && s3==1)begin
                palabra_corregida[6]=~recibido[6];       
            end
        end

    end

    // Extraer datos corregidos
    always_comb begin
        corregido[0] = palabra_corregida[3];
        corregido[1] = palabra_corregida[5];
        corregido[2] = palabra_corregida[6];
        corregido[3] = palabra_corregida[7];
    end

    // Avisar error
    assign simplerror_detectado = (error_simple);
    assign doblerror_detectado = (error_doble);
endmodule