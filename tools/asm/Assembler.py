#python边学边做
#最终将会做一个汇编器
import os

def 检查out文件():
	try:
		f=open('./out.txt')
		f.close()
	except IOError:
		print ("无中间文件")
	else:
		os.remove('./out.txt')
		print ("重新生成输出文件")
	try:
		f=open('./obj.txt')
		f.close()
	except IOError:
		print ("无输出文件")
	else:
		os.remove('./obj.txt')
		print ("重新生成输出文件")

def 指令预处理():
	总行数=len(data)#得到行数
	行指针=0
	while 行指针<总行数:#遍历list
		inistr=data[行指针]#data的对应行存入inistr
		inistr=inistr.replace(' ','')#去除此行所有空格
		inistr=inistr.upper()#所有字母转为大写
		cntstr=0#字符串计数
		while cntstr<len(inistr):#遍历整行，去除无效内容
			if inistr[cntstr]=='#' or inistr[cntstr]=='\n' or inistr[cntstr]=='\r':#如果有#或换行
				inistr=inistr[:cntstr]#储存结束符前的数据
				break#结束遍历
			cntstr+=1#无事发生，下一个字符
		print(inistr)
		if cntstr:#如果此行有有效内容
			data[行指针]=inistr#存回data
		else:#此行是空白
			data.pop(行指针)#删除行
			行指针=行指针-1
			总行数=len(data)#重置行数
		行指针+=1#切换下一行
	行指针=0
	out=open('./out.txt','w+')
	总行数=len(data)
	while 行指针<总行数:
		out.write(data[行指针])#写入
		out.write('\n')#换行
		行指针+=1

def 语法检查():
	pass





检查out文件()#如果已存在out文件，则重新生成
with open('./asm.txt','r+') as f:#打开test.txt文件
	data=f.readlines()#按行读取，生成list至data
f.closed#关闭文件
指令预处理()#预处理data，去除注释、多余行、空格
语法检查()

print('over')
'''
obj=open('./obj.txt','w+')
i=len(data)
a=0
while a<i:
	obj.write(data[a])#写入
	obj.write('\n')#换行
	a+=1
'''
