## CAdvisor部署

CAdviosr是Google用来监测单节点的资源信息的监控工具, 提供了一目了然的单节点多容器的图表型资源监控功能。

CAdvisor是一个容器资源监控工具，包括容器的内存，CPU，网络IO，磁盘IO等监控，同时提供了一个WEB页面用于查看容器的实时运行状态。CAdvisor默认存储2分钟的数据，而且只是针对单物理机。

由于CAdvisor已经容器化，部署和运行很简单，执行如下命令即可:

```
$~ docker run \
--volume=/:/rootfs:ro \
--volume=/var/run:/var/run:rw \
--volume=/sys:/sys:ro \
--volume=/var/lib/docker/:/var/lib/docker:ro \
--publish=8099:8080 \
--detach=true \
--name=cadvisor \
google/cadvisor:latest
```

运行之后，就可以在浏览器打开 [http://ip:8099](http://ip:8099) 查看宿主机的容器监控数据了。

![](/assets/Cadvisor1.png)![](/assets/Cadvisor2.png)![](/assets/Cadvisor3.png)

## CAdvisor原理简介

CAdvisor运行时挂载了宿主机根目录，docker根目录等多个目录，由此可以从中读取容器的运行时信息。docker基础技术有Linux namespace，Control Group\(CGroup\)，AUFS等，其中CGroup用于系统资源限制和优先级控制的。

宿主机的`/sys/fs/cgroup/`目录下面存储的就是CGroup的内容了，CGroup包括多个子系统，如对块设备的blkio，cpu，内存，网络IO等限制。Docker在CGroup里面的各个子系统中创建了docker目录，而CAdvisor运行时挂载了宿主机根目录和 `/sys`目录，从而CAdvisor可以读取到容器的资源使用记录。比如下面可以看到容器b1f257当前时刻的CPU的使用统计。

