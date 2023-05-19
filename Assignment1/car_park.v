module car_park();

reg sense_front;
reg sense_back;
reg reset;
reg clk;
reg [3:0]password;


wire s_pass;
wire [3:0] car_count;


car dut(sense_front,sense_back,reset,clk,password,s_pass,car_count);


initial begin
sense_front = 1'b0;
sense_back  = 1'b0;
reset = 1'b1;
clk   = 1'b0;
password = 4'b0000;

#12
reset = 1'b0;

sense_back = 1'b0;
sense_front = 1'b1;
#10 password = 4'b1010;
#10 sense_back = 1'b0;
sense_front = 1'b1;

#10
sense_back = 1'b0;
sense_front = 1'b1;
#10 password = 4'b0000;
#10 password = 4'b1010;
#10 sense_back = 1'b1;
sense_front = 1'b0;
#10 sense_back = 1'b0;

$display("%t %b %b %d %d",$time,clk,s_pass,car_count,dut.state);
#300 $finish;

end


always #5 clk = ~clk;

endmodule




module car(sense_front,sense_back,reset,clk,password,s_pass,car_count);
input sense_front;
input sense_back;
input reset;
input clk;
input [3:0]password;
output reg s_pass; 
output reg [3:0]car_count;

reg [1:0]state,next_state;

parameter car_enter=0,car_password=1,car_inside=2;  

always@(posedge clk) 
begin
	if (reset)
	begin
		state <= car_enter;
		car_count <= 4'b0000;	
	end	
	else
		state <= next_state;
	end



always@(*)
begin
	case(state)
	car_enter: begin
		    if(sense_front) next_state = car_password;
		    else next_state = car_enter;
	    end
	
	    
	car_password : begin
	    if(password == 4'b1010)
		begin
		   s_pass = 1'b1;
		   next_state = car_inside;
		end
	    else 
		begin
		   s_pass = 1'b0;
		   next_state = car_password;		   
		
		end
	    end
	car_inside : begin
	     if(sense_back)
	     begin
		car_count = car_count + 1'b1;   
		next_state = car_enter;
	     end
	    else
		begin
		next_state = car_inside;
		end
	     end
	default : begin
		next_state = car_enter;
		s_pass = 1'b0;
		car_count = 4'b0000;
	end
	endcase
   end
 endmodule