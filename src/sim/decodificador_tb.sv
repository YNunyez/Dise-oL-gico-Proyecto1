`timescale 1ns/1ps

module decodificador_tb;

    logic reloj;
    logic [3:0] dato_error;
    logic [7:0] palabra;
    logic [7:0] recibido;
    logic s1, s2, s3, st;
    logic error_simple, error_doble;

    // Instancia del decodificador
    Decodificador uut (
        .reloj(reloj),
        .dato_error(dato_error),
        .palabra(palabra),
        .recibido(recibido),
        .error_simple(error_simple),
        .error_doble(error_doble),
        .s1(s1), .s2(s2), .s3(s3), .st(st)
    );

    // Reloj
    initial reloj = 0;
    always #5 reloj = ~reloj;

    initial begin
        $display("=========== Test Decodificador ==========");

        // Caso sin error
        palabra = 8'b10101010; dato_error = 4'b1010; #10;
        $display("Palabra=%b | Recibido=%b | ErrS=%b | ErrD=%b | Sind=%b",
                 palabra, recibido, error_simple, error_doble, {s3,s2,s1});

        // Error simple
        palabra = 8'b00101100; dato_error = 4'b0000; #10;
        $display("Palabra=%b | Recibido=%b | ErrS=%b | ErrD=%b | Sind=%b",
                 palabra, recibido, error_simple, error_doble, {s3,s2,s1});

        // Error doble
        palabra = 8'b11011101; dato_error = 4'b1011; #10;
        $display("Palabra=%b | Recibido=%b | ErrS=%b | ErrD=%b | Sind=%b",
                 palabra, recibido, error_simple, error_doble, {s3,s2,s1});

        $display("=========== Fin Test Decodificador ======");
        $finish;
    end

endmodule
