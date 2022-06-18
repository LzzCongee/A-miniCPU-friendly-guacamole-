`include "minicpu.h"

`define ins	 rom_data[23:20]
`define fun	 rom_data[19:16]
`define rA	 rom_data[14:12]
`define rB	 rom_data[10: 8]
`define rC	 rom_data[ 6: 4]
`define valC rom_data[ 7: 0]

module minicpu (
	output wire [`AddrBus] ram_addr,
	output wire [`DataBus] ram_d_in,
	input  wire [`DataBus] ram_d_out,
	output reg ram_rd_, ram_wr_,

	output wire [`AddrBus] rom_addr,
	input  wire [`Rom_Bus] rom_data,

	input  wire clk,
	input  wire rst_
);
	reg  [`AddrBus] valP;
	wire [`DataBus] valA, valB, valE;
	reg  [2:0] dstM, dstE;
	reg  [`DataBus] aluB;
	reg  [`DataBus] aluA;
	reg  [2:0] regA;
	reg  [2:0] regB;
	reg  [3:0] op;	// operator
	wire [1:0] cc;	// condition
	reg  [`AddrBus] new_pc;	
	
	// 
	PC PC (
	.new_pc (new_pc),
	.pc     (rom_addr),
	.clk    (clk),
	.rst_   (rst_)
	);
	
	always @(*) begin
		valP = rom_addr + ((`ins==`HLT)? 0: (`ins==`NOP||`ins==`RET)? 1: 3);
		//
		dstM = (`ins==`POP)? `rA : (`ins==`LD )? `rB: `R0;
		// 运算类指令、传送指令
		dstE = (`ins==`PUSH||`ins==`POP||`ins==`CALL||`ins==`RET)? `RSP : (`ins==`OPR)? `rC: (`ins==`OPI||`ins==`IRMOV||`ins==`RRMOV)? `rB: `R0;
		end
	//regA = (`ins==`POP)? `RSP : `rA;
	//regB = (`ins==`PUSH||`ins==`POP)? `RSP : `rB;
	regfile regfile (
	.srcA ((`ins==`POP||`ins==`RET)? `RSP:`rA),
	.srcB ( (`ins==`PUSH||`ins==`POP||`ins==`CALL||`ins==`RET)? `RSP:`rB ),
	.valA (valA),
	.valB (valB),
	.dstM (dstM),
	.dstE (dstE),	
	.valM (ram_d_out),
	.valE (valE),
	.clk  (clk),
	.we_  (~rst_)
	);
	// 给执行阶段准备数据
	always @(*) begin
		aluB = (`ins==`RRMOV)? valA:(`ins==`LD||`ins==`ST||`ins==`OPI||{`ins, `fun}=={`JMP, `BNG}||`ins==`IRMOV||`ins==`RMMOV)? `valC: valB;
		op = (`ins==`POP||`ins==`RET)? 4'h4 : (`ins==`PUSH||`ins==`CALL)? 4'h3: (`ins==`IRMOV||`ins==`RMMOV||`ins==`RRMOV)? `ADD : (`ins==`OPR||`ins==`OPI)? `fun : (`ins==`JMP&&`fun!=`BNG)? `SUB: `ADD;
		end

		// 生成访问数据内容RAM的地址和数据
	//aluA = (`ins==`RMMOV) ? valB : valA;
	ALU ALU (
    .A  ((`ins==`RRMOV)? 8'h0: (`ins==`RMMOV) ? valB : valA),
    .B  (aluB),
    .E  (valE),
	.op (op),
    .cc (cc)	// set when E = A - B, (A==B)? 1x: (A>B)? 01: 00.
	);

	assign ram_addr = (`ins==`POP||`ins==`RET) ? valA : valE;	// 访存阶段所需的内存地址
	assign ram_d_in = (`ins==`CALL)? valP:(`ins==`RMMOV||`ins==`PUSH)? valA : valB;	// 访存阶段回写的数据
	// 访存阶段读写标志
	always @(*) begin
		ram_rd_ = (`ins==`LD||`ins==`POP||`ins==`RET)? `ENABLE_: `DISABLE_;
		ram_wr_ = (rst_&& (`ins==`ST||`ins==`PUSH||`ins==`RMMOV||`ins==`CALL))? `ENABLE_: `DISABLE_;
		end
		
	always @(*) begin
		new_pc = (`ins==`CALL)? `valC: (`ins==`RET)? ram_d_out:valP;	// 更新pc值
		if(`ins==`CALL) begin
			$write("----------!!CALL: %x\n",`valC);
		end
		if(`ins==`RET) begin
			$write("----------!!RET: %x\n",ram_d_out);
		end
		case ({`ins, `fun}) //无条件跳转
			{`JMP, `BNG} : new_pc = valE;
			{`JMP, `BEQ} : if( cc[1:1]) new_pc = `valC;
			{`JMP, `BNE} : if(~cc[1:1]) new_pc = `valC;
			{`JMP, `BLT} : if(~cc[1:1]&~cc[0:0]) new_pc = `valC;
			{`JMP, `BGT} : if(~cc[1:1]& cc[0:0]) new_pc = `valC;
			{`JMP, `BLE} : if( cc[1:1]|~cc[0:0]) new_pc = `valC;
			{`JMP, `BGE} : if( cc[1:1]| cc[0:0]) new_pc = `valC;
			endcase
		end
endmodule
