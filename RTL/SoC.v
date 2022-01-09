module SoC (
	input wire clk,    // 时钟输入
	input wire rst,  // 同步复位，高电平有效
	input wire [15:0]gpio_in,//输入端口
	output wire [15:0]gpio_out//输出端口
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
	.d_dout (d_dout)
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
	.gpio_out (gpio_out)
);
ibus #(
	.ROM_AW(ROM_AW)
) u_ibus (
	.clk(clk), 
	.addr(i_addr), 
	.dout(i_dout)
);

endmodule