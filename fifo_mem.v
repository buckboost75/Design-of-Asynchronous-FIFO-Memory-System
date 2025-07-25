`timescale 1ns / 1ns
module fifo_mem #(parameter DATA_SIZE=8,
                  parameter ADDR_SIZE=4)
    (input [DATA_SIZE-1:0] wdata, 
     output [DATA_SIZE-1:0] rdata, 
     input [ADDR_SIZE-1:0] waddr,raddr,
     input wclk,wclken,wfull
     );
     
  localparam DEPTH = 1 << ADDR_SIZE;
  reg [DATA_SIZE-1:0] mem [0:DEPTH-1];
  
  assign rdata = mem[raddr];

  always @(posedge wclk)
  if (wclken && !wfull)
      mem[waddr] <= wdata;

endmodule
     

