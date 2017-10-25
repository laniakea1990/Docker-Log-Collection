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



