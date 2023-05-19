module t_pipe_ex2();
wire[15:0] z;
reg [3:0] rs1,rs2,rd,func;
reg [7:0] addr;
reg clk1,clk2;
integer k;

pipe_ex2 MYPIPE (z,rs1,rs2,rd,func,addr,clk1,clk2);
initial
 begin
	clk1=0; clk2=0;
	repeat (20)
	 begin
	  #5 clk1=1; #5 clk1=0;
	  #5 clk2=1; #5 clk2=0;
	 end
 end

initial 
 begin 
	for(k=0;k<16;k=k+1)
	 MYPIPE.regbank[k]=k;
 end

initial 
 begin 
	#5 rs1=3; rs2=5; rd=10; func=0; addr=125; //ADD
	#20 rs1=3; rs2=8; rd=12; func=2; addr=126;
	#20 rs1=3; rs2=5; rd=14; func=1; addr=128;
	#20 rs1=3; rs2=3; rd=13; func=11; addr=127;
	#20 rs1=3; rs2=5; rd=15; func=1; addr=129;
	#20 rs1=3; rs2=13; rd=16; func=0; addr=130;

	#60 for (k=125; k<131; k=k+1)
	 begin
	  $monitor ("mem[%3d] = %3d", k, MYPIPE.mem[k]);
 	 end
 end
 
initial 
 begin 
	$dumpfile ("pipe_ex2.vdc");
	$dumpvars (0, t_pipe_ex2);
	$monitor ("time: %3d, F= %3d", $time, z);
	#300 $finish;
 end
endmodule

module pipe_ex2(zout,rs1,rs2,rd,func,addr,clk1,clk2);
input [3:0] rs1,rs2,rd,func;
input[7:0] addr;
input clk1,clk2;
output [15:0] zout;
reg [15:0] l12_A,l12_B,l23_z,l34_z;
reg[3:0] l12_rd,l12_func,l23_rd;
reg[7:0] l12_addr,l23_addr,l34_addr;
reg [15:0] regbank [0:15];
reg [15:0] mem[0:255];
assign zout=l34_z;

always @(posedge clk1)
 begin
	l12_A 	  <= #2 regbank[rs1];
	l12_B	  <= #2 regbank[rs2];
	l12_rd    <= #2 rd;
	l12_func  <= #2 func;
	l12_addr  <= #2 addr;
 end

always @(posedge clk2)
 begin
	case (func)
	 0: l23_z <= #2 l12_A +l12_B;
	 1: l23_z <= #2 l12_B -l12_A;
	 2: l23_z <= #2 l12_A *l12_B;
 	 3: l23_z <= #2 l12_A; 
 	 4: l23_z <= #2 l12_B;
	 5: l23_z <= #2 l12_A & l12_B; 
	 6: l23_z <= #2 l12_A | l12_B;
 	 7: l23_z <= #2 l12_A ^ l12_B;
	 8: l23_z <= #2 - l12_A;
 	 9: l23_z <= #2 - l12_B;
	 10: l23_z <= #2 l12_A >> 1;
	 11: l23_z <= #2 l12_A << 1;
	 default: l23_z <= #2 16'hxxxx;
	endcase 
	l23_rd   <= #2 l12_rd;
	l23_addr <= #2 l12_addr;
	end
always @(posedge clk1)
 begin
	regbank[l23_rd] <= #2 l23_z;
	l34_z    <= #2 l23_z;
	l34_addr <= #2 l23_addr;
 end
 
always @(posedge clk2)
 begin 
	mem[l34_addr] <= #2 l34_z;
 end
endmodule
