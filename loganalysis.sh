#!/bin/bash
#Program:
#       analysis log files 00:10 every day
#History:
#2022/11/29     PolarNight      First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
kernelinfo=$(cat /proc/version | cut -d" " -f1,2,3,4)
cpuinfo=$(cat /proc/cpuinfo | grep name | cut -d":" -f2 | uniq -c)
cpuspeed=$(cat /proc/cpuinfo | grep -i "cpu mhz" | cut -d":" -f2 | uniq) 
hostname=$(hostname)
ip=$(hostname -I)
checktime=$(date)
summarydate=$(date | cut -d" " -f2,3)
ntime1=$(date +%Y-%m-%d)
sshinfo=$(who /var/log/wtmp | grep "${ntime1}")
username=$(who am i)
ntime2=$(date | cut -d" " -f1,2,3,4)
mailinfo=$(cat /var/spool/mail/${username} | grep "${ntime2}" | wc -l)
echo "======================system summary======================"
echo "Linux kernel : "${kernelinfo}""
echo "CPU information : "${cpuinfo}""
echo "CPU speed : "${cpuspeed}" MHz"
echo "Hostname : "${hostname}""
echo "Network IP : "${ip}""
echo "Check time : "${checktime}""
echo "Summary date : "${summarydate}""
echo "UP time : "
#没有理解这个up time
echo "Filessystem summary : "
df -Th | sed 's/^/      /'
echo "======================Ports的相关分析信息======================"
echo "主机启用的port与相关的process owner: "
echo "对外部界面开放的port(PID|owner|command)"
#没有实现(PID|owner|command)的效果
netstat -tlnp | sed 's/^/       /'
echo "======================ssh的日志文件信息汇整======================"
if [ "${sshinfo}" != " " ]; then
       echo ""${sshinfo}""
else
        echo "今日没有使用ssh的记录"
fi
echo "======================Postfix的日志文件信息汇整======================"
echo "使用者邮箱接收邮件次数: "${mailinfo}""
