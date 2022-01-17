module tpwm
#(
	parameter DW = 16,
	parameter AW = 13 
)(
	input			clk, //时钟
	input 			rst,  //同步复位，高电平有效
	input [DW-1:0]	din, //数据输入
	input [AW-1:0]	addr, //地址输入
	input			we, //高电平写使能
	output reg[DW-1:0] dout, //数据输出
	output wire T0_PWM_P,//输入端口
	output wire T0_PWM_N,//输入端口
	output wire T1_PWM_P,//输出端口
	output wire T1_PWM_N//输出端口
);
/*
定时PWM发生器T0/T1
---------------------------------------
向下计数模式
计数器下溢装入自动重装值
计数值大于比较值，Tx_PWM_P为初始极性
计数值越过比较值后，Tx_PWM发生翻转
Tx_PWM_P与Tx_PWM_N为差分信号
---------------------------------------
控制寄存器
低8位[7:0]控制T0，高8位[15:8]控制T1
[0]启动控制：置1开始计数，置0停止并复位
[1]极性控制：计数值大于比较值时，Tx_PWM_P=[1]
---------------------------------------
分频器：
                |->T0
    clk->|div|--|
                |->T1
系统时钟送入分配器，分配器输出作为T0/T1的时钟源。
分频器计算公式 Fdiv=(N+1)F
Fdiv：分配器输出频率
  N ：分频系数
  F ：系统时钟频率
---------------------------------------
影子寄存器
TDIV，TATSx，TCMPx有影子寄存器。
其作用是在分频器、定时器溢出时将设定值写入，防止计数器跑飞。
*/
//地址定义
localparam TCTR_A = 12'h00;//定时器控制寄存器
localparam TDIV_A = 12'h01;//定时器分频系数寄存器
localparam TATS0_A = 12'h02;//定时器0自动重装值寄存器
localparam TCMP0_A = 12'h03;//定时器0比较值寄存器
localparam TCNT0_A = 12'h04;//定时器0当前值
localparam TATS1_A = 12'h05;//定时器1自动重装值寄存器
localparam TCMP1_A = 12'h06;//定时器1比较值寄存器
localparam TCNT1_A = 12'h07;//定时器1当前值
//寄存器定义
reg[15:0]TCTR;
reg[15:0]TDIV;
reg[15:0]TDIV_r;//影子寄存器
reg[15:0]TATS0;
reg[15:0]TATS0_r;//影子寄存器
reg[15:0]TCMP0;
reg[15:0]TCMP0_r;//影子寄存器
reg[15:0]TCNT0;
reg[15:0]TATS1;
reg[15:0]TATS1_r;//影子寄存器
reg[15:0]TCMP1;
reg[15:0]TCMP1_r;//影子寄存器
reg[15:0]TCNT1;
reg DIV_EN;//分频器输出使能
reg [15:0]DIV_CNT;//分频器计数器

//分频器
always @(posedge clk) begin
	if(rst) begin
		DIV_CNT<=16'h0;
		TDIV_r<=16'h0;
		end
	else begin
		if(DIV_CNT==TDIV_r) begin
			DIV_EN<=1'b1;//输出使能信号
			DIV_CNT<=16'h0;
			if(TDIV_r!=TDIV)//写入影子寄存器
				TDIV_r<=TDIV;
			end
		else begin
			DIV_CNT<=DIV_CNT+1;//计数器+1
			DIV_EN<=1'b0;
			end
		end
end

always @(posedge clk) begin
if(rst) begin
	TCTR <= 16'h0;
	TDIV <= 16'h0;
	TATS0 <= 16'h0;
	TATS1 <= 16'h0;
	TCMP0 <= 16'h0;
	TCMP1 <= 16'h0;
	//TCNT0 <= 16'h0;
	//TCNT1 <= 16'h0;
	dout <= 16'h0;
end	
else
	if(we)
		case (addr)//数据总线写入
			TCTR_A: #0.1 TCTR <= din;
			default: ;
		endcase
	else
		case (addr)//数据总线读取
			TCTR_A: #0.1 dout <= TCTR;
			default: ;
		endcase
end
endmodule