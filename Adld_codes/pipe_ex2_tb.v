module pipe_ex2_tb;
reg [3:0]rs1,rs2,rd,func;
reg [7:0]addr;
reg clk1,clk2;
wire [15:0]Zout;
integer k;

pipe_ex2 P(Zout,rs1,rs2,rd,func,addr,clk1,clk2);

initial begin
clk1=0;
clk2=0;
repeat(20)
 begin
   #5 clk1=1; #5 clk1=0;
   #5 clk2=1; #5 clk2=0;
 end
end

initial
begin
 for(k=0; k<16; k=k+1)
   P.regbank[k]=k;
 end 
    initial 
	begin
        #5 rs1=3; rs2=5; rd=10; func=0; addr=125;   //add
        #20 rs1=3; rs2=8; rd=12; func=2; addr=126;  //mul
	#20 rs1=10; rs2=5; rd=14; func=1; addr=127;  //sub
	#20 rs1=7; rs2=3; rd=13; func=11; addr=128;  //sla
	#20 rs1=10; rs2=5; rd=15; func=1; addr=129;  //sub
	#20 rs1=12; rs2=13; rd=16; func=0; addr=130;  //add
	
	#60 for(k=125; k<131; k=k+1)
	$display("Mem[%3d]=%3d",k,P.mem[k]);
       end

initial begin
       
       $monitor("Time: %3d,F=%3d",$time,Zout);

	//$dumpfile("pipe_ex2_tb.vcd");
       //#dumpvars(0,pipe_ex2_tb);
      #300 $finish;
     end
endmodule
