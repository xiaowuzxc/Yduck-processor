module YD_reg (
	input wire clk,  //时钟
	input wire rst,  //高电平同步复位
	input wire jpc,	//流水线气泡，高电平可写PC
//输入口0
	input wire [15:0]din0,
	input wire [3:0]waddr0,
	input wire we0,
//输入口1
	input wire [15:0]din1,
	input wire [3:0]waddr1,
	input wire we1,
//输出口0
	input wire [3:0]raddr0,
	output reg [15:0]dout0,//寄存器读取，数据输出线，always@(*)只能给reg赋值
//输出口1
	input wire [3:0]raddr1,
	output reg [15:0]dout1,//寄存器读取，数据输出线，always@(*)只能给reg赋值
//PC输出
	output reg [15:0]PC//PC值会直接输出
);
//寄存器组定义
reg [15:0]RX[12:0];
reg [15:0]DK;
//内部必要连线
reg [3:0]raddr0_r;//读地址0打一拍
reg [3:0]raddr1_r;//读地址1打一拍
reg [3:0]waddr0_r;//写地址0打一拍
reg [3:0]waddr1_r;//写地址1打一拍
reg [15:0]din0_r;//写数据0打一拍
reg [15:0]din1_r;//写数据1打一拍
reg [15:0]dout0_r;//寄存器读取，数据输出线，always@(*)只能给reg赋值
reg [15:0]dout1_r;//
//定义寄存器组地址
localparam ZEA=4'b0000;
localparam DKA=4'b0001;
localparam R0A=4'b0010;
//R0-RC依次排列
localparam PCA=4'b1111;

//寄存器写入
always @(posedge clk) begin
if(rst) begin//寄存器复位
	DK <= 16'h0;
	PC <= 16'h0;
	RX[0] <= 16'h0;
	RX[1] <= 16'h0;
	RX[2] <= 16'h0;
	RX[3] <= 16'h0;
	RX[4] <= 16'h0;
	RX[5] <= 16'h0;
	RX[6] <= 16'h0;
	RX[7] <= 16'h0;
	RX[8] <= 16'h0;
	RX[9] <= 16'h0;
	RX[10] <= 16'h0;
	RX[11] <= 16'h0;
	RX[12] <= 16'h0;
	end 
else begin
	if(~jpc)//不跳转
		PC <= PC+16'h1;
	if(we0&&we1&&(waddr0==waddr1)) begin//写地址冲突，优先写端口0
		case(waddr0)
			ZEA:;//ZE永远为0
			DKA:DK <= din0;
			PCA:if(jpc) PC <= din0;//即将跳转
			default:RX[waddr0-R0A] <= din0;
			endcase 
		end
	else begin//无冲突，正常写
		if(we0) begin//端口0写
			case(waddr0)
				ZEA:;
				DKA:DK <= din0;
				PCA:if(jpc) PC <= din0;//即将跳转
				default:RX[waddr0-R0A] <= din0;
				endcase 
			end
		if(we1) begin//端口1写
			case(waddr1)
				ZEA:;
				DKA:DK <= din1;
				PCA:if(jpc) PC <= din1;//即将跳转
				default:RX[waddr1-R0A] <= din1;
				endcase 
			end
		end
	end
end

//寄存器读取
//读地址打一拍
always @(posedge clk) begin
if(rst) begin
	raddr0_r <= 4'h0;
	raddr1_r <= 4'h0;
	waddr0_r <= 4'h0;
	waddr1_r <= 4'h0;
	din0_r <= 16'h0;
	din1_r <= 16'h0;
	end 
else begin
	raddr0_r <= raddr0;//读地址0打一拍
	raddr1_r <= raddr1;//读地址1打一拍
	waddr0_r <= waddr0;//写地址0打一拍
	waddr1_r <= waddr1;//写地址1打一拍
	din0_r <= din0;//写数据0打一拍
	din1_r <= din1;//写数据1打一拍
	end
end
//读取寄存器
always @(*) begin
	case (raddr0_r)
		ZEA:dout0_r=16'h0;
		DKA:dout0_r=DK;
		PCA:
			if (((raddr0_r==waddr0_r&&we0)||(raddr0_r==waddr1_r&&we1))&&jpc) //同步写穿
				if(raddr0_r==waddr0_r&&we0)
					dout0_r=din0_r;
				else if(raddr0_r==waddr1_r&&we1)
					dout0_r=din1_r;
				else
					dout0_r=PC;
			else
				dout0_r=PC;
		default:
			if ((raddr0_r==waddr0_r&&we0)||(raddr0_r==waddr1_r&&we1))//同步写穿
				if(raddr0_r==waddr0_r&&we0)
					dout0_r=din0_r;
				else if(raddr0_r==waddr1_r&&we1)
					dout0_r=din1_r;
				else
					dout0_r=RX[raddr0_r-R0A];
			else
				dout0_r=RX[raddr0_r-R0A];
		endcase
	case (raddr1_r)
		ZEA:dout1_r=16'h0;
		DKA:dout1_r=DK;
		PCA:
			if (((raddr1_r==waddr0_r&&we0)||(raddr1_r==waddr1_r&&we1))&&jpc) //同步写穿
				if(raddr1_r==waddr0_r&&we0)
					dout1_r=din0_r;
				else if(raddr1_r==waddr1_r&&we1)
					dout1_r=din1_r;
				else
					dout1_r=PC;
			else
				dout1_r=PC;
		default:
			if ((raddr1_r==waddr0_r&&we0)||(raddr1_r==waddr1_r&&we1))//同步写穿
				if(raddr1_r==waddr0_r&&we0)
					dout1_r=din0_r;
				else if(raddr1_r==waddr1_r&&we1)
					dout1_r=din1_r;
				else
					dout1_r=RX[raddr1_r-R0A];
			else
				dout1_r=RX[raddr1_r-R0A];
		endcase
end

//DK异步写穿逻辑
always @(*) begin
	if(raddr0==DKA)//读取DK
		if(waddr0==DKA && we0)//如果同时在写DK
			dout0=din0;//把写的内容接过来
		else if(waddr1==DKA && we1)
			dout0=din1;
		else
			dout0=dout0_r;
	else//读的不是DK
		dout0=dout0_r;
	if(raddr1==DKA)
		if(waddr0==DKA && we0)
			dout1=din0;
		else if(waddr1==DKA && we1)
			dout1=din1;
		else
			dout1=dout1_r;
	else
		dout1=dout1_r;
end

endmodule