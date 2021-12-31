@chcp 65001
@echo 输入编号并回车，执行对应项目
@echo 1:执行数据总线仿真
@echo 2:执行指令总线仿真
@echo c:清理缓存文件
:cmsl
@set /p cmchc=输入命令编号：

@if %cmchc% == 0 (echo 命令0)^
else if %cmchc% == 1 (iverilog -g2005-sv -o tb -y .. tb_dbus.sv & echo 开始执行数据总线仿真)^
else if %cmchc% == 2 (iverilog -g2005-sv -o tb -y .. tb_ibus.sv & echo 开始执行指令总线仿真)^
else if %cmchc% == c (del tb *.lxt & @echo 缓存文件已清理 & goto cmsl)^
else (echo 命令未找到 & goto cmsl)


@echo 生成波形
vvp -n tb -lxt2
@echo 显示波形
gtkwave tb.lxt
goto cmsl
pause