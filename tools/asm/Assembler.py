#python边学边做
#最终将会做一个汇编器
import os

def 检查out文件():
    try:
        f=open('./out.txt')
        f.close()    
    except IOError:        
        print ("即将生成输出文件")
    else:
        os.remove('./out.txt')
        print ("重新生成输出文件")

def 指令预处理():
    i=len(data)#得到行数
    a=0#行指针
    while a<i:#遍历list
        inistr=data[a]#data的a行存入inistr
        inistr=inistr.replace(' ','')#去除此行所有空格
        inistr=inistr.upper()#所有字母转为大写
        cntstr=0#字符串计数
        while cntstr<len(inistr):#遍历整行，去除无效内容
            if inistr[cntstr]=='#' or inistr[cntstr]=='\n' or inistr[cntstr]=='\r':#如果有#或换行
                inistr=inistr[:cntstr]#储存结束符前的数据
                break#结束遍历
            cntstr=cntstr+1#无事发生，下一个字符
        print(inistr)
        if cntstr:#如果此行有有效内容
            data[a]=inistr#存回data
        else:#此行是空白
            data.pop(a)#删除行
            a=a-1#行指针-1
            i=len(data)#重置行数
        a=a+1#切换下一行

检查out文件()#如果已存在out文件，则重新生成
with open('./asm.txt','r+') as f:#打开test.txt文件
    data=f.readlines()#按行读取，生成list至data
f.closed#关闭文件
指令预处理()#预处理data，去除注释、多余行、空格
print('over')
obj=open('./out.txt','w+')
i=len(data)
a=0
while a<i:
    obj.write(data[a])#写入
    obj.write('\n')#换行
    a+=1

