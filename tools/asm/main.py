#python边学边做
#最终将会做一个汇编器
import os
txt=open('./test.txt','r+')
data=txt.readlines()#list
#txt.write('sdawd:te')
i=len(data)
a=0
while a<i:
    inistr=data[a]#字符串
    cntstr=0#字符串计数
    while cntstr<len(inistr):
        if inistr[cntstr]=='#' or inistr[cntstr]=='\n' or inistr[cntstr]=='\r':
            inistr=inistr[:cntstr]
            break
        cntstr=cntstr+1  
    print(inistr)
    if cntstr:
        data[a]=inistr
    else:
        data.pop(a)
        a=a-1
        i=len(data)
    a=a+1
print('over')
os.remove('./out.txt')
obj=open('./out.txt','w+')
i=len(data)
a=0
while a<i:
    obj.write(data[a])
    a+=1