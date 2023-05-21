module vendd(money,prod,clk,sold,rem);
input [6:0]money;
input [2:0]prod;
input clk;
output reg sold;
output reg [6:0]rem;
reg [6:0]sum=0;
parameter [1:0]rcv=1,pros=2,trans=3;
reg [1:0]state,nstate;
reg is_amt;

always @(money) 
begin
sum<=money+sum;
end
always @(posedge clk) 
begin
if(prod>0)
state<=#10 nstate;
else
state<=state;
end

always @(posedge clk)
begin
case(state)
    rcv:begin
	      sold=0;
			is_amt=0;
         if(sum>0)
			nstate=pros;
			else
			nstate=rcv;
			end
	 pros:begin
	       case(prod)
			 3'b001:begin
			      if(sum>=5)
					begin
					rem=sum-5;
					is_amt=1;
					nstate=trans;
					end
					else
					begin
					is_amt=0;
					nstate=pros;
					end
				  end
			3'b010:begin
			      if(sum>=10)
					begin
					rem=sum-10;
					is_amt=1;
					nstate=trans;
					end
					else
					begin
					is_amt=0;
					nstate=pros;
					end
				  end
			3'b011:begin
			      if(sum>=15)
					begin
					rem=sum-15;
					is_amt=1;
					nstate=trans;
					end
					else
					begin
					is_amt=0;
					nstate=pros;
					end
				  end
		  	3'b100:begin
			      if(sum>=20)
					begin
					rem=sum-20;
					is_amt=1;
					nstate=trans;
					end
					else
					begin
					is_amt=0;
					nstate=pros;
					end
				  end
			default:	nstate=rcv;
			endcase
			end
	trans:begin
	       if(is_amt==1)
			    begin
				 sold=1;
				 nstate=rcv;
				 sum=0;
				 end
		    else
			 begin
			 sold=0;
			 nstate=pros;
			 end
			end
	default:nstate=rcv;
  endcase				 
end				 
endmodule