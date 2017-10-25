Cadviosr是Google用来监测单节点的资源信息的监控工具, 提供了一目了然的单节点多容器的图表型资源监控功能

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

CAdvisor是有用且很容易设置的工具，我们可以不用ssh就能连接到服务器来查看资源的消耗，而且它还给我们生成了图表。此外，当集群需要额外的资源时，压力表提供了快速预览。但是，它有它的局限性；它只能监控一个Docker主机.



