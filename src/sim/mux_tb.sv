`timescale 1ns/1ns

module mux_tb;

    // Entradas
    logic [1:0] e_mux;
    logic [3:0] corregido;
    logic s1, s2, s3;
    logic [7:0] p_error;

    // Salida
    logic [3:0] s_mux;

    // Instancia del módulo bajo prueba
    mux dut (
        .e_mux(e_mux),
        .corregido(corregido),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .p_error(p_error),
        .s_mux(s_mux)
    );

    initial begin
        $display("Tiempo | e_mux | corregido | p_error | s1 s2 s3 | s_mux");
        $display("--------------------------------------------------------");

        // Prueba caso 01: salida corregida
        e_mux = 2'b01;
        corregido = 4'b1010;
        p_error = 8'b00000000;
        s1 = 0; s2 = 0; s3 = 0;
        #10;
        $display("%4t | %b | %b | %b | %b %b %b | %b", $time, e_mux, corregido, p_error, s1, s2, s3, s_mux);

        // Prueba caso 10: salida palabra con error
        e_mux = 2'b10;
        corregido = 4'b0000;
        p_error = 8'b11011010; // p_error[3]=1, [5]=1, [6]=0, [7]=1 => s_mux=1011
        s1 = 0; s2 = 0; s3 = 0;
        #10;
        $display("%4t | %b | %b | %b | %b %b %b | %b", $time, e_mux, corregido, p_error, s1, s2, s3, s_mux);

        // Prueba caso 11: salida síndromes
        e_mux = 2'b11;
        corregido = 4'b0000;
        p_error = 8'b00000000;
        s1 = 1; s2 = 0; s3 = 1;
        #10;
        $display("%4t | %b | %b | %b | %b %b %b | %b", $time, e_mux, corregido, p_error, s1, s2, s3, s_mux);

        // Prueba caso default: salida por defecto
        e_mux = 2'b00;
        corregido = 4'b1111;
        p_error = 8'b11111111;
        s1 = 1; s2 = 1; s3 = 1;
        #10;
        $display("%4t | %b | %b | %b | %b %b %b | %b", $time, e_mux, corregido, p_error, s1, s2, s3, s_mux);

        $finish;
    end

endmodule