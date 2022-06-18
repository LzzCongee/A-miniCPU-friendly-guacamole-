`include "minicpu.h"

module rom (
	input  wire [`AddrBus] addr,
	output wire [`Rom_Bus] data
);
	reg [`DataBus] mem [255:0];
	parameter BYTES = 256;
	
	// data是读出的指令 一次读出3个字节的指令编码
	assign data = {mem[addr], mem[addr+1], mem[addr+2]};

	initial
		//$readmemh("rom.txt", mem, 0, BYTES-1);
		$readmemh("testRom.txt", mem, 0, BYTES-1);
endmodule




