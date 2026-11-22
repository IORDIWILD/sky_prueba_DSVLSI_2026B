`timescale 1ns / 1ps

module clk_div_25mhz(
    input wire rst_n,        
    input wire clk,
    output reg clk_div
);

    reg [1:0] clk_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_count <= 2'd0;
            clk_div   <= 1'b0;
        end
        else begin
            if (clk_count == 2'd1) begin
                clk_count <= 2'd0;
                clk_div   <= ~clk_div;
            end
            else begin
                clk_count <= clk_count + 2'd1;
            end
        end
    end
endmodule

