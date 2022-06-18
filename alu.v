`include "minicpu.h"
// 执行阶段**
// 生成访问数据内容RAM的地址和数据
// 根据ifun执行指令指明的操作，完成各种运算的操作
// 计算内存引用的有效地址； 增加或减少栈指针
// 计算得到valE
module ALU (
    input wire [`DataBus] A,
    input wire [`DataBus] B,  // E = A op B
    output reg [`DataBus] E,  
	input wire [3:0] op,
    output reg [1:0] cc  // Cond. code: set when E = A - B
);						 //    (A==B)? 1x: ((A>B)? 01: 00)
	always @(*) begin
		E = 8'hxx;
		cc = 2'bxx;
		case (op)
			4'h0 : E = A + B;
			4'h1 : begin
				E = A - B;
				cc = {!E, $signed(E)>0};
			end
			4'h3 : E = B + 1;
			4'h4 : E = B - 1;
			endcase
		end
endmodule
