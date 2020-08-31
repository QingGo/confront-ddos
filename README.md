以下脚本均需要在root用户下运行，而且需要把eth0改成你连通外网的网卡名。

只要我网线拔得够快，ddos就打不到我。使用方法：
```
nohup ./stop_net_when_ddos.sh eth0 > stop_net_when_ddos.log 2>&1 &
```

只要我电源拔得够快，ddos就打不到我。使用方法：
```
nohup ./shutdown_when_ddos.sh eth0 > shutdown_when_ddos.log 2>&1 &
```