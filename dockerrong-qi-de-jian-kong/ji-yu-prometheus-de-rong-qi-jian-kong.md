Prometheus是一款开源的系统监控和告警工具，最初由SoundCloud推出。自2012成立以来，许多公司和组织都采用了prometheus，项目有一个非常活跃的开发者和用户社区。Prometheus现在是一个独立的开源项目，它的维护独立于任何公司，2016年，Prometheus在Kubernetes之后第二个加入到 [Cloud Native Computing Foundation](https://cncf.io/) 项目。

## Features

Prometheus的主要特性有：

* 多维度数据模型（由键/值对确定的时间序列数据模型）
* 具有一个灵活的查询语言来利用这些维度
* 不依赖分布式存储；可单个服务器节点工作。
* 时间序列的采集是通过HTTP pull的形式，解决很多push架构的问题。
* 通过中介网关支持push形式时间序列数据的收集\( pushing time series is supported via an intermediary gateway \)
* 监控目标的发现是通过服务发现或静态配置\( targets are discovered via service discovery or static configuration \)
* 多种数据展示面板支持，例如grafana \( multiple modes of graphing and dashboarding support \)

## Architecture

This diagram illustrates the architecture of Prometheus and some of its ecosystem components:

![](/assets/Architecture-Prometheus.png)

Prometheus scrapes metrics from instrumented jobs, either directly or via an intermediary push gateway for short-lived jobs. It stores all scraped samples locally and runs rules over this data to either aggregate and record new time series from existing data or generate alerts. [Grafana](https://grafana.com/) or other API consumers can be used to visualize the collected data.

**Prometheus Server**

Prometheus Server 负责从 Exporter 拉取和存储监控数据，并提供一套灵活的查询语言（PromQL）供用户使用。

**Exporter**

Exporter 负责收集目标对象（host, container…）的性能数据，并通过 HTTP 接口供 Prometheus Server 获取。

**Push gateway**

push gateway 用来支持 short-lived jobs

**可视化组件**

监控数据的可视化展现对于监控方案至关重要。以前 Prometheus 自己开发了一套工具，不过后来废弃了，因为开源社区出现了更为优秀的产品 Grafana。Grafana 能够与 Prometheus 无缝集成，提供完美的数据展示能力。

**Alertmanager**

用户可以定义基于监控数据的告警规则，规则会触发告警。一旦 Alermanager 收到告警，会通过预定义的方式发出告警通知。支持的方式包括 Email、PagerDuty、Webhook 等.

也许一些熟悉其他监控方案的同学看了 Prometheus 的架构会不以为然，“这些功能 Zabbix、Graphite、Nagios 这类监控系统也都有，没什么特别的啊！”。Prometheus 最大的亮点和先进性是它的多维数据模型，下面将做介绍。

## 多维数据模型



## Components

The Prometheus ecosystem consists of multiple components, many of which are optional:

* the main [Prometheus server](https://github.com/prometheus/prometheus) which scrapes and stores time series data
* [client libraries](https://prometheus.io/docs/instrumenting/clientlibs/) for instrumenting application code
* a [push gateway](https://github.com/prometheus/pushgateway) for supporting short-lived jobs
* special-purpose [exporters](https://prometheus.io/docs/instrumenting/exporters/) for services like HAProxy, StatsD, Graphite, etc.
* an [alertmanager](https://github.com/prometheus/alertmanager) to handle alerts
* various support tools

Most Prometheus components are written in [Go](https://golang.org/), making them easy to build and deploy as static binaries.

## 参考资料

[https://grafana.com/dashboards/179](https://grafana.com/dashboards/179)

[https://grafana.com/dashboards/893](https://grafana.com/dashboards/893)

[https://grafana.com/dashboards?dataSource=prometheus&search=docker](https://grafana.com/dashboards?dataSource=prometheus&search=docker)

[https://github.com/vegasbrianc/prometheus/tree/version-2](https://github.com/vegasbrianc/prometheus/tree/version-2)

