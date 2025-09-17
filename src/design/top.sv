module top (
    input  logic [3:0] ent,   // Connect these to FPGA switches/buttons
    output logic [6:0] seg         // Connect these to the 7-segment display
);

    display7 u_display7 (
        .palabra(ent),
        .seg(seg)
    );

endmodule