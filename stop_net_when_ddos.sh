#!/bin/bash

# 第一个参数为要处理的网卡名，如eth0
# 使用方法 
# sudo su
# nohup ./stop_net_when_ddos.sh eth0 > stop_net_when_ddos.log 2>&1 &

break_count=0
while true
do
    receive_bytes_pre=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $2}')
    receive_packets_pre=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $3}')
    send_bytes_pre=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $10}')
    send_packets_pre=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $11}')
    sleep 1
    receive_bytes_next=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $2}')
    receive_packets_next=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $3}')
    send_bytes_next=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $10}')
    send_packets_next=$(cat /proc/net/dev | grep $1 | sed 's/:/ /g' | awk '{print $11}')
    receive_bytes=$((${receive_bytes_next}-${receive_bytes_pre}))
    receive_packets=$((${receive_packets_next}-${receive_packets_pre}))
    send_bytes=$((${send_bytes_next}-${send_bytes_pre}))
    send_packets=$((${send_packets_next}-${send_packets_pre}))
    # 入流量连续5次大于8Mbit/s，断网5min
    echo "`date`|break_count:$break_count,receive_bytes:$receive_bytes,receive_packets:$receive_packets,send_bytes:$send_bytes,send_packets:$send_packets"
    if [[ $RX -gt 1048576 ]];then
        break_count+=1
        # echo "`date`|break_count:$break_count,receive_bytes:$receive_bytes,receive_packets:$receive_packets,send_bytes:$send_bytes,send_packets:$send_packets"
        if [[ $break_count -ge 5 ]];then
            echo "stop network interface $1 at `date`"
            ifconfig $1 down
            sleep 300
            echo "start network interface $1 at `date`"
            ifconfig $1 up
            break_count=0
        fi
    else
        break_count=0
    fi
done