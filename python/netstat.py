#!/usr/bin/python
#coding=utf-8

import MySQLdb
import time
from psutil import net_connections
timestamp=int(time.time())
netstat = net_connections(kind='tcp4')
i=0 
j=0

#这里写你的系统及其IP
app0_ip=['127.0.0.1','192.168.0.21']
app1_ip=['0.0.0.0',]
#app2_ip=['192.168.0.21']

appa=[app0_ip,app1_ip]
#连接数
count = netstat.__len__()
#应用数
count2=appa.__len__()
#初始化各个状态对应各系统的连接数
LISTEN=[0,0,0]
ESTABLISHED=[0,0,0]
TIME_WAIT=[0,0,0]
CLOSE_WAIT=[0,0,0]
other=[0,0,0]
#计算各系统\状态的连接数
while i < count:
    ip=netstat[i].laddr[0]
    for j in range(0,count2):
        if ip in appa[j]:
            if netstat[i].status=='ESTABLISHED':
                ESTABLISHED[j]=ESTABLISHED[j]+1
            elif netstat[i].status=='TIME_WAIT':
                TIME_WAIT[j]=TIME_WAIT[j]+1
            elif netstat[i].status=='LISTEN':
                LISTEN[j]=LISTEN[j]+1
            elif netstat[i].status=='CLOSE_WAIT':
                CLOSE_WAIT[j]=CLOSE_WAIT[j]+1
            else:
                other[j]=other[j]+1
            break
    i=i+1
#写入数据库
conn=MySQLdb.connect(host='localhost',port=3306,user='root',passwd='toor',db='test')
cur=conn.cursor()
for y in range(count2):
    sql="insert into conn_monitor(m_id,app_id,path,listen,established,time_wait,close_wait,other,timestamp) values(0,(select id from application where name='app%s'),'any',%d,%d,%d,%d,%d,%d)"%(y,LISTEN[y],ESTABLISHED[y],TIME_WAIT[y],CLOSE_WAIT[y],other[y],timestamp)
    cur.execute(sql)
cur.close()
conn.commit()
conn.close()
