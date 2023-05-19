module car_park_tb;
reg clk;
reg reset;

reg sensor1;
reg sensor2;
reg[3:0]password;
reg enable;
wire success;
wire failure;
wire busy;
wire[15:0]display;


car_parking uut(
.clk(clk),
.reset(reset),
.sensor1(sensor1),
.sensor2(sensor2),
.password(password),
.enable(enable),
.success(success),
.failure(failure),
.busy(busy),
.display(display)
);

initial begin 
clk = 0;
reset = 1;
sensor1 = 0;
password = 4'b0000;
enable  = 0;
#10 reset = 0;

end


always #5 clk = ~clk;

initial begin 
reset = 0;
enable  = 1;
sensor1 = 1;
password = 4'b1111;
#10

reset = 0;
enable  = 1;
sensor1 = 1;
sensor2=1;
password = 4'b1101;
#10


$display("  %b %b %b %b ",reset,sensor1,sensor2,password );

reset = 0;
enable  = 1;
sensor1 = 0;
sensor2=0;
password = 4'b1110;
#10


$display("  %b %b %b %b",reset,sensor1,sensor2,password);
#40 $finish;
end
endmodule


module car_parking(
input clk,
input reset,
input sensor1,
input enable,
input  sensor2,
input[3:0]password,
output reg success,
output reg failure,
output reg busy,
output reg [15:0]display

);

reg[3:0]password_entered;
reg[1:0]state;
parameter idle = 2'b00, waiting = 2'b01, checking = 32'b10 , re_enter = 32'b11;


always@(posedge clk,reset)
begin

if(reset)begin
success <=0;
failure <= 0;
busy <= 0;
password_entered <= 0;
state <= idle;

end else begin

case(state)

idle:begin

if(enable)
begin

busy <= 1;
state<= waiting;
end
end


waiting: begin

if(sensor1)begin

state<= checking;

end
end

checking:begin

if(password_entered==4'b1101&& sensor2==1)begin
success<= 1;



end
 else begin

failure<= 1;

state<= re_enter;

end
end
re_enter:begin
if(sensor1)begin
state <= checking;
end
end
endcase
end
end

always@(sensor1,password,enable)begin
if(state==checking && sensor1 && enable )begin
password_entered <= password;
end
end
endmodule