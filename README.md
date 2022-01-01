# 大黄鸭处理器  

### 简介
本项目将从零开始，设计一套单核16位处理器。为此，我将自己设计一套全新的计算机指令集，代号“大黄鸭”；根据大黄鸭指令集，设计处理器内核，实现指令集的所有功能；为处理器布置必要的外设，如IO口；设计汇编器，让程序编写变得更友好。

#### 本项目包含以下内容：  
**1. 大黄鸭指令集设计**  
- 全新设计的大黄鸭指令集
- 加载存储结构
- 16条指令，8/16位长度，16个寄存器，16b数据/地址位宽， 
**2. 大黄鸭处理器设计**  
- 哈佛结构
- 两级流水线，所有指令单周期执行
- 8b指令双发射
- 带有数据总线
- IO寄存器映射。  
**3. 大黄鸭汇编器脚本**  
- 将符合大黄鸭指令集的汇编程序转换为二进制代码
- 容许#开头的单行注释
- 语法检查
- 立即数溢出检查

#### 杂谈:我为什么要做大黄鸭
本项目开坑没有什么特殊原因~~纯属脑子一热~~。开坑前，我正沉迷于学习FPGA和计算机体系结构，研究各种指令集(RISC-V,MIPS,8051...)，使用各种嵌入式处理器，移植tinyriscv,e203等各种开源处理器，甚至去看了看古董(~~川口三~~6205,经典8051)。

看了各种各样指令集架构，它们都有让我喜欢和感到变扭的地方，RISC-V简洁但有些操作不方便，51虽古老但有很多闪光点，等等。千奇百怪的处理器，我越看越入迷，越看越有灵感，同时，心中也不可抑制地产生了一种想法，那就是，我能不能自己设计一套指令集？

原本我觉得这想法很可笑，如同蚂蚁想要推到大树一般自大而无畏。但是，我又觉得，或许可以尝试一下。不需要这个指令集有多么优秀，能够拳打ARM脚踢RV，只要合我心意，满足最基本的顺序、选择、循环结构，可以使用汇编编写指令，对我来说，那就足够了。

我有个习惯，那就是从来不打没准备的仗。热血上头的那天晚上，横竖睡不着觉，脑子里不停构思指令集怎么设计，16位一条指令怎么分配，用哈佛还是冯诺依曼。慢慢的思考，大黄鸭指令集就如拨云见日，从模模糊糊到清晰可见。把脑子里构思的指令集一条一条写下来，我觉得我能看到希望了；根据指令集在脑子里切出个2级流水线，我觉得可以动手了；翻了翻verilog手册和计算机体系结构，我充满了信心。于是，开坑！！！  
  
### 设计进度
- 指令集
    - 指令码 [完成]
    - 寄存器 [完成]
    - 指令格式 [完成]
- 处理器
    - 内核 [x]
    - 指令总线 [完成]
    - 数据总线
        - SRAM [完成]
        - 简单IO [完成]
        - 其他 [x]
- 汇编器
    - 语法检查
        - 非法字符 [完成]
        - 错误格式 [完成]
        - 警告内容 [x]
    - 位宽检查 [完成]
    - 指令转换 [完成]
    - 伪指令扩展 [x]
### 指令集结构
8/16位指令    
对指令空间同时读或写、对同一个寄存器写指令互斥。    

#### 8位指令
##### [7:4]指令[3:0]寄存器1  
1. 加载  
- 从[寄存器1]指向的地址读出一个数，存入[DK]
2. 存储  
- 把[DK]的值写入[寄存器1]指向的地址
3. 逻辑非  
- [寄存器1]的值取反
4. 寄存器+1   
- [寄存器1]的值+1
5. 寄存器高低字节交换   
- [寄存器1]的高低字节交换

#### 16位指令
具体见16指令表.xlsx  
##### [15:12]指令[11:8]寄存器1[7:0]立即数  
1. 加法  
- DK=DK+[寄存器1]+[立即数]  
2. 减法  
- DK=DK-[寄存器1]-[立即数]  
3. 非0跳转  
- DK!=0，跳转到[寄存器1]+[立即数]  
4. 无条件跳转  
- 跳转到[寄存器1]+[立即数]  
5. 逻辑左移  
- DK逻辑左移[寄存器1]+[立即数]，低位补0  
6. 逻辑右移  
- DK逻辑右移[寄存器1]+[立即数]，高位补0  
7. 循环左移  
- DK循环左移[寄存器1]+[立即数]  
##### [15:12]指令[11:8]寄存器1[7:4]寄存器2[3:0]X  
1. 寄存器转移  
- [寄存器1]的值写入[寄存器2]  
2. 比较  
- [寄存器1]>[寄存器2]，DK写入1  
3. 逻辑与  
- [寄存器1]与[寄存器2]与运算，结果写入DK  
4. 逻辑或  
- [寄存器1]与[寄存器2]或运算，结果写入DK  

### 寄存器结构
具体见16寄存器组.xlsx  
|编号|标识符|功能|
|----|----|----|
|0|ZE|零寄存器|
|1|DK|运算寄存器|
|2-C|R0-RC|通用寄存器|
|F|PC|程序计数器|


### 处理器实现
16位处理器单元，16位地址线，16位数据位宽，16个寄存器。  
指令、数据空间必须且只能2字节对齐。  
哈佛结构，指令地址与数据地址分离。  
IO寄存器映射实现。  
双发射，两条8位指令可并行执行。  
2级流水线，发生跳转则使用空指令填充流水线。