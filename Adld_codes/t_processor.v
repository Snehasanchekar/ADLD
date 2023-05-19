module t_processor;
reg clk1,clk2;
integer k;
pipe dut(clk1,clk2);
initial
	begin
	  clk1=0;clk2=0;
	  repeat (20)
	  begin
		#5 clk1=1;clk1=0;
		#5 clk2=1;clk2=0;
	  end
	end
initial 
	begin 
	  for(k=0;k<31;k=k+1)

	   dut.Reg[k]=k;
	
	    dut.mem[0] = 32'h2801000a; // ADDI R1,R0,10
	    dut.mem[1] = 32'h28020014; // ADDI R2,R0,20
	    dut.mem[2] = 32'h28030019; // ADDI R3,R0,25
	    dut.mem[3] = 32'h0ce77800; // OR R7,R7,R7
	    dut.mem[4] = 32'h0ce77800; // OR R7,R7,R7
	    dut.mem[5] = 32'h00222000; // ADD R4,R1,R2
	    dut.mem[6] = 32'h0ce77800; // OR R7,R7,R7
	    dut.mem[7] = 32'h00832800; // ADD R5,R4,R3
	    dut.mem[8] = 32'hfc000000; // HLT
	    dut.HALTED=0;
	    dut.PC=0;
 	    dut.TAKEN_BRANCH=0;
	end

initial 
 begin
  $monitor("time :%3d, R%1d= %2d", $time , dut.Reg[k]);
  #500 $finish;
 end

endmodule

module processor(clk1,clk2);
input clk1,clk2;
reg [31:0] PC,IF_ID_IR,IF_ID_NPC;
reg [31:0] ID_EX_IR,ID_EX_NPC, ID_EX_A, ID_EX_B, ID_EX_Imm;
reg [2:0] ID_EX_type, EX_MEM_type, MEM_WB_type;
reg [31:0] EX_MEM_IR, EX_MEM_ALUout,EX_MEM_B,EX_MEM_cond;
reg [31:0] MEM_WB_IR, MEM_WB_ALUout,MEM_WB_LMD;
reg [31:0] Reg [0:31];
reg [31:0] Mem [0:102];
parameter ADD=6'b000000, SUB=6'b000001, AND=6'b000010, OR=6'b000011, SLT=6'b000100, MUL=6'b000101, MLT=6'b111111, LW=6'b0010000, SW=6'b001001, ADDI=6'b001010, SUBI=6'b001011, SLTI=6'b001100,BNEQZ=6'b001101, BEQZ=6'b001110;
parameter RR_ALU=3'b000, RM_ALU=3'b001, LOAD=3'b010,STORE=3'b011, BRANCH=3'b100, HALT=3'b101;
reg HALTED;
reg TAKEN_BRANCH;

always @(posedge clk1) 
 if(HALTED == 0)
	begin 
	  if(((ex_mem_ir[31:26] == BEQZ) && (ex_mem_cond == 1))||((ex_mem_ir[31:26] == BNEQZ) && (ex_mem_cond == 0)))
		begin
		 if_id_ir <= #2 mem[ex_mem_ALUout];
		 TAKEN_BRANCH <= #2 1'b1;
		 if_id_npc <= #2 ex_mem_ALUout+1;
		 pc <= #2 ex_mem_ALUout+1;
		 end
	  else
		begin
		 if_id_ir <= #2 mem[pc];
		 if_id_npc <= #2 pc+1;
		 pc <= #2 pc+1;
		end
	end

always @(posedge clk2)
if(HALTED ==0)
begin
	if(if_id_ir[25:21] == 5'b00000) id_ex_a <=0;
	else id_ex_a <= #2 reg[if_id_ir[25:21]];

	if(if_id_ir[20:16] == 5'b00000) id_ex_b <=0;
	else id_ex_b <= #2 reg[if_id_ir[20:16]];

	id_ex_npcc <= #2 if_id_npc;
	id_ex_ir <= #2 if_id_ir;
	id_ex_imm <= {{16{if_id_ir[15]}},{if_id_ir[15:0]}};

	case(if_id_ir [31:16])
	  ADD,SUB,AND,OR,SLT,MUL : id_ex_type <= #2 RR_ALU;
	  ADDI,SUBI,SLTI	 : id_ex_type <= #2 RM_ALU;
	  LW			 : id_ex_type <= #2 LOAD;
	  SW			 : id_ex_type <= #2 STORE;
	  BENQZ,BEQZ  	  	 : id_ex_type <= #2 BRANCH;
	  HLT			 : id_ex_type <= #2 HALT;
	  default		 : id_ex_type <= #2 HALT;
	endcase
end

 always @(posedge clk1)
  if (HALTED == 0)
begin
ex_mem_type <= #2 id_ex_type;
ex_mem_ir <= #2 id_ex_ir;
 TAKEN_BRANCH <= #2 0;
 case (id_ex_type);
	RR_ALU: begin
			case(id_ex_ir[31:26])
			ADD: ex_mem_ALUout <= #2 id_ex_a + id_ex_b;
			SUB: ex_mem_ALUout <= #2 id_ex_a - id_ex_b;
			AND: ex_mem_ALUout <= #2 id_ex_a & id_ex_b;
			OR : ex_mem_ALUout <= #2 id_ex_a | id_ex_b;
			SLT: ex_mem_ALUout <= #2 id_ex_a < id_ex_b;
			MUL: ex_mem_ALUout <= #2 id_ex_a * id_ex_b;
			default: ex_mem_ALUout <=2 32'hxxxxxxxx;
			endcase
		end

RM_ALU: begin
	 case(id_ex_ir[31:26])
	 ADDI: ex_mem_ALUout <= #2 id_ex_a + id_ex_imm;
	 SUBI: ex_mem_ALUout <= #2 id_ex_a - id_ex_imm;
	 SLTI: ex_mem_ALUout <= #2 id_ex_a < id_ex_imm;
	 default: ex_mem_ALUout <= #2 32'hxxxxxxxx;
	 endcase
	end

LOAD,STORE:
	begin
	 ex_mem_ALUout <= #2 id_ex_a + id_ex_imm;
	 ex_mem_b      <= #2 id_ex_b;
	end
BRANCH:
	begin
	 ex_mem_ALUout <= #2 id_ex_npc + id_ex_imm;
	 ex_mem_cond   <= #2 (id_ex_a == 0);
	end
 endcase
end

always @(posedge clk2)
if(HALTED == 0)
begin
	mem_wb_type <= ex_mem_type;
	mem_wb_ir   <= ex_mem_ir;
  case(ex_mem_type)
	RR_ALU,RM_ALU: mem_wb_ALUout <= #2 ex_mem_ALUout;

	LOAD: mem_wb_ld <= #2 mem(ex_mem_ALUout);

	STORE: if(TAKEN_BRANCH == 0)
		mem(ex_mem_ALUout) <= ex_mem_b;
  endcase
end

endmodule
	    
