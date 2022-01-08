module YD_core
#(
	parameter DW = 16,
	parameter AW = 16 
)(
	input				clk, //时钟
	input				rst,  //同步复位，高电平有效
	//ibus
	output 	[AW-1:0]	i_addr, //地址输入
	input 	[DW-1:0]	i_dout, //数据输出
	//dbus
	output	reg[DW-1:0]	d_din, //数据输入
	output 	reg[AW-1:0]	d_addr, //地址输入
	output	reg 		d_we, //高电平写使能
	input 	[DW-1:0]	d_dout //数据输出
);
//寄存器定义
reg jpc;//跳转指示
reg dwi;//数据空间写指示
reg dsw;//双发射1级指示
reg dsw_r;//双发射2级指示
reg [DW-1:0]idata;//第一阶段指令
reg [DW-1:0]idata_r;//指令寄存
reg [15:0]din0;
reg [3:0]waddr0;
reg we0;
reg [15:0]din1;
reg [3:0]waddr1;
reg we1;
reg [3:0]raddr0;
reg [3:0]raddr1;

//线网定义
wire [15:0]dout0;
wire [15:0]dout1;
//内部参数定义
localparam hze=16'h0;//发生跳转，填充流水线

//指令操作码定义
localparam NF=4'b0000;	//逻辑非	RG=~RG
localparam LD=4'b0001;	//加载	RG=[DK]
localparam SV=4'b0010;	//存储	[DK]=RG
localparam IN=4'b0011;	//寄存器+1	RG=RG+1
localparam SW=4'b0100;	//寄存器交换	RG={[7:0]RG,[15:8]RG}
localparam WR=4'b0101;	//寄存器转移	RG2=RG1
localparam CR=4'b0110;	//比较	DK=RG1>RG2 ? 1 : 0
localparam LA=4'b0111;	//逻辑与	DK=RG1&RG2
localparam LO=4'b1000;	//逻辑或	DK=RG1|RG2
localparam AD=4'b1001;	//加法	DK=DK+RG+$H
localparam SB=4'b1010;	//减法	DK=DK-RG-$H
localparam JW=4'b1011;	//非0跳转	DK!=0，则跳转到RG+$H
localparam JA=4'b1100;	//无条件跳转	跳转到RG+$H
localparam LL=4'b1101;	//逻辑左移	DK左移RG+$H次，低位补0
localparam LR=4'b1110;	//逻辑右移	DK右移RG+$H次，高位补0
localparam TL=4'b1111;	//循环左移	DK循环左移RG+$H

//定义寄存器组地址
localparam ZEA=4'b0000;
localparam DKA=4'b0001;
localparam R0A=4'b0010;
//R0-RC依次排列
localparam PCA=4'b1111;

//跳转则填充一次流水线
always @(*) begin
	if(jpc)
		idata=hze;
	else
		idata=i_dout;
end

//指令打一拍
always @(posedge clk) begin
	if(rst)
		idata_r <= 16'h0;
	else
		idata_r <= idata;
end
/*
output 	[AW-1:0]	d_addr, //地址输入

//输出口0
	input wire [3:0]raddr0,
	
//输出口1
	input wire [3:0]raddr1,
	
*/
//指令译码，生成读地址
always @(*) begin
	raddr0=4'h0;
	raddr1=4'h0;
	if(dwi) d_addr=16'hz;
	case (idata[15:12])
		NF:begin
			dsw=1'b1;//当前为8b指令
			raddr0=idata[11:8];
			end
		LD:begin
			dsw=1'b1;
			raddr0=DKA;
			if(dwi) 
				d_addr=16'hz;//数据空间正在写

			else
				d_addr=dout0;//数据空间没有动作
			end
		SV:begin
			dsw=1'b1;
			raddr0=idata[11:8];
			end
		IN:begin
			dsw=1'b1;
			raddr0=idata[11:8];
			end
		SW:begin
			dsw=1'b1;
			raddr0=idata[11:8];
			end
		WR:begin
			dsw=1'b0;//当前为16b指令
			raddr0=idata[11:8];
			end
		CR:begin
			dsw=1'b0;
			raddr0=idata[11:8];
			raddr1=idata[7:4];
			end
		LA:begin
			dsw=1'b0;
			raddr0=idata[11:8];
			raddr1=idata[7:4];
			end
		LO:begin
			dsw=1'b0;
			raddr0=idata[11:8];
			raddr1=idata[7:4];
			end
		AD:begin
			dsw=1'b0;
			raddr0=idata[11:8];
			end
		SB:begin
			dsw=1'b0;
			raddr0=idata[11:8];
			end
		JW:begin
			dsw=1'b0;
			raddr0=idata[11:8];
			end
		JA:begin
			dsw=1'b0;
			raddr0=idata[11:8];
			end
		LL:begin
			dsw=1'b0;
			raddr0=idata[11:8];
			end
		LR:begin
			dsw=1'b0;
			raddr0=idata[11:8];
			end
		TL:begin
			dsw=1'b0;
			raddr0=idata[11:8];
			end
	endcase
