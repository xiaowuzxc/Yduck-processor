#python3脚本，大黄鸭汇编器

#导入库
#import os,re
from os import remove
from re import search,match
#定义指令字典
YDcmd={'NF':'0000','LD':'0001','SV':'0010','IN':'0011','SW':'0100','WR':'0101','CR':'0110',\
'LA':'0111','LO':'1000','AD':'1001','SB':'1010','JW':'1011','JA':'1100','LL':'1101','LR':'1110','TL':'1111'}
#定义寄存器字典
YDreg={'ZE':'0000','DK':'0001','R0':'0010','R1':'0011','R2':'0100','R3':'0101','R4':'0110','R5':'0111',\
'R6':'1000','R7':'1001','R8':'1010','R9':'1011','RA':'1100','RB':'1101','RC':'1110','PC':'1111'}
#定义伪指令
YDwcm={'NOP':'00000000'}

def 检查out文件():
	try:
		f=open('./out.txt')
		f.close()
	except IOError:
		print ("无预处理文件")
	else:
		remove('./out.txt')
		print ("重新生成预处理文件")
	try:
		f=open('./obj.txt')
		f.close()
	except IOError:
		print ("无输出文件")
	else:
		remove('./obj.txt')
		print ("重新生成输出文件")

def 指令预处理():
	总行数=len(data)#得到行数
	行指针=0#清理行多余字符
	while 行指针<总行数:#遍历list
		inistr=data[行指针]#data的对应行存入inistr
		inistr=inistr.replace(' ','')#去除此行所有空格
		inistr=inistr.replace('\t','')#去除此行所有TAB
		inistr=inistr.upper()#所有字母转为大写
		cntstr=0#字符指针
		while cntstr<len(inistr):#遍历整行，去除无效内容
			if inistr[cntstr]=='#' or inistr[cntstr]=='\n' or inistr[cntstr]=='\r':#如果有#或换行
				inistr=inistr[:cntstr]#储存结束符前的数据
				break#结束遍历
			cntstr+=1#无事发生，下一个字符
		语法检查(待检查的行=inistr,待检查行数=行指针)
		data[行指针]=inistr#存回data
		行指针+=1
	行指针=0#清理多余行
	while 行指针<总行数:#遍历list
		if len(data[行指针])==0:
			data.pop(行指针)#删除行
			行指针=行指针-1
			总行数=len(data)#重置行数
		行指针+=1#切换下一行
	行指针=0
	out=open('./out.txt','w+')#创建中间文件，写入经过预处理的指令
	总行数=len(data)
	while 行指针<总行数:
		out.write(data[行指针])#写入
		out.write('\n')#换行
		行指针+=1
	out.close()

def 语法检查(待检查的行,待检查行数):
	if len(待检查的行)>1:
		ckstr=search(r'[^A-Z\d,;]',待检查的行)
		if ckstr:
			print("错误: 第",待检查行数+1,"行存在非法字符")
		else:
			pass
		ckstr=match(r'NF|LD|SV|IN|SW|NOP',待检查的行)#检测开头是否匹配8b指令
		if ckstr:#8b/NOP指令
			ckstr=match(r'((((NF|LD|SV|IN|SW),(ZE|DK|PC|R[0-9|A|B|C]))|NOP);(((NF|LD|SV|IN|SW),(ZE|DK|PC|R[0-9|A|B|C]))|NOP))|NOP'\
			,待检查的行)
			if ckstr:#匹配8b语法
				if(待检查的行[3:5]==待检查的行[9:11] and 待检查的行[0:3]!='NOP'):#检查并行指令寄存器冲突
					print("警告: 第",待检查行数+1,"行存在寄存器冲突")
			else:#不匹配
				print("错误: 第",待检查行数+1,"行指令语法错误")
		else:#16b指令
			ckstr=match(r'WR|CR|LA|LO',待检查的行)#检测是否匹配16b CMD,RG1,RG2语法
			if ckstr:#16b指令CMD,RG1,RG2
				ckstr=match(r'(WR|CR|LA|LO),(ZE|DK|PC|R[0-9|A|B|C]),(ZE|DK|PC|R[0-9|A|B|C])',待检查的行)
				if ckstr:
					pass
				else:
					print("错误: 第",待检查行数+1,"行指令语法错误")
			else:#16b指令CMD,RG,$H
				ckstr=match(r'(AD|SB|JW|JA|LL|LR|TL),(ZE|DK|PC|R[0-9|A|B|C]),\d\d?\d?',待检查的行)
				if ckstr:
					pass
				else:
					print("错误: 第",待检查行数+1,"行指令语法错误")
				立即数=int(待检查的行[6:])#检查立即数溢出
				if 立即数<0 or 立即数>255:
					print("错误: 第",待检查行数+1,"行立即数位宽错误")


def 执行汇编():
	obj=open('./obj.txt','w+')#创建输出文件
	for strdata in data:
		ckstr=search(r'NF|LD|SV|IN|SW|NOP',strdata)#检测是否匹配8b/NOP指令
		if ckstr:#8b/NOP指令
			if match(r'NOP',strdata) and len(strdata) < 4:#只有NOP
				objdata=YDwcm['NOP']+YDwcm['NOP']#一个周期空指令
			else:#CMD,RG;XX
				objdata=YDcmd[strdata[0:2]]+YDreg[strdata[3:5]]#第一个8b指令输入
				if match(r'NOP',strdata[6:]):#CMD,RG;NOP
					objdata=objdata+YDwcm['NOP']
				else:#CMD,RG;CMD,RG
					objdata=objdata+YDcmd[strdata[6:8]]+YDreg[strdata[9:]]
		else:#16b指令
			if match(r'WR|CR|LA|LO',strdata):#16b指令CMD,RG1,RG2
				objdata=YDcmd[strdata[0:2]]+YDreg[strdata[3:5]]+YDreg[strdata[6:8]]+'0000'
			else:#16b指令CMD,RG,$H
				objdata=YDcmd[strdata[0:2]]+YDreg[strdata[3:5]]+"{:b}".format(int(strdata[6:])).zfill(8)
		obj.write(objdata)#写入
		obj.write('\n')#换行
	obj.close()

##################################################
#--------------------main------------------------#
##################################################
检查out文件()#如果已存在out文件，则重新生成
with open('./asm.txt','r+',encoding='UTF-8') as f:#打开test.txt文件
	data=f.readlines()#按行读取，生成list至data
f.closed#关闭文件
指令预处理()#预处理data，去除注释、多余行、空格，写入out.txt
执行汇编()#二进制代码写入obj.txt
print('结束汇编')
