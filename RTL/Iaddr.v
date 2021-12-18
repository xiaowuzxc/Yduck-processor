// -----------------------------------------------------------------------------
// 储存器建模，在FPGA上会综合成BRAM
// 指令存储器，只读
// -----------------------------------------------------------------------------
// Copyright (c) 2014-2021 All rights reserved
// -----------------------------------------------------------------------------
// Author : xiaowuzxc
// File   : Iaddr.v
// Create : 2021-12-10 20:13:36
// Revise : 2021-12-10 20:13:36
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module Iaddr 
#(
	parameter DW = 8,
	parameter AW = 16
)(
	input			clk, //时钟
	input [DW-1:0]	din, //数据输入
	input [AW-1:0]	addr, //地址输入
	input			we, //高电平写使能
	output [DW-1:0] dout //数据输出
    );
    
reg [DW-1:0] mem_r [(2**AW)-1:0];//内存定义

wire [DW-1:0] dout_pre;
reg [AW-1:0] addr_r;//地址寄存器


always @(posedge clk) begin
		addr_r <= addr;//读行为同步
end

assign dout_pre = mem_r[addr_r];//读取
assign dout = dout_pre;
initial begin
    $readmemb("C:/Users/wu/Desktop/read.txt",mem_r,0,(2**AW)-1);//可以被综合
end

endmodule