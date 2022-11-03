module top #(
  parameter WIDTH = 8,
  parameter DIGITS = 3
  //wont go above 3 digits 
)(
  // interface signals
  input  wire             clk,      // clock 
  input  wire             rst,      // reset 
  input  wire             en,       // enable
  input  wire [WIDTH-1:0] v,        // value to preload
  output wire [11:0]      bcd       // count output
);

  wire  [WIDTH-1:0]       count;    // interconnect wire

counter myCounter ( //first feed through counter adding 1 if rst = 0 and en = 1
  .clk (clk),
  .rst (rst),
  .en (en),
  .count (count)
);

bin2bcd myDecoder ( //output of count feed through bin2bcd function
  .x (count),
  .BCD (bcd)
);

endmodule