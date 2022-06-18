`include "minicpu.h"

// 更新下一条指令的地址
// 即更新PC的值
module PC (
	input wire [`AddrBus] new_pc,	// 更新后的PC
	output reg [`AddrBus] pc,		// 输出下一步要执行的指令地址
	input wire clk,
	input wire rst_
);
	always @ (posedge clk, negedge rst_)
		if (rst_==`ENABLE_) pc <= 0;
		else pc <= new_pc;
endmodule
