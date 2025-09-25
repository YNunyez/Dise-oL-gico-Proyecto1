module leds (
    input  logic [7:0]  palabra,   // Dato original
    output logic [7:0]  led        // Palabra Hamming codificada
);
    assign led = palabra;
endmodule