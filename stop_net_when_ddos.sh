#!/bin/bash

# 第一个参数为要处理的网卡名，如eth0
# 使用方法 
# sudo su
# nohup ./stop_net_when_ddos.sh eth0 > stop_net_when_ddos.log 2>&1 &

while true
do
    RX_pre=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $2}')
    sleep 1
    RX_next=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $2}')
    RX=$((${RX_next}-${RX_pre}))
    # 入流量大于4.5Mbit/s，断网5min
    if [[ $RX -gt 589824 ]];then
        echo "stop network interface $1 at `date`"
        ifconfig $1 down
        sleep 300
        echo "start network interface $1 at `date`"
        ifconfig $1 up
    fi
    # if [[ $RX -lt 1024 ]];then
    # RX="${RX}B/s"
    # elif [[ $RX -gt 1048576 ]];then
    # RX=$(echo $RX | awk '{print $1/1048576 "MB/s"}')
    # else
    # RX=$(echo $RX | awk '{print $1/1024 "KB/s"}')
    # fi
    # echo -e "$ethn \t $RX"
done