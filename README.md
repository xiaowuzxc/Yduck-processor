# 大黄鸭处理器  

### 简介
本项目将从零开始，设计一套单核16位处理器。  
为此，我将设计一套全新的指令集，代号“大黄鸭”；根据大黄鸭指令集，设计处理器内核，实现指令集的所有功能；为处理器布置必要的外设，如IO口；编写汇编器，可以将助记符转换为机器码。  

#### 本项目包含以下内容：  
**1. 大黄鸭指令集设计**  
- RISC精简指令集设计理念
- 全新设计的大黄鸭指令集
- 加载存储结构
- 16条指令，8/16位指令长度，16个寄存器，16位数据/地址位宽  

**2. 大黄鸭处理器设计**  
- 全可综合的Verilog源码
- 哈佛结构
- 3级流水线，指令单周期执行(除SV)
- 8位指令双发射
- 非向量中断
- 带有数据总线
- IO寄存器映射
- 通用IO，定时PWM，中断管理外设

**3. 大黄鸭汇编器**  
- 将大黄鸭汇编程序转换为机器码
- 清除多余空格、行
- 容许#开头的单行注释
- 语法检查
- 立即数溢出检查
- 寄存器写入冲突检查
- [更强大的大黄鸭汇编器GUI版](https://gitee.com/xiaowuzxc/Yduck-Assembler-GUI)  

#### 处理器功能框图
![大黄鸭SoC结构](/pic/png/soc.png)  

#### 项目文档
详细文档位于`./doc`  
[大黄鸭指令集](https://gitee.com/xiaowuzxc/Yduck-processor/blob/master/doc/%E5%A4%A7%E9%BB%84%E9%B8%AD%E6%8C%87%E4%BB%A4%E9%9B%86.md)  
[系统结构](https://gitee.com/xiaowuzxc/Yduck-processor/blob/master/doc/%E7%B3%BB%E7%BB%9F%E7%BB%93%E6%9E%84.md)  
[大黄鸭汇编器](https://gitee.com/xiaowuzxc/Yduck-processor/blob/master/doc/%E5%A4%A7%E9%BB%84%E9%B8%AD%E6%B1%87%E7%BC%96%E5%99%A8.md)  
[存储单元特性](https://gitee.com/xiaowuzxc/Yduck-processor/blob/master/doc/%E5%AD%98%E5%82%A8%E5%8D%95%E5%85%83%E7%89%B9%E6%80%A7.md)  


#### 开发工具
正所谓：工欲善其事，必先利其器。  
- 处理器RTL设计采用Verilog-2001，此版本可读性更强，代码密度更高，并且受到综合器的广泛支持。  
- 处理器RTL验证采用System Verilog-2005，此版本充分满足基本的仿真需求，并且受到仿真器的广泛支持。  
- 数字逻辑仿真采用iverilog，这是一个跨平台的开源软件，可以快速地安装和使用。同时也提供了VCS仿真脚本。  
- 汇编器采用Python3，脚本语言清晰易懂，搭配正则表达式便于文本操作，跨平台并且对中文有着良好的支持。  
- 所有文本采用UTF-8编码，具备良好的多语言和跨平台支持。  

#### 目录结构
```
├─doc  相关文档   
├─pic  图片仓库    
├─RTL  
│  │  dbus.v      数据总线  
│  │  ibus.v      指令总线  
│  │  intc.v      中断管理器
│  │  io.v        io外设  
│  │  ram.v       ram外设  
│  │  SoC.v       SoC顶层  
│  │  timer.v     定时器PWM外设  
│  │  YD_core.v   大黄鸭内核  
│  │  YD_int.v    中断控制器
│  │  YD_reg.v    寄存器组  
│  ├─tb_iverilog  iverilog仿真脚本  
│  └─tb_vcs       VCS+Verdi仿真脚本   
└─tools  
    ├─asm  大黄鸭汇编器  
    └─setenv 环境配置
```
### 仿真
linux系统可以进入`tools/setenv`，在终端执行`sh autoset.sh`命令，一键自动配置仿真环境。   
#### 逻辑仿真
本项目提供了两套仿真脚本：iverilog+gtkwave 和 vcs+verdi。  
iverilog+gtkwave同时支持Windows和Linux，并且提供了子模块仿真。  
vcs+verdi仅支持Linux，并且仅提供了SoC仿真脚本。  
请根据喜好和需求选择。  
1. iverilog  
首先，终端输入`iverilog -v`显示版本号，请确认版本号>=11，低于此版本无法正常执行仿真。  
请进入`RTL/tb_iverilog`目录。  
    - windows  
    如果未安装或iverilog版本低，请[安装](http://bleyer.org/icarus/)v11版本。  
    双击make.bat，根据提示执行不同目标。  
    - linux  
    如果未安装或iverilog版本低，请在终端输入`sudo apt install iverilog`或通过源码编译安装。  
    打开终端，输入`make`会显示不同目标。  
    根据提示，输入`make <cmd>`执行对应目标。  
2. VCS
请进入`RTL/tb_vcs`目录。  
打开终端，输入`make`执行仿真。  
打开终端，输入`make clean`清理文件。  

#### 编写程序
大黄鸭汇编器是跨平台的，如果想要编写汇编程序并仿真，需要安装python3及以上版本。  
进入`tools/asm`目录，请在`asm.txt`编写程序。  
Win系统双击run.bat执行汇编；Linux系统在终端输入`make`执行汇编。  
程序有误，终端会显示错误信息。  
[大黄鸭汇编器GUI版](https://gitee.com/xiaowuzxc/Yduck-Assembler-GUI)是专注于Windows平台的汇编器，具备~~友好的~~图形化界面。  

### 综合
大黄鸭处理器采用Verilog-2001语法标准，RTL设计可以被绝大多数综合器所综合。使用Vivado综合后没有产生锁存器，有利于时序分析。  
#### FPGA平台
ram、rom采用xilinx推荐的建模方式，在FPGA平台，可以被综合成BRAM。  
Vivado 2019.2，7K325T FPGA，综合报告如下：  
| 资源  |       |
|-------|-------|
| LUT   | 916   |
| FF    | 474   |
| BRAM  | 0.5   |
  
时钟约束在10MHz，根据时序报告推测实际可以跑到80MHz。  

#### ASIC平台
没有Memory Compiler,存储器就让综合器想办法吧。  
综合工具：Design Vision O-2018.06-SP1  
工艺库：TSMC_013 fast  
| Area  | 参数 |
|-------|-------|
| Total cell area | 30254.4 |
| Combinational area | 19879.9 |
| Buf/Inv area | 1688.9 |
| Noncombinational area | 10374.5 |

| Power  | 工作电压 1.32v |
|-------|-------|
| Cell Leakage Power | 2.5305 uW |
| Total Dynamic Power | 1.3192 mW |
| Cell Internal Power | 881.6719 uW |
| Net Switching Power | 437.5506 uW  |

### 杂谈:我为什么要做大黄鸭
本项目开坑没有什么特殊原因~~纯属脑子一热~~。开坑前，我正沉迷于学习FPGA和计算机体系结构，研究各种指令集(RISC-V,MIPS,8051...)，使用各种嵌入式处理器，移植tinyriscv,e203等各种开源处理器，甚至去看了看古董(~~川口三~~6205,经典8051)。

看了各种各样指令集架构，它们都有让我喜欢和感到变扭的地方，RISC-V简洁但有些操作不方便，51虽古老但有很多闪光点，等等。千奇百怪的处理器，我越看越入迷，越看越有灵感，同时，心中也不可抑制地产生了一种想法，那就是，我能不能自己设计一套指令集？

原本我觉得这想法很可笑，毕竟我才学了一年的verilog，水平不怎么样，写处理器如同蚂蚁想要推到大树一般自大而无畏。但是，我又觉得，或许可以尝试一下。不需要这个指令集有多么优秀，能够拳打ARM脚踢RV，只要合我心意，满足最基本的顺序、选择、循环结构，可以使用汇编编写指令，对我来说，就足够了。

我有个习惯，那就是从来不打没准备的仗。热血上头的那天晚上，横竖睡不着觉，脑子里不停构思指令集怎么设计，16位一条指令怎么分配，用哈佛还是冯诺依曼。慢慢的思考，大黄鸭指令集就如拨云见日，从模模糊糊到清晰可见；把脑子里构思的指令集一条一条写下来，我觉得我能看到希望了；根据指令集在脑子里切出个2级流水线，我觉得可以动手了；翻了翻verilog手册和计算机体系结构，我充满了信心。于是，开坑！！！  
