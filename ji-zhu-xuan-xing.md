在基于容器的微服务架构中，由于服务运行的位置、数量和时间的不确定性，传统用于虚拟机的性能监控和日志收集方式很难适应容器应用动态变化的特点。

## 应用日志的去向 {#应用日志的去向}

* 容器挂载宿主机目录作为应用日志输出目录，日志落盘在宿主机。
* 应用日志标准输出到控制台，由 Docker log-driver 接管日志。
* 应用主动把日志输出到日志收集器，如 kafka、logstash、syslog 等。

### 应用日志输出至文件

集群中所有宿主机上需要运行采集工具，如 filebeat、logstash 等。 相较于传统虚拟机应用差别不大，但由于 Docker 的特点以及应用混搭在同一集群中，有以下弊端：

* 应用混搭同一集群，采集端需要采集所有日志，不同业务日志格式不尽相同，日志分割时规则太多，太乱；
* 不能很好的记录容器的信息，如主机名；
* 不能很好的区日志属于哪个业务；
* 集群中所有宿主机都要部署日志采集端，管理不方便，小规模下能使用；

### 应用日志标准输出到控制台

Docker 从 1.12 开始支持[Logging Driver](https://docs.docker.com/engine/admin/logging/overview/#configure-the-logging-driver-for-a-container)，允许将Docker日志路由到指定的第三方日志转发层，可将日志转发到 AWS CloudWatch，Fluentd，syslog，GELF 或 NAT 服务器。

使用 logging drivers 比较简单好用，它们需要为每个容器指定，并且将需要在日志的接收端进行其他配置。

\(1\) 指定 Logging Driver 为 GELF 并传送到 logstash :

```
docker run \
--log-driver gelf \
--log-opt gelf-address=udp://10.78.170.55:12201 \
 alpine echo hello world
```

logstash 配置:

```
input {
  gelf {
      host => "0.0.0.0"
      port => 12201
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch"]
    workers=> 10
  }
}
```

\(2\) 指定 Logging Driver 为 syslog 并传送到 logstash :

```
docker run \
--log-driver=syslog \
--log-opt syslog-address=tcp://10.78.170.55:5000 \
--log-opt syslog-facility=daemon \
alpine echo hello world
```

logstash 配置:

```
input {
  syslog {
      host => "0.0.0.0"
      port => 5000
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch"]
    workers=> 10
  }
}
```

如此这样运行每一个容器，结果是将 Docker 容器日志流输出到 logstash input syslog server，这些日志经过 logstash 处理后发送到 Elasticsearch 或 kafka。

此方案对应用要求低，只需要日志前台输出就可以收集，并不同业务应用日志不会混在一起，方便后期的处理。 关于日志完整性以及数据持久化问采集端 logstash 可以不做任何处转发至 kaf其他组件通过订阅 Kafka 实现更丰富的日志处理。例如：logstash分割聚合后入Elasticsearch，storm 计算处理进行告警，flume 采集处理至 hd进行日志落盘。

kubernetes 目前暂未支持 pod 级别的 log-driver，但社区有讨论[方案](https://github.com/kubernetes/kubernetes/issues/15478)，后续有望支持。

### 应用主动把日志输出到日志收集器

业务日志由进程直接写入 Kafka，其他组件通过订阅 Kafka 实现更丰富的日志处理。例如，使用 Flume 订阅 Kafka 并将日志写入 HDFS。logstash 订阅 Kakfa 分割聚合写入 ElasticSearch。

此方案是最完美的，但需要对业务应日志模块进行更改。



