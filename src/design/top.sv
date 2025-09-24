module top (
    input  logic        reloj,
    input  logic [3:0]  dato_entrada,   // dato original (4 bits)
    input  logic [7:0]  dato_error,     // palabra forzada con error
    input  logic [1:0]  e_mux,          // selector del mux
    output logic [6:0]  seg,            // display de 7 segmentos
    output logic [7:0]  led,            // leds con palabra codificada
    output logic        simplerror_detectado,
    output logic        doblerror_detectado,
    output logic        led_doblerror
);

    // Señales internas
    logic [7:0] palabra_codificada;
    logic [7:0] recibido;
    logic [3:0] corregido;
    logic [7:0] palabra_corregida;
    logic       error_simple, error_doble;
    logic       s1, s2, s3, st;
    logic [3:0] s_mux;

    // Instanciación del codificador
    Codificador codificador (
        .reloj(reloj),
        .dato_entrada(dato_entrada),
        .palabra(palabra_codificada)
    );

    // Mostrar palabra codificada en leds
    leds leds (
        .palabra(palabra_codificada),
        .led(led)
    );

    // Decodificador
    Decodificador decodificador (
        .reloj(reloj),
        .dato_error(dato_error),
        .palabra(palabra_codificada),
        .recibido(recibido),
        .error_simple(error_simple),
        .error_doble(error_doble),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .st(st)
    );

    // Corrector de error
    Correccion_de_error correccion (
        .reloj(reloj),
        .recibido(recibido),
        .error_simple(error_simple),
        .error_doble(error_doble),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .st(st),
        .corregido(corregido),
        .palabra_corregida(palabra_corregida),
        .simplerror_detectado(simplerror_detectado),
        .doblerror_detectado(doblerror_detectado),
        .led_doblerror(led_doblerror)
    );

    // Mux para seleccionar qué mostrar en el display
    mux mux (
        .e_mux(e_mux),
        .corregido(corregido),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .p_error(recibido),
        .s_mux(s_mux)
    );

    // Display 7 segmentos
    display7 display (
        .s_mux(s_mux),
        .seg(seg)
    );

endmodule

