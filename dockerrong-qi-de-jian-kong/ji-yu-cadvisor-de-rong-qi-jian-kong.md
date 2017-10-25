Cadviosr是Google用来监测单节点的资源信息的监控工具, 提供了一目了然的单节点多容器的图表型资源监控功能。

CAdvisor是一个容器资源监控工具，包括容器的内存，CPU，网络IO，磁盘IO等监控，同时提供了一个WEB页面用于查看容器的实时运行状态。CAdvisor默认存储2分钟的数据，而且只是针对单物理机。不过，CAdvisor提供了很多数据集成接口，支持InfluxDB，Redis，Kafka，Elasticsearch等集成，可以加上对应配置将监控数据发往这些数据库存储起来。

由于CAdvisor已经容器化，部署和运行很简单，执行如下命令即可:

```
$~ docker run \
--volume=/:/rootfs:ro \
--volume=/var/run:/var/run:rw \
--volume=/sys:/sys:ro \
--volume=/var/lib/docker/:/var/lib/docker:ro \
--publish=8090:8080 \
--detach=true \
--name=cadvisor \
google/cadvisor:latest
```

运行之后，就可以在浏览器打开 [http://ip:8080](http://ip:8080/) 查看宿主机的容器监控数据了。

CAdvisor是有用且很容易设置的工具，我们可以不用ssh就能连接到服务器来查看资源的消耗，而且它还给我们生成了图表。此外，当集群需要额外的资源时，压力表提供了快速预览。但是，它有它的局限性；它只能监控一个Docker主机.