end
/*
output 	[DW-1:0]	d_din, //数据输入
output 	[AW-1:0]	d_addr, //地址输入
output				d_we, //高电平写使能
input [DW-1:0]	din, //数据输入

//输入口0
	input wire [15:0]din0,
	input wire [3:0]waddr0,
	input wire we0,

	output reg [15:0]dout1,//寄存器读取，数据输出线，always@(*)只能给reg赋值
//输入口1
	input wire [15:0]din1,
	input wire [3:0]waddr1,
	input wire we1,

	output reg [15:0]dout0,//寄存器读取，数据输出线，always@(*)只能给reg赋值
*/
//取得操作数值，生成写地址
always @(*) begin
	d_din=16'h0;
	if(~dwi) d_addr=16'h0;
	d_we=1'b0;
	din0=16'h0;
	waddr0=4'h0;
	we0=1'b0;
	din1=16'h0;
	waddr1=4'h0;
	we1=1'b0;
	case (idata_r[15:12])
		NF:begin
			dsw_r=1'b1;//当前为8b指令
			raddr0=idata[11:8];
			end
		LD:begin
			dsw_r=1'b1;
			raddr0=DKA;
			if(dwi) 
				d_addr=16'hz;//数据空间正在写

			else
				d_addr=dout0;//数据空间没有动作
			end
		SV:begin
			dsw_r=1'b1;
			raddr0=idata[11:8];
			end
		IN:begin
			dsw_r=1'b1;
			raddr0=idata[11:8];
			end
		SW:begin
			dsw_r=1'b1;
			raddr0=idata[11:8];
			end
		WR:begin
			dsw_r=1'b0;//当前为16b指令
			raddr0=idata[11:8];
			end
		CR:begin
			dsw_r=1'b0;
			raddr0=idata[11:8];
			raddr1=idata[7:4];
			end
		LA:begin
			dsw_r=1'b0;
			raddr0=idata[11:8];
			raddr1=idata[7:4];
			end
		LO:begin
			dsw_r=1'b0;
			raddr0=idata[11:8];
			raddr1=idata[7:4];
			end
		AD:begin
			dsw_r=1'b0;
			raddr0=idata[11:8];
			end
		SB:begin
			dsw_r=1'b0;
			raddr0=idata[11:8];
			end
		JW:begin
			dsw_r=1'b0;
			raddr0=idata[11:8];
			end
		JA:begin
			dsw_r=1'b0;
			raddr0=idata[11:8];
			end
		LL:begin
			dsw_r=1'b0;
			raddr0=idata[11:8];
			end
		LR:begin
			dsw_r=1'b0;
			raddr0=idata[11:8];
			end
		TL:begin
			dsw_r=1'b0;
			raddr0=idata[11:8];
			end
	endcase
end

//内部数据寄存
always @(posedge clk) begin
	if(rst) begin
		dwi <= 1'b0;
		jpc <= 1'b0;
		end 
	else begin
		if(idata[15:12]==JA || idata[15:12]==JW)
			jpc <= 1'b1;
		if(idata[15:12]==SV)
			dwi <= 1'b1;
		end
end

assign i_addr=PC;//地址指示
YD_reg u_YD_reg
	(
		.clk    (clk),
		.rst    (rst),
		.jpc    (jpc),
		.din0   (din0),
		.waddr0 (waddr0),
		.we0    (we0),
		.din1   (din1),
		.waddr1 (waddr1),
		.we1    (we1),
		.raddr0 (raddr0),
		.dout0  (dout0),
		.raddr1 (raddr1),
		.dout1  (dout1),
		.PC     (PC)
	);
endmodule