module t_mem();
reg [9:0]addr;
reg [7:0]d_in;
wire [7:0]d_out;
reg wr,cs;
integer k,mys;
initial mys=35;
ram r1(d_out,d_in,addr,wr,cs);
initial begin
   for(k=0;k<=1023;k=k+1)
   begin
	#2 wr=1;cs=1;
	addr=k;
	d_in=(k+k)%256;
	#2 wr=0;cs=0;
	end
repeat(20)
	begin
	addr=$random(mys)%1024;
	wr=0;cs=1;
	$display("addr:%5d ,dat:%d" ,addr,d_out);
 end
 end

endmodule

module ram(d_out,d_in,addr,wr,cs);
input [9:0]addr;
input [7:0]d_in;
output [7:0]d_out;
input wr,cs;
reg [7:0]mem[0:1023];
assign d_out = mem[addr];
always@(wr or cs)
if(wr)
mem[addr]=d_in;
endmodule
