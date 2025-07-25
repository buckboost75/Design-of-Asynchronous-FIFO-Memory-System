`timescale 1ns / 1ns

module w2r_sync #(parameter ADDR_SIZE=4)
   (output reg [ADDR_SIZE:0] rq2_wptr,
   input [ADDR_SIZE:0] wptr,
   input rclk, rrst_n);
  reg [ADDR_SIZE:0] rq1_wptr;
  always @(posedge rclk or negedge rrst_n)
    if (!rrst_n) {rq2_wptr,rq1_wptr} <= 0;
    else         {rq2_wptr,rq1_wptr} <= {rq1_wptr,wptr};
endmodule
