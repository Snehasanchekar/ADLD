module adld_sqrt_cp(
input clk,
input start,            
output reg busy,             
output reg valid,             
input  [7:0] rad,  
output reg [7:0] root,  
output reg [7:0] rem    
    );
parameter WIDTH=8;
reg [7:0] x, x_next;    
reg [7:0] q, q_next;    
reg [9:0] ac, ac_next;  
reg [9:0] test_res;    
localparam ITER = WIDTH >> 1;  
reg [$clog2(ITER)-1:0] i;     
always @(*)
  begin
test_res = ac - {q, 2'b01};
if (test_res[WIDTH+1] == 0) begin  
 {ac_next, x_next} = {test_res[WIDTH-1:0], x, 2'b0};
 q_next = {q[WIDTH-2:0], 1'b1};
        end 
else
begin
{ac_next, x_next} = {ac[WIDTH-1:0], x, 2'b0};
 q_next = q << 1;
end
end
always @(posedge clk) begin
 if (start) begin
busy <= 1;
valid <= 0;
i <= 0;
q <= 0;
 {ac, x} <= {{WIDTH{1'b0}}, rad, 2'b0};
 end else if (busy) begin
 if (i == ITER-1) begin  
busy <= 0;
 valid <= 1;
 root <= q_next;
 rem <= ac_next[WIDTH+1:2];  
end else begin  
 i <= i + 1;
 x <= x_next;
 ac <= ac_next;
 q <= q_next;
 end
 end
end
endmodule