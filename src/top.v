module top (
    input clk,
    input rst_n,
    input ena_henon,
    output done_henon,
    input ena_ser_x,
    input ena_ser_y,
    output Q_ser_x,
    output eos_x,
    output Q_ser_y,
    output eos_y
);
    
    wire [9:0] x_out;
    wire [9:0] y_out;
    
    henon_map8 #( .WIDTH(10), .FRAC(8) ) cs (
                                            .clk(clk),
                                            .rst_n(rst_n),
                                            .en(ena_henon),
                                            .x_out(x_out),
                                            .y_out(y_out),
                                            .valid(done_henon)
                                        );
                                    

    shift #(.bits(10)) ser_x (
                                .clk(clk),
                                .rst(ena_ser_x),
                                .D(x_out),
                                .eos(eos_x),
                                .Q(Q_ser_x)
                            );

    shift #(.bits(10)) ser_y (
                                .clk(clk),
                                .rst(ena_ser_y),
                                .D(y_out),
                                .eos(eos_y),
                                .Q(Q_ser_y)
                            );


endmodule
