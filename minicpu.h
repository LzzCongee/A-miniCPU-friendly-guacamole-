`ifndef __MINICPU_HEADER__
    `define __MINICPU_HEADER__    
    `define ENABLE_		1'b0
    `define DISABLE_	1'b1
    
    `define DataBus		7:0
    `define AddrBus		7:0
    `define Rom_Bus		23:0
    
	// icode
	`define NOP			4'h0 //instruction type
    `define LD			4'h1
	`define ST			4'h2 
	`define OPR			4'h3
	`define OPI			4'h4
	`define JMP			4'h5
	`define HLT			4'hf
	// 添加的指令类型
	`define IRMOV		4'h6	// check
	`define RRMOV		4'h7	// check
	`define RMMOV		4'h8	// check
	`define PUSH		4'ha	// check
	`define POP			4'hb	// check
	`define CALL		4'hc	// check
	`define RET			4'hd	// check
	//
	
	//  ifun
	`define ADD			4'h0 //fun for alu
	`define SUB			4'h1

	`define BNG			4'h0 //fun for branch 
	`define BEQ			4'h1
	`define BNE			4'h2
	`define BLT			4'h3
	`define BGT			4'h4
	`define BLE			4'h5
	`define BGE			4'h6
	// define register
	`define R0			3'o0
	`define R1			3'o1
	`define RSP			3'o7
`endif
