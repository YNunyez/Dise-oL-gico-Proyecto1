module top (
    input  logic        reloj,
    input  logic [1:0]  e_mux,
    input  logic [3:0]  dato_entrada,   // Dato original (4 bits)
    input  logic [3:0]  dato_error,     // Bits forzados con error
    output logic [6:0]  seg,            // Display 7 segmentos
    output logic [5:0]  led,            // LEDs palabra[0..5]
    output logic [1:0]  leds_6_7,       // LEDs palabra[6..7]
    output logic        simplerror_detectado,
    output logic        doblerror_detectado,
    output logic        led_doblerror
);

    // Señales internas
    logic [7:0] palabra;
    logic [7:0] recibido;
    logic [7:0] palabra_corregida;
    logic [3:0] corregido;
    logic       error_simple, error_doble;
    logic       s1, s2, s3, st;

    // Instanciación del codificador
    Codificador cod_inst (
        .reloj       (reloj),
        .dato_entrada(dato_entrada),
        .palabra     (palabra),
        .led         (led),
        .leds_6_7    (leds_6_7)
    );

    // Instanciación del decodificador
    Decodificador dec_inst (
        .reloj       (reloj),
        .dato_error  (dato_error),
        .palabra     (palabra),
        .recibido    (recibido),
        .error_simple(error_simple),
        .error_doble (error_doble),
        .s1          (s1),
        .s2          (s2),
        .s3          (s3),
        .st          (st)
    );

    // Instanciación de corrección de error
    Correccion_de_error corr_inst (
        .reloj               (reloj),
        .recibido            (recibido),
        .error_simple        (error_simple),
        .error_doble         (error_doble),
        .s1                  (s1),
        .s2                  (s2),
        .s3                  (s3),
        .st                  (st),
        .corregido           (corregido),
        .palabra_corregida   (palabra_corregida),
        .simplerror_detectado(simplerror_detectado),
        .doblerror_detectado (doblerror_detectado),
        .led_doblerror       (led_doblerror)
    );

    // Instanciación del display 7 segmentos
    display7 disp_inst (
        .corregido(corregido),
        .seg      (seg)
    );

endmodule
