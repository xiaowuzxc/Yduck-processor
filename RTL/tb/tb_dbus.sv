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
		@(posedge clk);
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
	read_d(16'h2000);
	write_d(16'h2001,16'h3C);
	read_d(16'h1);
	$display("|--------Yduck dbus pass---------|");

	#10
	$finish;
end

//例化数据总线
dbus #(
		.DW(16),
		.AW(16)
	) test (
		.clk      (clk),
		.rst      (rst),
		.din      (din),
		.addr     (addr),
		.we       (we),
		.dout     (dout),
		.gpio_in  (gpio_in),
		.gpio_out (gpio_out)
	);

// 输出波形
initial begin
	$dumpfile("tb.lxt");  //生成lxt的文件名称
	$dumpvars(0, test);   //tb中实例化的仿真目标实例名称
end

endmodule
