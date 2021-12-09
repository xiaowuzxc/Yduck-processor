# 大黄鸭处理器

### 介绍
自制大黄鸭指令集，8/16位指令集，16条指令

### 指令集结构
8/16位指令    
对指令空间同时读或写、对同一个寄存器写指令互斥。    

##### 8位指令
[7:4]指令[3:0]寄存器1  
加载  
存储  
逻辑非  
寄存器+1   
寄存器高低字节交换   

##### 16位指令
[15:12]指令[11:8]寄存器1[7:0]参数  
加法  
减法  
非0跳转  
无条件跳转  
逻辑左移  
逻辑右移  
循环左移  
[15:12]指令[11:8]寄存器1[7:4]寄存器2[3:0]X  
寄存器转移  
比较  
逻辑与  
逻辑或  


### 寄存器结构
|编号|标识符|功能|
|----|----|----|
|1|z|s|
Z零寄存器  
PC程序计数器  
SP堆栈指针  
D运算寄存器  
Y状态寄存器，只读  
D0~D12通用寄存器  

### 处理器实现
16位处理器单元，16位地址线，16位数据位宽，16个寄存器。  
哈佛结构，指令地址与数据地址分离。  
IO寄存器映射实现。  
双发射，两条8位指令可并行执行。  