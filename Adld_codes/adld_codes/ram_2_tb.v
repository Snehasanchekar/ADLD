module r3am_tb;
wire [7:0]data_out;
reg [7:0]data_in;
reg [9:0]addr;
reg wr,cs;
integer k,myseed;

ram_3 RAM(data_out,data_in,addr,wr,cs);
initial 
begin
 for(k=0;k<=1023;k=k+1)
  begin
  wr=1;cs=1;
  data_in=(k+k)%256;
  #2 addr=k;wr=0;cs=0;




//repeat(5)
//begin
#2 addr=$random(myseed) % 1024;
wr=0;cs=1;
$display("Address:%5d,Data:%4d",addr,data_in);
end

end
initial myseed=35;

endmodule