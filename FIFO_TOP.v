`timescale 1ns / 1ns
module FIFO_TOP
#(parameter DATA_SIZE = 8,
  parameter ADDR_SIZE = 4)
  
  (output [DATA_SIZE-1:0] rdata,
   output             wfull,
   output             rempty,
   input  [DATA_SIZE-1:0] wdata,
   input              winc, wclk, wrst_n,
   input              rinc, rclk, rrst_n);
  wire   [ADDR_SIZE-1:0] waddr, raddr;
  wire   [ADDR_SIZE:0]   wptr, rptr, wq2_rptr, rq2_wptr;
    r2w_sync #(ADDR_SIZE)   sync_r2w  (.wq2_rptr(wq2_rptr), .rptr(rptr),
                           .wclk(wclk), .wrst_n(wrst_n));
    w2r_sync #(ADDR_SIZE) sync_w2r  (.rq2_wptr(rq2_wptr), .wptr(wptr),
                           .rclk(rclk), .rrst_n(rrst_n));
    fifo_mem #(DATA_SIZE, ADDR_SIZE) fifo_mem
                          (.rdata(rdata), .wdata(wdata),
                           .waddr(waddr), .raddr(raddr),
                           .wclken(winc), .wfull(wfull),
                           .wclk(wclk));
    empty #(ADDR_SIZE) rptr_empty
                          (.rempty(rempty),
                           .raddr(raddr),
                           .rptr(rptr), 
                            .rq2_wptr(rq2_wptr),
                           .rinc(rinc), .rclk(rclk),
                           .rrst_n(rrst_n));
     full  #(ADDR_SIZE)     wptr_full
                          (.wfull(wfull), .waddr(waddr),
                           .wptr(wptr), .wq2_rptr(wq2_rptr),
                           .winc(winc), .wclk(wclk),
                           .wrst_n(wrst_n));
   
endmodule
