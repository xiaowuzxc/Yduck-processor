module SoC (
	input wire clk,    // 时钟输入
	input wire rst,  // 同步复位，高电平有效
	input wire [15:0]gpio_in,//输入端口
	output wire [15:0]gpio_out//输出端口
);

endmodule