#tb文件
tb_file_0=tb_soc.sv
tb_file_1=tb_dbus.sv
tb_file_2=tb_ibus.sv
tb_file_3=tb_YD_reg.sv
tb_file_4=tb_YD_int.sv
#编译输出文件
tb_obj=tb
#verilog语法版本
v_ver=-g2005-sv
#RTL文件所在相对路径
v_path=..
#-------------------------------------------------------------------------------------------------------
list:
	@echo ------------------------------
	@echo It is a UserGuide.
	@echo Must have iverilog and gtkwave
	@echo ------------------------------
	@echo input : make [cmd] 
	@echo to choice what you want.
	@echo ------------------------------
	@echo Such as:make 1
	@echo You can sim D bus 
	@echo ------------------------------
	@echo [cmd]: information
	@echo 0: sim Soc
	@echo 1: sim D bus
	@echo 2: sim I bus
	@echo 3: sim interal regs
	@echo 4: sim interrupt controller
	@echo c: clean tb file
	@echo ------------------------------
#-------------------------------------------------------------------------------------------------------
.PHONY:0
0: iver0 show
.PHONY:1
1: iver1 show
.PHONY:2
2: iver2 show
.PHONY:3
3: iver3 show
.PHONY:4
4: iver4 show
#-------------------------------------------------------------------------------------------------------
iver0:
	iverilog $(v_ver) -o $(tb_obj) -y $(v_path) $(tb_file_0)
iver1:
	iverilog $(v_ver) -o $(tb_obj) -y $(v_path) $(tb_file_1)
iver2:
	iverilog $(v_ver) -o $(tb_obj) -y $(v_path) $(tb_file_2)
iver3:
	iverilog $(v_ver) -o $(tb_obj) -y $(v_path) $(tb_file_3)
iver4:
	iverilog $(v_ver) -o $(tb_obj) -y $(v_path) $(tb_file_4)
#-------------------------------------------------------------------------------------------------------
show:
	vvp -n $(tb_obj) -lxt2
	gtkwave $(tb_obj).lxt
#-------------------------------------------------------------------------------------------------------
.PHONY : c
c  :
	 rm  -rf  $(tb_obj) *.lxt
#-------------------------------------------------------------------------------------------------------