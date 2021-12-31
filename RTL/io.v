module io
#(
	parameter DW = 16,
	parameter AW = 13 
)(
	input			clk, //时钟
	input 			rst,  //同步复位，高电平有效
	input [DW-1:0]	din, //数据输入
	input [AW-1:0]	addr, //地址输入
	input			we, //高电平写使能
	output reg[DW-1:0] dout, //数据输出
	input wire [DW-1:0]gpio_in,//输入端口
	output wire [DW-1:0]gpio_out//输出端口
);

localparam GPI_A = 13'h00;
localparam GPO_A = 13'h01;
reg [DW-1:0]gpio_in_reg;
reg [DW-1:0]gpio_out_reg;
always @(posedge clk) begin
	gpio_in_reg <= gpio_in;
end
assign gpio_out=gpio_out_reg;

always @(posedge clk) begin
	if(we)
		case (addr)
			GPO_A: #0.1 gpio_out_reg <= din;
			default: ;
		endcase
	else
		case (addr)
			GPI_A: #0.1 dout <= gpio_in_reg;
			default: ;
		endcase

end

endmodule