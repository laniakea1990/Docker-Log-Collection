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

Fluentd tries to structure data as JSON as much as possible: this allows Fluentd to **unify **all facets of processing log data: collecting, filtering, buffering, and outputting logs across **multiple sources and destinations** \([Unified Logging Layer](http://www.fluentd.org/blog/unified-logging-layer)\). The downstream data processing is much easier with JSON, since it has enough structure to be accessible while retaining flexible schemas.

![](/assets/unified logging with json.png)

### Pluggable Architecture

Fluentd has a flexible plugin system that allows the community to extend its functionality. Our 500+ community-contributed plugins connect dozens of [data sources](https://www.fluentd.org/datasources) and [data outputs](https://www.fluentd.org/dataoutputs). By leveraging the plugins, you can start making better use of your logs right away.

![](/assets/Pluggable Architecture.png)

### Minimum Resources Required

Fluentd is written in a combination of C language and Ruby, and requires very little system resource. The vanilla（简朴、平常） instance runs on 30-40MB of memory and can process 13,000 events/second/core. If you have more tighter memory requirement \(-450kb\), check out [Fluent Bit](http://fluentbit.io/), the lightweight forwarder for Fluentd.

![](/assets/Minimum Resources Required.png)

### Built-in Reliability

Fluentd supports memory- and file-based buffering to prevent inter-node data loss. Fluentd also support robust failover and can be set up for high availability. [2,000+ data-driven companies](https://www.fluentd.org/testimonials) rely on Fluentd to differentiate their products and services through a better use and understanding of their log data.

![](/assets/Built-in Reliability.png)

## 参考

Docker Logging via EFK \(Elasticsearch + Fluentd + Kibana\) Stack with Docker Compose  
：[https://docs.fluentd.org/v0.12/articles/docker-logging-efk-compose](https://docs.fluentd.org/v0.12/articles/docker-logging-efk-compose)

Docker Logging Driver and Fluentd  
：[https://docs.fluentd.org/v0.12/articles/docker-logging](https://docs.fluentd.org/v0.12/articles/docker-logging)

Docker Logging：[https://www.fluentd.org/guides/recipes/docker-logging](https://www.fluentd.org/guides/recipes/docker-logging)

What is Fluentd?：[https://www.fluentd.org/architecture](https://www.fluentd.org/architecture)

Why Use Fluentd?：[https://www.fluentd.org/why](https://www.fluentd.org/why)

Quickstart Guide  
：[https://docs.fluentd.org/v0.12/articles/quickstart](https://docs.fluentd.org/v0.12/articles/quickstart)

kubernetes Logging Architecture：  
[https://kubernetes.io/docs/concepts/cluster-ad](https://kubernetes.io/docs/concepts/cluster-ad)

