`timescale 1ns/1ps

module hamming_tb;

    // =============================
    // Señales
    // =============================
    logic reloj;
    logic [3:0] dato_entrada;
    logic [3:0] dato_error;
    logic [7:0] palabra;
    logic [7:0] recibido;
    logic [3:0] corregido;
    logic [7:0] palabra_corregida;
    logic simplerror_detectado;
    logic doblerror_detectado;
    logic led_doblerror;

    // Síndromes
    logic s1, s2, s3, st;
    logic error_simple, error_doble;

    // Señales display
    logic [6:0] seg;

    // =============================
    // Instancias
    // =============================

    // Codificador
    Codificador cod (
        .reloj(reloj),
        .dato_entrada(dato_entrada),
        .palabra(palabra)
    );

    // Decodificador
    Decodificador dec (
        .reloj(reloj),
        .dato_error(dato_error),
        .palabra(palabra),
        .recibido(recibido),
        .error_simple(error_simple),
        .error_doble(error_doble),
        .s1(s1), .s2(s2), .s3(s3), .st(st)
    );

    // Corrección de error
    Correccion_de_error cor (
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

    // Display conectado al dato corregido
    display7 disp (
        .corregido(corregido),
        .seg(seg)
    );

    // =============================
    // Generador de reloj
    // =============================
    initial reloj = 0;
    always #5 reloj = ~reloj;

    // =============================
    // Estímulos
    // =============================
    initial begin
        $display("=======================================");
        $display("  Testbench Hamming SEC/DED (7,4) con display ");
        $display("=======================================");

        // Caso 1: sin error
            dato_entrada = 4'b1010;
            dato_error   = 4'b1010; // sin error
            #10;
            $display("Caso 1: Entrada=%b | Codificado=%b | Recibido=%b | Corregido=%b | ErrS=%b | ErrD=%b | LED=%b | Display: %b",
                dato_entrada, palabra, recibido, corregido,
                simplerror_detectado, doblerror_detectado, led_doblerror, seg);

        // Caso 2: error simple
            dato_entrada = 4'b0010;
            dato_error   = 4'b0000; // error simple
            #10;
            $display("Caso 2: Entrada=%b | Codificado=%b | Recibido=%b | Corregido=%b | ErrS=%b | ErrD=%b | LED=%b | Display: %b",
                dato_entrada, palabra, recibido, corregido,
                simplerror_detectado, doblerror_detectado, led_doblerror, seg);

        // Caso 3: error doble
            dato_entrada = 4'b1101;
            dato_error   = 4'b1011; // error doble
            #10;
            $display("Caso 3: Entrada=%b | Codificado=%b | Recibido=%b | Corregido=%b | ErrS=%b | ErrD=%b | LED=%b | Display: %b",
                dato_entrada, palabra, recibido, corregido,
                simplerror_detectado, doblerror_detectado, led_doblerror, seg);


        $display("=======================================");
        $display("  Fin de la simulación ");
        $display("=======================================");
        $finish;
    end

    // =============================
    // VCD para GTKWave
    // =============================
    initial begin
        $dumpfile("hamming_tb.vcd");
        $dumpvars(0, hamming_tb);
    end

endmodule
