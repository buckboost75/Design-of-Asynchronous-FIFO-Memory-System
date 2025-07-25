`timescale 1ns / 1ns

module FIFO_TB;

  // Parameters
  localparam DATA_SIZE = 8;
  localparam ADDR_SIZE = 4;
  localparam DEPTH = 1 << ADDR_SIZE;

  // DUT signals
  reg [DATA_SIZE-1:0] wdata;
  wire [DATA_SIZE-1:0] rdata;
  reg winc, wclk, wrst_n;
  reg rinc, rclk, rrst_n;
  wire wfull, rempty;

  // Instantiate FIFO
  FIFO_TOP #(DATA_SIZE, ADDR_SIZE) DUT (
    .rdata(rdata),
    .wfull(wfull),
    .rempty(rempty),
    .wdata(wdata),
    .winc(winc), .wclk(wclk), .wrst_n(wrst_n),
    .rinc(rinc), .rclk(rclk), .rrst_n(rrst_n)
  );

  // Write clock generation: 20ns period (50MHz)
  initial wclk = 0;
  always #10 wclk = ~wclk;

  // Read clock generation: 30ns period (~33MHz)
  initial rclk = 0;
  always #15 rclk = ~rclk;

  // Randomization seed
  integer seed = 123;

  // Stimulus
  initial begin
    wrst_n = 0; rrst_n = 0;
    winc = 0; rinc = 0;
    wdata = 0;

    // Hold reset
    #50;
    wrst_n = 1;
    rrst_n = 1;

    // Write random data
    repeat (20) begin
      @(posedge wclk);
      if (!wfull) begin
        wdata <= $random(seed) % 256;  // Random 8-bit data
        winc <= 1;
      end else begin
        winc <= 0;
      end
    end
    winc <= 0;

    // Wait a bit
    #100;

    // Start reading data
    repeat (20) begin
      @(posedge rclk);
      if (!rempty) begin
        rinc <= 1;
      end else begin
        rinc <= 0;
      end
    end
    rinc <= 0;

    // Write more random data while reading
    repeat (10) begin
      @(posedge wclk);
      if (!wfull) begin
        wdata <= $random(seed) % 256;
        winc <= 1;
      end else begin
        winc <= 0;
      end
    end
    winc <= 0;

    // Let the read pointer catch up
    repeat (20) begin
      @(posedge rclk);
      if (!rempty) begin
        rinc <= 1;
      end else begin
        rinc <= 0;
      end
    end
    rinc <= 0;

    #100;
    $finish;
  end

  // Optional: monitor
  initial begin
    $display("Time\twdata\trdata\twfull\trempty");
    $monitor("%0t\t%0d\t%0d\t%b\t%b", $time, wdata, rdata, wfull, rempty);
  end

endmodule

