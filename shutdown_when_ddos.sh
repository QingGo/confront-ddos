#!/bin/bash

# 第一个参数为要处理的网卡名，如eth0
# 使用方法 
# sudo su
# nohup ./shutdown_when_ddos.sh eth0 > shutdown_when_ddos.log 2>&1 &

while true
do
    RX_pre=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $2}')
    sleep 1
    RX_next=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $2}')
    RX=$((${RX_next}-${RX_pre}))
    # 入流量大于5Mbit，自动关机，之后需要手动重启
    if [[ $RX -gt 655360 ]];then
        echo "auto shutdown at `date`"
        shutdown -h now
    fi
    # echo -e "$ethn \t $RX"
done