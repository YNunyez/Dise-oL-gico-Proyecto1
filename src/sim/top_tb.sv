`timescale 1ns/1ps

module top_tb;

    // =============================
    // Señales
    // =============================
    logic reloj;
    logic [3:0] dato_entrada;
    logic [7:0] dato_error;
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

    // Señales mux y display
    logic [1:0] e_mux;
    logic [3:0] s_mux;
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

    // Mux
    mux mux0 (
        .e_mux(e_mux),
        .corregido(corregido),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .p_error(recibido),
        .s_mux(s_mux)
    );

    // Display conectado a la salida del mux
    display7 disp (
        .s_mux(s_mux),
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
        $display("  Testbench Hamming SEC/DED (7,4) con mux + display ");
        $display("=======================================");

        // ---- Caso 1: sin error ----
        dato_entrada = 4'b1010;
        dato_error   = 8'b10100101; // sin error
        #10;

        e_mux = 2'b01; #5;
        $display("Caso 1.1 (MUX=01 Corregido): Entrada=%b | Cod=%b | Recibido=%b | Corr=%b | ErrS=%b | ErrD=%b | LED=%b | Disp=%b",
            dato_entrada, palabra, recibido, corregido,
            simplerror_detectado, doblerror_detectado, led_doblerror, seg);

        e_mux = 2'b10; #5;
        $display("Caso 1.2 (MUX=10 Recibido): Entrada=%b | Cod=%b | Recibido=%b | Corr=%b | ErrS=%b | ErrD=%b | LED=%b | Disp=%b",
            dato_entrada, palabra, recibido, corregido,
            simplerror_detectado, doblerror_detectado, led_doblerror, seg);

        e_mux = 2'b11; #5;
        $display("Caso 1.3 (MUX=11 Sindromes): Entrada=%b | Cod=%b | Recibido=%b | Corr=%b | ErrS=%b | ErrD=%b | LED=%b | Disp=%b| Sindrome=%b",
            dato_entrada, palabra, recibido, corregido,
            simplerror_detectado, doblerror_detectado, led_doblerror, seg,s3,s2,s1);

        // ---- Caso 2: error simple ----
        dato_entrada = 4'b0010;
        dato_error   = 8'b00010011; // error simple
        #10;

        e_mux = 2'b01; #5;
        $display("Caso 2.1 (MUX=01 Corregido): Entrada=%b | Cod=%b | Recibido=%b | Corr=%b | ErrS=%b | ErrD=%b | LED=%b | Disp=%b",
            dato_entrada, palabra, recibido, corregido,
            simplerror_detectado, doblerror_detectado, led_doblerror, seg);

        e_mux = 2'b10; #5;
        $display("Caso 2.2 (MUX=10 Recibido): Entrada=%b | Cod=%b | Recibido=%b | Corr=%b | ErrS=%b | ErrD=%b | LED=%b | Disp=%b",
            dato_entrada, palabra, recibido, corregido,
            simplerror_detectado, doblerror_detectado, led_doblerror, seg);

        e_mux = 2'b11; #5;
        $display("Caso 2.3 (MUX=11 Sindromes): Entrada=%b | Cod=%b | Recibido=%b | Corr=%b | ErrS=%b | ErrD=%b | LED=%b | Disp=%b| Sindrome=%b",
            dato_entrada, palabra, recibido, corregido,
            simplerror_detectado, doblerror_detectado, led_doblerror, seg,s3,s2,s1);

        // ---- Caso 3: error doble ----
        dato_entrada = 4'b1101;
        dato_error   = 8'b00001100; // error doble
        #10;

        e_mux = 2'b01; #5;
        $display("Caso 3.1 (MUX=01 Corregido): Entrada=%b | Cod=%b | Recibido=%b | Corr=%b | ErrS=%b | ErrD=%b | LED=%b | Disp=%b",
            dato_entrada, palabra, recibido, corregido,
            simplerror_detectado, doblerror_detectado, led_doblerror, seg);

        e_mux = 2'b10; #5;
        $display("Caso 3.2 (MUX=10 Recibido): Entrada=%b | Cod=%b | Recibido=%b | Corr=%b | ErrS=%b | ErrD=%b | LED=%b | Disp=%b",
            dato_entrada, palabra, recibido, corregido,
            simplerror_detectado, doblerror_detectado, led_doblerror, seg);

        e_mux = 2'b11; #5;
        $display("Caso 3.3 (MUX=11 Sindromes): Entrada=%b | Cod=%b | Recibido=%b | Corr=%b | ErrS=%b | ErrD=%b | LED=%b | Disp=%b| Sindrome=%b",
            dato_entrada, palabra, recibido, corregido,
            simplerror_detectado, doblerror_detectado, led_doblerror, seg,s3,s2,s1);

        $display("=======================================");
        $display("  Fin de la simulacion ");
        $display("=======================================");
        $finish;
    end

    // =============================
    // VCD para GTKWave
    // =============================
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0, top_tb);
    end
endmodule
