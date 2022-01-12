#tb文件
tb_file_0=tb_soc.sv
tb_file_1=tb_dbus.sv
tb_file_2=tb_ibus.sv
tb_file_3=tb_YD_reg.sv
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
	@echo shell input: make [cmd] 
	@echo to choice what you want.
	@echo ------------------------------
	@echo Such as:make 1
	@echo You can sim the D bus 
	@echo ------------------------------
	@echo [cmd]: information
	@echo s0: sim Soc
	@echo s1: sim D bus
	@echo s2: sim I bus
	@echo s3: sim interal regs
	@echo clean: clean tb file
	@echo ------------------------------
#-------------------------------------------------------------------------------------------------------
s0: iver0 show
s1: iver1 show
s2: iver2 show
s3: iver3 show
#-------------------------------------------------------------------------------------------------------
iver0:
	iverilog $(v_ver) -o $(tb_obj) -y $(v_path) $(tb_file_0)
iver1:
	iverilog $(v_ver) -o $(tb_obj) -y $(v_path) $(tb_file_1)
iver2:
	iverilog $(v_ver) -o $(tb_obj) -y $(v_path) $(tb_file_2)
iver3:
	iverilog $(v_ver) -o $(tb_obj) -y $(v_path) $(tb_file_3)
#-------------------------------------------------------------------------------------------------------
show:
	vvp -n $(tb_obj) -lxt2
	gtkwave $(tb_obj).lxt
#-------------------------------------------------------------------------------------------------------
.PHONY : clean
clean  :
	 rm  -rf  $(tb_obj) *.lxt
#-------------------------------------------------------------------------------------------------------