module mux (
    input  logic [1:0] e_mux,
    input  logic [3:0] corregido,
    input  logic s1,
    input  logic s2,
    input  logic s3,
    input  logic [7:0] p_error,
    output logic [3:0] s_mux
);
    // Mapeo de las entradas a la salida según e_mux
    always_comb begin
        case (e_mux)
            2'b01: s_mux = corregido; // Sa palabra corregida
            2'b10: s_mux = {p_error[3], p_error[5], p_error[6], p_error[7]}; // La palabra con error
            2'b11: s_mux = {1'b0, s1, s2, s3}; // Síndromes
            default: s_mux = 4'b0000; // Valor por defecto
        endcase
    end
endmodule