`timescale 1ns/1ps

module correccion_tb;

    logic reloj;
    logic [7:0] recibido;
    logic error_simple, error_doble;
    logic s1, s2, s3, st;
    logic [3:0] corregido;
    logic [7:0] palabra_corregida;
    logic simplerror_detectado, doblerror_detectado, led_doblerror;

    // Instancia del módulo
    Correccion_de_error uut (
        .reloj(reloj),
        .recibido(recibido),
        .error_simple(error_simple),
        .error_doble(error_doble),
        .s1(s1), .s2(s2), .s3(s3), .st(st),
        .corregido(corregido),
        .palabra_corregida(palabra_corregida),
        .simplerror_detectado(simplerror_detectado),
        .doblerror_detectado(doblerror_detectado),
        .led_doblerror(led_doblerror)
    );

    // Reloj
    initial reloj = 0;
    always #5 reloj = ~reloj;

    initial begin
        $display("========= Test Correccion Error =========");

        // Caso sin error
        recibido = 8'b10101010; error_simple = 0; error_doble = 0; s1=0; s2=0; s3=0; st=0; #10;
        $display("Recibido=%b | Corregido=%b | Palabra Cor=%b | ErrS=%b | ErrD=%b",
                 recibido, corregido, palabra_corregida, simplerror_detectado, doblerror_detectado);

        // Caso error simple
        recibido = 8'b10111010; error_simple = 1; error_doble = 0; s1=1; s2=0; s3=1; st=0; #10;
        $display("Recibido=%b | Corregido=%b | Palabra Cor=%b | ErrS=%b | ErrD=%b",
                 recibido, corregido, palabra_corregida, simplerror_detectado, doblerror_detectado);

        // Caso error doble
        recibido = 8'b10111011; error_simple = 0; error_doble = 1; s1=1; s2=1; s3=0; st=1; #10;
        $display("Recibido=%b | Corregido=%b | Palabra Cor=%b | ErrS=%b | ErrD=%b",
                 recibido, corregido, palabra_corregida, simplerror_detectado, doblerror_detectado);

        $display("========= Fin Test Correccion Error =====");
        $finish;
    end

endmodule
