#!/usr/bin/python
#coding=utf-8
import os
while 1:
    x=raw_input('\033[01;31mInput math like this:"1 + 2"(include space!)  \033[0m').split()
    if x[0]=='help':
        os.system('clear')
        print('You can input math like "1 + 2",and your input must include space"\nYou can exit with inputing "exit"\n')
        continue
    elif x[0]=='exit':
        break
    elif len(x) > 1 and x[1] == '+':
        answer=float(x[0])+float(x[2])
    elif len(x) > 1 and x[1] == '-':
        answer=float(x[0])-float(x[2])
    elif len(x) > 1 and x[1] == '*':
        answer=float(x[0])*float(x[2])
    elif len(x) > 1 and x[1] == '/':
        answer=float(x[0])/float(x[2])
    else:
        print('Input error!')
        continue
    print('\033[30;42m=%f\033[0m'%(answer))
print('\033[41;36mbye!\033[0m')
