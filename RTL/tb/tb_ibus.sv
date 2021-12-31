`timescale 1ns/100ps
module tb_ibus(); /* this is automatically generated */

parameter DW=16;
parameter AW=16;

logic clk,rst;//高电平同步复位
logic [DW-1:0]dout;
logic [AW-1:0]addr;

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
	addr <= 0;
	#2;
	rst <= ~rstb;
	#2;
end
endtask : sysrst


//读取数据
task read_d;
	input [AW-1:0]r_addr;
	begin
		addr=r_addr;
		@(posedge clk);
		#0.1;
	end
endtask : read_d

//启动测试
initial begin
	sysrst(1);//复位系统
	#1;
	read_d(16'h0);
	read_d(16'h1);
	read_d(16'h2);
	read_d(16'h3);
	read_d(16'h0);
	read_d(16'h1);
	#4;
	read_d(16'h1);
	$display("|--------Yduck dbus pass---------|");
	#10
	$finish;
end

//例化指令总线
ibus #(
	.DW     		( 16 		),
	.AW     		( 16 		),
	.RAM_AW 		( 7  		))
	test (
	//ports
	.clk  		( clk  		),
	.addr 		( addr 		),
	.dout 		( dout 		)
);

// 输出波形
initial begin
	$dumpfile("tb.lxt");  //生成lxt的文件名称
	$dumpvars(0, test);   //tb中实例化的仿真目标实例名称
end

endmodule
