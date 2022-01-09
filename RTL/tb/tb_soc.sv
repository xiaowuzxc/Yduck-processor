`timescale 1ns/100ps
module tb_soc(); /* this is automatically generated */

parameter DW=16;
parameter RAM_AW=7;
parameter ROM_AW=7;


logic clk,rst;//高电平同步复位
logic [DW-1:0]gpio_in,gpio_out;


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

	
	#10
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
		.gpio_out (gpio_out)
	);

// 输出波形
initial begin
	$dumpfile("tb.lxt");  //生成lxt的文件名称
	$dumpvars(0, test);   //tb中实例化的仿真目标实例名称
end

endmodule
