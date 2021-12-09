# 大黄鸭处理器

#### 介绍
自制大黄鸭指令集，8/16位指令集，16条指令，16位处理器，16位地址线，16位数据位宽，16个寄存器

#### 指令集结构
8/16位指令，1.5发射，8位指令可并行执行。  
对指令空间同时读或写、对同一个寄存器写指令互斥。  

##### 8位指令
[7:4]指令[3:0]参数  
加载  
存储  
压栈  
出栈  
逻辑左移  
逻辑右移  
循环左移  
逻辑非  

##### 16位指令
[15:12]指令[11:8]寄存器1[7:4]寄存器2[3:0]参数  
加法  
减法  
非0跳转  
无条件跳转  
[15:12]指令[11:8]寄存器1[7:4]寄存器2[3:0]X  
寄存器转移  
比较  
逻辑与  
逻辑或  


#### 寄存器结构
Z零寄存器  
PC指令指针  
SP堆栈指针  
W核心寄存器  
D0~D12通用寄存器  

#### 使用说明

1.  xxxx
2.  xxxx
3.  xxxx

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
