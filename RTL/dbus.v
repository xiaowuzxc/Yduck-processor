// -----------------------------------------------------------------------------
// 储存器建模，在FPGA上会综合成BRAM
//
// -----------------------------------------------------------------------------
// Copyright (c) 2014-2021 All rights reserved
// -----------------------------------------------------------------------------
// Author : xiaowuzxc
// File   : dbus.v
// Create : 2021-12-10 20:22:39
// Revise : 2021-12-10 20:22:39
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
module dbus
#(
	parameter RAM_AW = 7
)(
	input			clk, //时钟
	input			rst,  //同步复位，高电平有效
	input [DW-1:0]	din, //数据输入
	input [AW-1:0]	addr, //地址输入
	input			we, //高电平写使能
	output reg [DW-1:0]	dout, //数据输出
	input wire [DW-1:0]	gpio_in,//输入端口
	output wire [DW-1:0]gpio_out//输出端口
);
localparam BKAW=13;
localparam DW = 16;
localparam AW = 16;
/*---------定义区块连线-----------*/
//s0
localparam s0_bk=0;//区块编号，s<num>_bk=<num>
wire [DW-1:0]s0_dout;//从->主数据通路
reg  [DW-1:0]s0_din;//主->从数据通路
reg  [AW-4:0]s0_addr;//地址通路
reg  s0_we;//高电平写使能
//s1
localparam s1_bk=1;
wire [DW-1:0]s1_dout;
reg  [DW-1:0]s1_din;
reg  [AW-4:0]s1_addr;
reg  s1_we;
/*---------定义区块连线-----------*/

/*---------主->从数据通路-----------*/
reg [DW-1:0]dinz;//空闲通路
reg [AW-4:0]addrz;//空闲通路
reg wez;//空闲通路
always @(*) begin
	case(addr[AW-1:AW-3])
		s0_bk:begin
			s0_din=din;//主->从数据通路
			s0_addr=addr[AW-4:0];//地址通路
			s0_we=we;//高电平写使能
			end
		s1_bk:begin
			s1_din=din;
			s1_addr=addr[AW-4:0];
			s1_we=we;
			end
		default:begin
			dinz=din;
			addrz=addr[AW-4:0];
			wez=we;
			end
	endcase
end
/*---------主->从数据通路-----------*/

/*---------从->主数据通路-----------*/
reg [2:0]bkr;//区块选择寄存器
always @(posedge clk ) begin
	if(rst)
		bkr<=3'b0;
	else
		bkr <= addr[AW-1:AW-3];
end
always @(*) begin
	case(bkr)
		s0_bk:dout=s0_dout;
		s1_bk:dout=s1_dout;
		default:dout=32'h0;
	endcase
end
/*---------从->主数据通路-----------*/


ram #(

	.DW     		( 16 		),
	.AW     		( BKAW		),
	.RAM_AW 		( RAM_AW 	))
u_ram(
	//ports
	.clk  		( clk  		),
	.rst  		( rst  		),
	.din  		( s0_din  		),
	.addr 		( s0_addr 		),
	.we   		( s0_we   		),
	.dout 		(s0_dout	)
);

io #(
	.DW 		( 16 		),
	.AW 		( BKAW		))
u_io(
	//ports
	.clk      		( clk      		),
	.rst      		( rst      		),
	.din      		( s1_din      		),
	.addr     		( s1_addr     		),
	.we       		( s1_we       		),
	.dout     		( s1_dout     		),
	.gpio_in  		( gpio_in  		),
	.gpio_out 		( gpio_out 		)
);




endmodule