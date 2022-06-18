`include "minicpu.h"
// 译码和写回
// 译码阶段， 从寄存器文件中读入最多两个操作数
// 读入rA和rB指明的寄存器

module regfile (
	input wire [2:0] srcA,
	input wire [2:0] srcB,
	output reg [`DataBus] valA,
	output reg [`DataBus] valB,
	input wire [2:0] dstM,
	input wire [2:0] dstE,
	input wire [`DataBus] valM,
	input wire [`DataBus] valE,
	input wire clk,
	input wire we_	//写控制信号
);
	reg [`DataBus] rf [7:1]; // R0 is zero.
	
	// 译码阶段读取寄存器内容
	// 只要有输入就有输出
	// scrA如果有值的话 valA就来自寄存器文件，否则来自寄存器0
	always @(*) begin
		valA = (srcA)? rf[srcA]: 0;
		valB = (srcB)? rf[srcB]: 0;
		$write("%-5d: !!DecodePhase: \n", $time);
		$write("       !!valAFetching: regNum:%o  content:%x  result:valA=%x \n", srcA, rf[srcA], valA);
		$write("      !!valBFetching: regNum:%o  content:%x  result:valB=%x \n", srcB, rf[srcB], valB);
		end
		
	// 时钟上升 写入寄存器
	always @(posedge clk)
		if(we_==`ENABLE_) begin
			// 判断是将valM还是valE的值写回到寄存器当中
			// 跟指令类型有关
			if(dstM) begin 
				rf[dstM] <= valM;
				$write("%-5d: !!!!MemoryAccessResult: ",$time);	
				$write("       !!!!regNum:%o  ", dstM);
				$write("       !!!!valM: %x(x),%d(d) ", valM,valM);
				$write("\n");
			end
			if(dstE && dstE!=dstM) begin 
				rf[dstE] <= valE;
				$write("%-5d: !!!!ExecutionResult: ",$time);	
				$write("       !!!!regNum:%o  ", dstE);
				$write("       !!!!valE: %x(x),%d(d) ", valE,valE);
				$write("\n");
			end
		end
endmodule
