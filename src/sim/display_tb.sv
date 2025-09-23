`timescale 1ns/1ns

module display7_tb;

    reg [3:0] p;
    wire [6:0] seg;

    display7 dut (
        .palabra(p),
        .seg(seg)
    );

// Generación de estímulos
   initial begin
        $display("-------|---------|--------");
        $display("Tiempo | Entrada | Salida ");
        $display("-------|---------|--------");
        
        $monitor("Tiempo = %t, Entrada  %b   |  %b", $time, p, seg);
        
        p = 4'b0000; #10;
        p = 4'b0001; #10;  
        p = 4'b0010; #10;
        p = 4'b0011; #10;
        p = 4'b0100; #10;
        p = 4'b0101; #10;
        p = 4'b0110; #10;
        p = 4'b0111; #10;
        p = 4'b1000; #10;
        p = 4'b1001; #10;
        p = 4'b1011; #10;
        p = 4'b1100; #10;
        p = 4'b1101; #10;
        p = 4'b1110; #10;
        p = 4'b1111; #10;
   end
    initial begin
        $dumpfile("display7_tb.vcd");
        $dumpvars(0, display7_tb);
    end
endmodule