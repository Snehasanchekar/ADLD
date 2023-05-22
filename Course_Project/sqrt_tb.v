
module adld_sqrt_tb;
 reg clk;
 reg start;
 reg [7:0] rad;
 wire busy;
 wire valid;
 wire [7:0] root;
 wire [7:0] rem;
adld_sqrt_cp uut (
  .clk(clk), 
  .start(start), 
  .busy(busy), 
  .valid(valid), 
  .rad(rad), 
  .root(root), 
  .rem(rem)
 );
 parameter CLK_PERIOD = 10;
    parameter WIDTH = 8;
  always #(CLK_PERIOD / 2) clk = ~clk;
 initial begin
  clk = 1;

        #100    rad = 8'b00000000;  // 0
                start = 1;
        #10     start = 0;

        #50     rad = 8'b00000001;  // 1
                start = 1;
        #10     start = 0;

        #50     rad = 8'b01111001;  // 121
                start = 1;
        #10     start = 0;

        #50     rad = 8'b01010001;  // 81
                start = 1;
        #10     start = 0;

        #50     rad = 8'b01011010;  // 90
                start = 1;
        #10     start = 0;

        #50     rad = 8'b11111111;  // 255
                start = 1;
        #10     start = 0;

        #50     $finish;
end
endmodule
