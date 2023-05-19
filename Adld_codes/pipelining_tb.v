module pipelining_tb();
parameter N = 10;
wire [N-1:0]F;
reg [N-1:0]A,B,C,D;
reg clk;


pipelining PIPE(F,A,B,C,D,clk);


initial  clk = 0;
always #10 clk = ~clk;



initial begin


#5  A = 10;   B = 9;   C = 8;   D = 7;

#20 A = 10;   B = 8;   C = 5;   D = 2;

#20 A = 20;   B = 10;  C = 5;   D = 6;

#20 A = 4;    B = 4;   C = 5;   D = 7;

#20 A = 10;   B = 4;   C = 5;   D = 12;

#20 A = 10;   B = 9;   C = 5;   D = 7;

#20 A = 10;   B = 2;   C = 5;   D = 2;

#20 A = 10;   B = 5;   C = 5;   D = 5;


end

initial 

begin

$monitor ("Time:  %d,  F = %d", $time,F);
#300 $finish;
end

endmodule



module pipelining(F,A,B,C,D,clk);
parameter N=10;

input [N-1:0]A,B,C,D;
input clk;
output [N-1:0]F;

reg[N-1:0]L12_x1, L12_x2, L12_D, L23_x3, L23_D, L34_F;
assign F = L34_F;
always @(posedge clk)
begin

L12_x1 <= #4 A+B;

L12_x2 <= #4 C-D;  //STAGE 1
     
L12_D <= D;


L23_x3 <= #4 L12_x1 + L12_x2;
                      //STAGE 2
L23_D <=  L12_D;    


L34_F <= #6 L23_x3 *L23_D;    //STAGE 3

end 

endmodule


