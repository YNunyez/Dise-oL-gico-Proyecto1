`timescale 1ns/1ps

module tb_top;

    // Señales de prueba
    logic        reloj;
    logic [3:0]  dato_entrada;
    logic [3:0]  dato_error;
    logic [6:0]  seg;
    logic [5:0]  led;
    logic [1:0]  leds_6_7;
    logic        simplerror_detectado;
    logic        doblerror_detectado;
    logic        led_doblerror;

    // Instanciar el módulo top
    top uut (
        .reloj               (reloj),
        .dato_entrada        (dato_entrada),
        .dato_error          (dato_error),
        .seg                 (seg),
        .led                 (led),
        .leds_6_7            (leds_6_7),
        .simplerror_detectado(simplerror_detectado),
        .doblerror_detectado (doblerror_detectado),
        .led_doblerror       (led_doblerror)
    );

    // Generar reloj
    initial begin
        reloj = 0;
        forever #5 reloj = ~reloj; // Periodo de 10 ns
    end

    // Estímulos
    initial begin
        // Valores iniciales
        dato_entrada = 4'b0000;
        dato_error   = 4'b0000;

        // Espera al reset implícito
        #10;

        // Caso 1: enviar 1010 sin error
        dato_entrada = 4'b1010;
        dato_error   = 4'b1010;
        #20;

        // Caso 2: enviar 1010 con un error simple en bit 0
        dato_entrada = 4'b1010;
        dato_error   = 4'b1011;
        #20;

        // Caso 3: error doble
        dato_entrada = 4'b0100;
        dato_error   = 4'b0001;
        #20;

        // Finalizar simulación
        $stop;
    end

    // Monitorizar resultados en consola
    initial begin
        $monitor("T=%0t | Entrada=%b | Error=%b | seg=%b | led_doblerror=%b | simpl=%b | dobl=%b",
                 $time, dato_entrada, dato_error, seg, led_doblerror, simplerror_detectado, doblerror_detectado);
    end

endmodule

`timescale 1ns/1ps

module hamming_tb;

    // Señales
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

    reg [3:0] p;
    wire [6:0] seg;
    display7 dut (
        .corregido(p),
        .seg(seg)
    );
    
    // Síndromes
    logic s1, s2, s3, st;
    logic error_simple, error_doble;

    // =============================
    // Instancias
    // =============================

    // Display

    display7 dis (
        .seg(seg),
        .corregido(p)
    );

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

    // Generador de reloj
    initial reloj = 0;
    always #5 reloj = ~reloj;

    // Estímulos
    initial begin
        $display("=======================================");
        $display("  Testbench Hamming SEC/DED (7,4) ");
        $display("=======================================");

        // Caso 1: sin error
        dato_entrada = 4'b1010;
        dato_error   = 4'b1010; // sin error
        #10;
        $display("Dato=%b | Codificado=%b | Recibido=%b | Corregido=%b | ErrS=%b | ErrD=%b | LED=%b | Sindrome=%b",
                 dato_entrada, palabra, recibido, corregido,
                 simplerror_detectado, doblerror_detectado, led_doblerror,s3,s2,s1);

        // Caso 2: error simple
        dato_entrada = 4'b0010;
        dato_error   = 4'b0000; // error simple
        #10;
        $display("Dato=%b | Codificado=%b | Recibido=%b | Corregido=%b | ErrS=%b | ErrD=%b | LED=%b | Sindrome=%b",
                 dato_entrada, palabra, recibido, corregido,
                 simplerror_detectado, doblerror_detectado, led_doblerror,s3,s2,s1);

        // Caso 3: error doble
        dato_entrada = 4'b1101;
        dato_error   = 4'b1011; // errores doble
        #10;
        $display("Dato=%b | Codificado=%b | Recibido=%b | Corregido=%b | ErrS=%b | ErrD=%b | LED=%b | Sindrome=%b",
                 dato_entrada, palabra, recibido, corregido,
                 simplerror_detectado, doblerror_detectado, led_doblerror,s3,s2,s1);

        $display("=======================================");
        $display("  Fin de la simulacion ");
        $display("=======================================");

        $finish;
    end

    initial begin
        $display("-------|---------|--------");
        $display("Tiempo | Entrada | Salida ");
        $display("-------|---------|--------");

        $monitor("Tiempo = %t, Entrada = %b, Salida = %b", $time , p, seg);
        
        p = 4'b0000; #10; // Caso 0
        p = 4'b0001; #10; // Caso 1
        p = 4'b0010; #10; // Caso 2
        p = 4'b0011; #10; // Caso 3
        p = 4'b0100; #10; // Caso 4
        p = 4'b0101; #10; // Caso 5
        p = 4'b0110; #10; // Caso 6
        p = 4'b0111; #10; // Caso 7
        p = 4'b1000; #10; // Caso 8
        p = 4'b1001; #10; // Caso 9
        p = 4'b1010; #10; // Caso A
        p = 4'b1011; #10; // Caso B
        p = 4'b1100; #10; // Caso C
        p = 4'b1101; #10; // Caso D
        p = 4'b1110; #10; // Caso E
        p = 4'b1111; #10; // Caso F

    end
    initial begin
        $dumpfile("hamming_tb.vcd");
        $dumpvars(0, hamming_tb);
    end

endmodule
