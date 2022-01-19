`timescale 1ns/100ps
module tb_dbus(); /* this is automatically generated */
parameter DW=16;
parameter AW=16;

logic clk,rst;//高电平同步复位
logic [DW-1:0]din;
logic [DW-1:0]dout;
logic [AW-1:0]addr;
logic we;
logic [DW-1:0]gpio_in;
logic [DW-1:0]gpio_out;
logic T0_PWM_N;
logic T0_PWM_P;
logic T1_PWM_N;
logic T1_PWM_P;

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
	din <= 0;
	addr <= 0;
	we <= 0;
	gpio_in <= 0;
	#2;
	rst <= ~rstb;
	#2;
end
endtask : sysrst

//写入数据
task write_d;
	input [AW-1:0]w_addr;
	input [DW-1:0]w_data;
	begin
		we=1;
		addr=w_addr;
		din=w_data;
		@(posedge clk)
		#0.1;
	end
endtask : write_d
//读取数据
task read_d;
	input [AW-1:0]r_addr;
	begin
		we=0;
		addr=r_addr;
		@(posedge clk);
		#0.1;
	end
endtask : read_d

//启动测试
initial begin
	sysrst(1);//复位系统
	#1;
	gpio_in<=16'h1A;
	#1;
	write_d(16'h0,16'h30);
	write_d(16'h1,16'h31);
	read_d(16'h1);
	read_d(16'h0);
	write_d(16'h2,16'h32);
	read_d(16'h2);
	#4;
	read_d(16'h1000);//读IO
	write_d(16'h1001,16'h3C);//写IO
	read_d(16'h1);
	//写tpwm
	write_d(16'h2001,16'h1);//DIV=1
	write_d(16'h2002,16'h6);//T0溢出值6
	write_d(16'h2003,16'h4);//T0比较值4
	write_d(16'h2005,16'h7);//T1溢出值7
	write_d(16'h2006,16'h2);//T1比较值2
	write_d(16'h2000,16'h0301);//启动
	$display("|--------Yduck dbus pass---------|");

	#200;
	$finish;
end

//例化数据总线
dbus #(
		.RAM_AW(7)
	) test (
		.clk      (clk),
		.rst      (rst),
		.din      (din),
		.addr     (addr),
		.we       (we),
		.dout     (dout),
		.gpio_in  (gpio_in),
		.gpio_out (gpio_out),
		.T0_PWM_P (T0_PWM_P),
		.T0_PWM_N (T0_PWM_N),
		.T1_PWM_P (T1_PWM_P),
		.T1_PWM_N (T1_PWM_N)
	);

// 输出波形
initial begin
	$dumpfile("tb.lxt");  //生成lxt的文件名称
	$dumpvars(0, test);   //tb中实例化的仿真目标实例名称
end

endmodule
