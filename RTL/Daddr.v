// -----------------------------------------------------------------------------
// 储存器建模，在FPGA上会综合成BRAM
//
// -----------------------------------------------------------------------------
// Copyright (c) 2014-2021 All rights reserved
// -----------------------------------------------------------------------------
// Author : xiaowuzxc
// File   : Daddr.v
// Create : 2021-12-10 20:22:39
// Revise : 2021-12-10 20:22:39
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module Iaddr 
#(
	parameter DP = 1024,
	parameter DW = 16,
	parameter AW = 16 
)(
	input			clk, //时钟
	input [DW-1:0]	din, //数据输入
	input [AW-1:0]	addr, //地址输入
	input			we, //高电平写使能
	output [DW-1:0] dout, //数据输出
	input wire [DW-1:0]gpio_in,//输入端口
	output wire [DW-1:0]gpio_out//输出端口
);

localparam GPI_A = 16'h100;
localparam GPO_A = 16'h101;
reg [DW-1:0]gpio_in_reg;
reg [DW-1:0]gpio_out_reg;
always @(posedge clk) begin
	gpio_in_reg <= gpio_in;
end
assign gpio_out=gpio_out_reg;

reg [DW-1:0] mem_r [0:DP-1];//内存定义

always @(posedge clk) begin
	if(we)
		case (addr)
			GPO_A:gpio_out_reg <= din;
			default :mem_r[addr] <= din;//写入
		endcase
		
end

wire ren;
reg [DW-1:0] dout_pre;
reg [AW-1:0] addr_r;//地址寄存器
assign ren = ~we;

always @(posedge clk) begin
	if (ren)
		addr_r <= addr;//读行为同步
end
always @(*) begin
	case (addr_r)
		GPI_A:dout_pre = gpio_in_reg;
		GPO_A:dout_pre = gpio_out_reg;
		default : dout_pre = mem_r[addr_r];
	endcase
end
assign dout = dout_pre;

endmodule