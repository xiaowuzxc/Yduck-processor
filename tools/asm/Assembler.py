#python3脚本，大黄鸭汇编器

#导入库
import os,re
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
		inistr=inistr.replace('\t','')#去除此行所有TAB
		inistr=inistr.upper()#所有字母转为大写
		cntstr=0#字符指针
		while cntstr<len(inistr):#遍历整行，去除无效内容
			if inistr[cntstr]=='#' or inistr[cntstr]=='\n' or inistr[cntstr]=='\r':#如果有#或换行
				inistr=inistr[:cntstr]#储存结束符前的数据
				break#结束遍历
			cntstr+=1#无事发生，下一个字符
		if cntstr:#如果此行有有效内容
			data[行指针]=inistr#存回data
		else:#此行是空白
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
		ckstr=re.match(r'NF|LD|SV|IN|SW|NOP',inistr)#检测开头是否匹配8b指令
		if ckstr:#8b/NOP指令
			ckstr=re.match(r'((((NF|LD|SV|IN|SW),(ZE|DK|PC|R[0-9|A|B|C]))|NOP);(((NF|LD|SV|IN|SW),(ZE|DK|PC|R[0-9|A|B|C]))|NOP))|NOP'\
			,inistr)
			if ckstr:#匹配8b语法
				pass
			else:#不匹配
				print("错误:out.txt 第",行指针+1,"行指令语法错误")
		else:#16b指令
			ckstr=re.match(r'WR|CR|LA|LO',inistr)#检测是否匹配16b CMD,RG1,RG2语法
			if ckstr:#16b指令CMD,RG1,RG2
				ckstr=re.match(r'(WR|CR|LA|LO),(ZE|DK|PC|R[0-9|A|B|C]),(ZE|DK|PC|R[0-9|A|B|C])',inistr)
				if ckstr:
					pass
				else:
					print("错误:out.txt 第",行指针+1,"行指令语法错误")
			else:#16b指令CMD,RG,$H
				ckstr=re.match(r'(AD|SB|JW|JA|LL|LR|TL),(ZE|DK|PC|R[0-9|A|B|C]),\d\d?\d?',inistr)
				if ckstr:
					pass
				else:
					print("错误:out.txt 第",行指针+1,"行指令语法错误")
				inistr=inistr[6:]#储存结束符前的数据
				inistr=int(inistr)
				if inistr<0 or inistr>255:#检查立即数溢出
					print("错误:out.txt 第",行指针+1,"行立即数位宽错误")
		行指针+=1#切换下一行

def 执行汇编():
	obj=open('./obj.txt','w+')#创建输出文件
	for strdata in data:
		ckstr=re.search(r'NF|LD|SV|IN|SW|NOP',strdata)#检测是否匹配8b/NOP指令
		if ckstr:#8b/NOP指令
			if re.match(r'NOP',strdata) and len(strdata) < 4:#只有NOP
				objdata=YDwcm['NOP']+YDwcm['NOP']#一个周期空指令
			else:#CMD,RG;XX
				objdata=YDcmd[strdata[0:2]]+YDreg[strdata[3:5]]#第一个8b指令输入
				if re.match(r'NOP',strdata[6:]):#CMD,RG;NOP
					objdata=objdata+YDwcm['NOP']
				else:#CMD,RG;CMD,RG
					objdata=objdata+YDcmd[strdata[6:8]]+YDreg[strdata[9:]]
		else:#16b指令
			if re.match(r'WR|CR|LA|LO',strdata):#16b指令CMD,RG1,RG2
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
语法检查()#检查语法和立即数
执行汇编()#二进制代码写入obj.txt
print('结束汇编')
