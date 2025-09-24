`timescale 1ns/1ps

module mux_tb;

    // Entradas del mux
    logic [1:0] e_mux;
    logic [3:0] corregido;
    logic s1, s2, s3;
    logic [7:0] p_error;

    // Salida
    logic [3:0] s_mux;

    // Instancia del mux
    mux uut (
        .e_mux(e_mux),
        .corregido(corregido),
        .s1(s1),
        .s2(s2),
        .s3(s3),
        .p_error(p_error),
        .s_mux(s_mux)
    );

    // Estímulos
    initial begin
        $display("========= Test MUX =========");

        // Valores de ejemplo
        corregido = 4'b1010;
        p_error   = 8'b11001100;
        s1 = 1; s2 = 0; s3 = 1;

        // Probar selección corregido
        e_mux = 2'b01; #5;
        $display("e_mux=%b -> s_mux=%b (corregido)", e_mux, s_mux);

        // Probar selección palabra con error
        e_mux = 2'b10; #5;
        $display("e_mux=%b -> s_mux=%b (p_error[3,5,6,7])", e_mux, s_mux);

        // Probar selección síndromes
        e_mux = 2'b11; #5;
        $display("e_mux=%b -> s_mux=%b (s1,s2,s3)", e_mux, s_mux);

        // Probar default
        e_mux = 2'b00; #5;
        $display("e_mux=%b -> s_mux=%b (esperado=0000)", e_mux, s_mux);

        $display("=========== Fin Test MUX ========");
        $finish;
    end

    // VCD para GTKWave
    initial begin
        $dumpfile("mux_tb.vcd");
        $dumpvars(0, mux_tb);
    end

endmodule
