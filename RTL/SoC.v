module SoC (
	input wire clk,    // 时钟输入
	input wire rst,  // 同步复位，高电平有效
	//IO
	input wire [15:0]gpio_in,//输入端口
	output wire [15:0]gpio_out,//输出端口
	//PWM
	output reg T0_PWM_P,//T0_PWM_P
	output reg T0_PWM_N,//T0_PWM_N
	output reg T1_PWM_P,//T1_PWM_P
	output reg T1_PWM_N,//T1_PWM_N
	//中断
	input 	wire int_vld, //中断脉冲输入，1周期高脉冲表示中断发生
	output 	wire int_rdy //数据输出，高电平可以接受中断，低电平无法响应
);
parameter RAM_AW=7;
parameter ROM_AW=7;

//
wire [15:0]i_addr,i_dout,d_din,d_addr,d_dout;
wire d_we;

YD_core u_YD_core
(
	.clk    (clk),
	.rst    (rst),
	.i_addr (i_addr),
	.i_dout (i_dout),
	.d_din  (d_din),
	.d_addr (d_addr),
	.d_we   (d_we),
	.d_dout (d_dout),
	.int_vld(int_vld),
	.int_rdy(int_rdy)
);
dbus #(
	.RAM_AW(RAM_AW)
) u_dbus (
	.clk      (clk),
	.rst      (rst),
	.din      (d_din),
	.addr     (d_addr),
	.we       (d_we),
	.dout     (d_dout),
	.gpio_in  (gpio_in),
	.gpio_out (gpio_out),
	.T0_PWM_P(T0_PWM_P),//T0_PWM_P
	.T0_PWM_N(T0_PWM_N),//T0_PWM_N
	.T1_PWM_P(T1_PWM_P),//T1_PWM_P
	.T1_PWM_N(T1_PWM_N)//T1_PWM_N
);
ibus #(
	.ROM_AW(ROM_AW)
) u_ibus (
	.clk(clk), 
	.addr(i_addr), 
	.dout(i_dout)
);

endmodule