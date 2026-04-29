/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_top (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  //assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
    assign uo_out[7:5]=3'b000;  
assign uio_out = 0;
  assign uio_oe  = 8'b11111111;

  // List all unused inputs to prevent warnings
    wire _unused = &{ui_in[3],ui_in[4],ui_in[5],ui_in[6],ui_in[7], 1'b0};
//wire rst;
   // wire valid;
   // assign rst=!rst_n;

    //henon_map #(.WIDTH(8),.FRAC(4)) henon (.clk(clk),.rst(rst),.en(ui_in[0]),.x_out(uo_out),.y_out(uio_out),.valid(valid));
    top u1(.clk(clk),
                 .rst_n(rst_n),
                 .ena_henon(ui_in[0]), 
                 .ena_ser_x(ui_in[1]),
                 .ena_ser_y(ui_in[2]),
                 .Q_ser_x(uo_out[0]),
                 .eos_x(uo_out[1]),
                 .Q_ser_y(uo_out[2]),
                 .eos_y(uo_out[3]),
                 .done_henon(uo_out[4])
                );

endmodule
