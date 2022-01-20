`timescale 1ns/100ps
module tb_soc(); /* this is automatically generated */

parameter DW=16;
parameter RAM_AW=7;
parameter ROM_AW=7;


logic clk,rst;//高电平同步复位
logic [DW-1:0]gpio_in,gpio_out;
logic int_vld;//中断脉冲，1周期高脉冲表示中断发生
logic int_rdy; //输出，高电平可以接受中断，低电平无法响应
logic T0_PWM_P;//T0_PWM_P
logic T0_PWM_N;//T0_PWM_N
logic T1_PWM_P;//T1_PWM_P
logic T1_PWM_N;//T1_PWM_N
// clk
initial begin
	clk = '0;
	forever #(0.5) clk = ~clk;
end

//sysrst()复位
task sysrst;//复位任务
	input rstb;
begin
	rst <= rstb;
	gpio_in <= 0;
	int_vld <= 0;
	#2.5;
	rst <= ~rstb;
	#2;
end
endtask : sysrst


//启动测试
initial begin
	sysrst(1);//复位系统
	#1;
	gpio_in=16'hFA1C;
	#50
	@(posedge clk);
	int_vld <= 1;//中断
	@(posedge clk);
	int_vld <= 0;
	#10;
	$display("|-----------Yduck pass------------|");
	$finish;
end

SoC #(
		.RAM_AW(RAM_AW),
		.ROM_AW(ROM_AW)
	) test (
		.clk      (clk),
		.rst      (rst),
		.gpio_in  (gpio_in),
		.gpio_out (gpio_out),
		.int_vld(int_vld),
		.int_rdy(int_rdy),
		.T0_PWM_P(T0_PWM_P),
		.T0_PWM_N(T0_PWM_N),
		.T1_PWM_P(T1_PWM_P),
		.T1_PWM_N(T1_PWM_N)
	);

// 输出波形
initial begin
	$dumpfile("tb.lxt");  //生成lxt的文件名称
	$dumpvars(0, tb_soc);   //tb中实例化的仿真目标实例名称
end

endmodule
