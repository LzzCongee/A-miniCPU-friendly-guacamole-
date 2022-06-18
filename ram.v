`include "minicpu.h"
// 访存阶段
// 读写操作：写数据、读数据
// ram中存放以0结尾的字符串
module ram (
	input wire [`AddrBus] addr,
	output reg [`DataBus] d_out,
	input wire [`DataBus] d_in,
	input wire rd_, 
	input wire wr_,
	input wire clk
);
	reg [`DataBus] mem [255:0];
	parameter BYTES = 256;
	integer j;
	// 读数据
	always @(*)
		if(rd_==`ENABLE_) begin 
			d_out = mem[addr];
			$write("!%-5d: !READ_: ", $time);	
			$write("%x", addr);
			$write("   ");
			$write("%x", d_out);
			$write("\n");	
		end
		else d_out = 8'hxx;
	// 写数据
	always @(posedge clk)
		if(wr_==`ENABLE_) begin 
			mem[addr] <= d_in;
			$write("!%-5d: !WRITE_: ", $time);	
			$write("%x", addr);
			$write("   ");
			$write("%x", d_in);
			$write("\n");	
			end
			
	
	integer i;											//
	initial												//
		$readmemh("ram.txt", mem, 0, BYTES-1);			//
	always @(negedge clk) begin							//
		$write("%3d: ", $time);							//
		for(i=0;i<48;i=i+1)								//
			if(mem[i]!==8'hxx) $write(" %x ", mem[i]);	// 
			else $write(" . ");							//
		$write("\n");									//
	end	
			
	//
endmodule
