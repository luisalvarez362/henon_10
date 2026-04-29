module henon_map8 #(
    parameter WIDTH = 10,
    parameter FRAC  = 8
)(
    input  wire                     clk,
    input  wire                     rst_n,
    input  wire                     en,
    output reg  signed [WIDTH-1:0]  x_out,
    output reg  signed [WIDTH-1:0]  y_out,
    output reg                      valid
);

    localparam signed [WIDTH-1:0] ONE     = 10'sd256;   // 1.0 * 256
    localparam signed [WIDTH-1:0] A_CONST = 10'sd358;   // 1.4 * 256 = 358.4
    localparam signed [WIDTH-1:0] B_CONST = 10'sd77;    // 0.3 * 256 =  76.8

   
    reg signed [WIDTH-1:0] x_reg;
    reg signed [WIDTH-1:0] y_reg;

    
    wire signed [2*WIDTH-1:0] x_sq_full;
    wire signed [WIDTH-1:0]   x_sq;
    wire signed [2*WIDTH-1:0] ax_sq_full;
    wire signed [WIDTH-1:0]   ax_sq;
    wire signed [2*WIDTH-1:0] bx_full;
    wire signed [WIDTH-1:0]   bx;
    wire signed [WIDTH-1:0]   x_new;
    wire signed [WIDTH-1:0]   y_new;

   
    assign x_sq_full  = x_reg   * x_reg;
    assign x_sq       = x_sq_full  >>> FRAC;

    assign ax_sq_full = A_CONST * x_sq;
    assign ax_sq      = ax_sq_full >>> FRAC;

    assign bx_full    = B_CONST * x_reg;
    assign bx         = bx_full    >>> FRAC;

    assign x_new = ONE - ax_sq + y_reg;
    assign y_new = bx;

    always @(posedge clk) begin
        if (!rst_n) begin
            x_reg <= {WIDTH{1'b0}};
            y_reg <= {WIDTH{1'b0}};
            x_out <= {WIDTH{1'b0}};
            y_out <= {WIDTH{1'b0}};
            valid <= 1'b0;
        end else if (en) begin
            x_reg <= x_new;
            y_reg <= y_new;
            x_out <= x_new;
            y_out <= y_new;
            valid <= 1'b1;
        end
    end

endmodule