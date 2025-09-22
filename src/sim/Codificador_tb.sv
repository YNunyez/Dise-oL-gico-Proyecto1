`timescale 1ns/1ps

module codificador_tb;

    logic reloj;
    logic [3:0] dato_entrada;
    logic [7:0] palabra;

    // Instancia del codificador
    Codificador uut (
        .reloj(reloj),
        .dato_entrada(dato_entrada),
        .palabra(palabra)
    );

    // Generador de reloj
    initial reloj = 0;
    always #5 reloj = ~reloj;

    initial begin
        $display("=========== Test Codificador ===========");

        dato_entrada = 4'b1010; #10;
        $display("Entrada=%b | Codificado=%b", dato_entrada, palabra);

        dato_entrada = 4'b0010; #10;
        $display("Entrada=%b | Codificado=%b", dato_entrada, palabra);

        dato_entrada = 4'b1101; #10;
        $display("Entrada=%b | Codificado=%b", dato_entrada, palabra);

        $display("=========== Fin Test Codificador ========");
        $finish;
    end

endmodule
