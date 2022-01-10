`timescale 1ns/100ps
module tb_YD_reg(); /* this is automatically generated */

parameter DW=16;
parameter AW=4;

logic clk,rst,jpc,we0,we1;//高电平同步复位
logic [DW-1:0]din0,din1,dout0,dout1;
logic [AW-1:0]waddr0,waddr1,raddr0,raddr1;
logic we;

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
	jpc <= 0;
	din0 <= 0;
	din1 <= 0;
	waddr0 <= 0;
	waddr1 <= 0;
	raddr1 <= 0;
	raddr0 <= 0;
	we0 <= 0;
	we1 <= 0;
	#2;
	rst <= ~rstb;
	#2;
end
endtask : sysrst

//写入数据0
task write_d0;
	input [AW-1:0]w_addr;
	input [DW-1:0]w_data;
	begin
		we0=1;
		waddr0=w_addr;
		din0=w_data;
	end
endtask : write_d0
//写入数据1
task write_d1;
	input [AW-1:0]w_addr;
	input [DW-1:0]w_data;
	begin
		we1=1;
		waddr1=w_addr;
		din1=w_data;
	end
endtask : write_d1
//读取数据0
task read_d0;
	input [AW-1:0]r_addr;
	begin
		raddr0=r_addr;
	end
endtask : read_d0
//读取数据1
task read_d1;
	input [AW-1:0]r_addr;
	begin
		raddr1=r_addr;
	end
endtask : read_d1
//等待上升沿
task ckpos();
	begin
		#0.1;
		@(posedge clk);
		#0.1;
		we0=0;
		we1=0;
	end
endtask : ckpos
//启动测试
initial begin
	sysrst(1);//复位系统
	#1;
	write_d0(4'h1,16'h31);
	write_d1(4'h2,16'h32);
	read_d0(4'h2);
	read_d1(4'h1);
	ckpos();
	write_d0(4'h3,16'hA1);
	write_d1(4'h4,16'hA2);
	read_d0(4'h3);
	read_d1(4'h1);
	ckpos();
	read_d0(4'hF);
	read_d1(4'h4);
	ckpos();
	write_d0(4'hF,16'h1FFF);
	read_d0(4'h0);
	read_d1(4'h3);
	ckpos();
	jpc=1;
	write_d0(4'hF,16'h1FFF);
	write_d1(4'h1,16'h100F);
	read_d0(4'hF);
	read_d1(4'h4);
	ckpos();
	jpc=0;
	#0.3;
	read_d0(4'h1);
	read_d1(4'h2);
	//$display("|--------Yduck regs pass---------|");

	#10
	$finish;
end

//例化数据总线
YD_reg test (
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
	.dout1  (dout1)
);


// 输出波形
initial begin
	$dumpfile("tb.lxt");  //生成lxt的文件名称
	$dumpvars(0, test);   //tb中实例化的仿真目标实例名称
end

endmodule
