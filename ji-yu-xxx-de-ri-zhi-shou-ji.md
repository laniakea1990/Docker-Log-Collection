## Fluentd Architecture Overview

Fluentd is an open source log collector, which lets you unify the data collection and consumption for a better use and understanding of data.

Fluentd treats logs as JSON, a popular machine-readable format. It is written primarily in C with a thin-Ruby wrapper that gives users flexibility.

Fluentd’s scalability has been proven in the field: its largest user currently collects logs from 500,000+ servers.

Fluentd是一个免费，而且完全开源的日志管理工具，简化了日志的收集、处理、和存储，你可以不需要再维护编写特殊的日志处理脚本。Fluentd的性能已经在各领域得到了证明：目前最大的用户从5000+服务器收集日志，每天5TB的数据量，在高峰时间处理50,000条信息每秒。

Before Fluentd：

![](/assets/Before Fluentd.png)

After Fluentd：

### ![](/assets/After Fluentd.png)

### Unified Logging with JSON

Fluentd tries to structure data as JSON as much as possible: this allows Fluentd to **unify **all facets of processing log data: collecting, filtering, buffering, and outputting logs across **multiple sources and destinations** \(Unified Logging Layer\). The downstream data processing is much easier with JSON, since it has enough structure to be accessible while retaining flexible schemas.

## 参考

Docker Logging via EFK \(Elasticsearch + Fluentd + Kibana\) Stack with Docker Compose  
：[https://docs.fluentd.org/v0.12/articles/docker-logging-efk-compose](https://docs.fluentd.org/v0.12/articles/docker-logging-efk-compose)

Docker Logging Driver and Fluentd  
：[https://docs.fluentd.org/v0.12/articles/docker-logging](https://docs.fluentd.org/v0.12/articles/docker-logging)

Docker Logging：[https://www.fluentd.org/guides/recipes/docker-logging](https://www.fluentd.org/guides/recipes/docker-logging)

What is Fluentd?：[https://www.fluentd.org/architecture](https://www.fluentd.org/architecture)

Quickstart Guide  
：[https://docs.fluentd.org/v0.12/articles/quickstart](https://docs.fluentd.org/v0.12/articles/quickstart)

kubernetes Logging Architecture：  
[https://kubernetes.io/docs/concepts/cluster-ad](https://kubernetes.io/docs/concepts/cluster-ad)

