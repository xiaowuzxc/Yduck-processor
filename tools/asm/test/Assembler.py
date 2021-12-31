#python边学边做
#最终将会做一个汇编器
import os,re

def 检查out文件():
	try:
		f=open('./out.txt')
		f.close()
	except IOError:
		print ("无预处理文件")
	else:
		os.remove('./out.txt')
		print ("重新生成预处理文件")
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
		cntstr=0#字符指针
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
	out=open('./out.txt','w+')#out.txt为经过预处理的指令
	总行数=len(data)
	while 行指针<总行数:
		out.write(data[行指针])#写入
		out.write('\n')#换行
		行指针+=1
	out.close()

def 语法检查():
	总行数=len(data)#得到行数
	行指针=0
	while 行指针<总行数:#遍历list
		inistr=data[行指针]#data的对应行存入inistr
		ckstr=re.search(r'[^A-Z\d,;]',inistr)
		if ckstr:
			print("错误:out.txt 第",行指针+1,"行存在非法字符")
		else:
			pass
		ckstr=re.match(r'((NF)|(LD)|(SV)|(IN)|(SW))',inistr)
		if ckstr:#8b指令
			ckstr=re.match(r'((NF)|(LD)|(SV)|(IN)|(SW)),((ZE)|(DK)|(PC)|(R[0-9|A|B|C]));(((NF)|(LD)|(SV)|(IN)|(SW)),((ZE)|(DK)|(PC)|(R[0-9|A|B|C]))|NOP)',inistr)
			if ckstr:#匹配8b语法
				pass
			else:#不匹配
				print("错误:out.txt 第",行指针+1,"行指令语法错误")
		else:#16b指令
			ckstr=re.match(r'((WR)|(CR)|(LA)|(LO))',inistr)
			if ckstr:#16b指令CMD,RG1,RG2
				ckstr=re.match(r'((WR)|(CR)|(LA)|(LO)),((ZE)|(DK)|(PC)|(R[0-9|A|B|C])),((ZE)|(DK)|(PC)|(R[0-9|A|B|C]))',inistr)
				if ckstr:
					pass
				else:
					print("错误:out.txt 第",行指针+1,"行指令语法错误")
			else:#16b指令CMD,RG,$H
				ckstr=re.match(r'((AD)|(SB)|(JW)|(JA)|(LL)|(LR)|(TL)),((ZE)|(DK)|(PC)|(R[0-9|A|B|C])),\d\d?\d?',inistr)
				if ckstr:
					pass
				else:
					print("错误:out.txt 第",行指针+1,"行指令语法错误")
				inistr=inistr[6:]#储存结束符前的数据
				inistr=int(inistr)
				if inistr<0 or inistr>255:
					print("错误:out.txt 第",行指针+1,"行立即数位宽错误")
		行指针+=1#切换下一行

def 执行汇编():
	obj=open('./obj.txt','w+')
	for strdata in data:
		strdata=strdata+"0v0"
		obj.write(strdata)#写入
		obj.write('\n')#换行
	obj.close()
'''
		inistr=data[行指针]#data的对应行存入inistr
		cntstr=0#字符指针
		while cntstr<len(inistr):#遍历整行，将助记符转换为二进制
			if inistr[cntstr]=='#' or inistr[cntstr]=='\n' or inistr[cntstr]=='\r':#如果有#或换行
				inistr=inistr[:cntstr]#储存结束符前的数据
				break#结束遍历
			cntstr+=1#无事发生，下一个字符
'''


检查out文件()#如果已存在out文件，则重新生成
with open('./asm.txt','r+') as f:#打开test.txt文件
	data=f.readlines()#按行读取，生成list至data
f.closed#关闭文件
指令预处理()#预处理data，去除注释、多余行、空格
语法检查()
执行汇编()
print('over')
'''

'''
