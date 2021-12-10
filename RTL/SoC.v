module SoC (
	input wire clk,    // 时钟输入
	input wire rst_n,  // 低电平异步复位，同步释放
	input wire [15:0]gpio_in,//输入端口
	output wire [15:0]gpio_out//输出端口
);

endmodule