module vendd_test;
reg [6:0]money;
reg [2:0]prod;
reg clk;
wire sold;
wire [6:0]rem;
// Instantiate the Unit Under Test (UUT)
vendd uut (
.money(money),
.prod(prod),
.clk(clk),
.sold(sold),
.rem(rem)
);
initial begin
clk=0;
money=10;
prod=1;
// Wait 100 ns for global reset to finish
#150;
money=0;
#5;
money=5;
#5;
money=0;
#5;
money=15;
prod=2;
#200;
// Add stimulus here
end
always #5 clk=~clk   ; 
endmodule
