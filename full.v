`timescale 1ns / 1ns

module full #(parameter ADDR_SIZE=4)
(output reg                wfull,
   output     [ADDR_SIZE-1:0] waddr,
   output reg [ADDR_SIZE  :0] wptr,
   input      [ADDR_SIZE  :0] wq2_rptr,
   input                     winc, wclk, wrst_n);
  reg  [ADDR_SIZE:0] wbin;
  wire [ADDR_SIZE:0] wgraynext, wbinnext;
  // GRAYSTYLE2 pointer
  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) {wbin, wptr} <= 0;
    else         {wbin, wptr} <= {wbinnext, wgraynext};
  // Memory write-address pointer (okay to use binary to address memory)
  assign waddr = wbin[ADDR_SIZE-1:0];
  assign wbinnext  = wbin + (winc & ~wfull);
  assign wgraynext = (wbinnext>>1) ^ wbinnext;
  //-----------------------------------------------------------------
  // Simplified version of the three necessary full-tests:
  // assign wfull_val=((wgnext[ADDRSIZE]    !=wq2_rptr[ADDRSIZE]  ) &&
  //                   (wgnext[ADDRSIZE-1]  !=wq2_rptr[ADDRSIZE-1]) &&
  //                   (wgnext[ADDRSIZE-2:0]==wq2_rptr[ADDRSIZE-2:0]));
  //-----------------------------------------------------------------
  assign wfull_val = (wgraynext=={~wq2_rptr[ADDR_SIZE:ADDR_SIZE-1],
                                   wq2_rptr[ADDR_SIZE-2:0]});
  always @(posedge wclk or negedge wrst_n)
    if (!wrst_n) wfull  <= 1'b0;
    else         wfull  <= wfull_val;
endmodule
