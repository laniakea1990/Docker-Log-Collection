Prometheus是一款开源的系统监控和告警工具，最初由SoundCloud推出。自2012成立以来，许多公司和组织都采用了prometheus，项目有一个非常活跃的开发者和用户社区。Prometheus现在是一个独立的开源项目，它的维护独立于任何公司。2016年，Prometheus在Kubernetes之后第二个加入到 [Cloud Native Computing Foundation](https://cncf.io/) 项目。

## Features

Prometheus的主要特性有：

* 多维度数据模型（由键/值对确定的时间序列数据模型）
* 具有一个灵活的查询语言来利用这些维度
* 不依赖分布式存储；可单个服务器节点工作。
* 时间序列的采集是通过HTTP pull的形式，解决很多push架构的问题。
* 通过中介网关支持push形式时间序列数据的收集  \( pushing time series is supported via an intermediary gateway \)
* 监控目标的发现是通过服务发现或静态配置  \( targets are discovered via service discovery or static configuration   \)
* 多种数据展示面板支持，例如grafana \( multiple modes of graphing and dashboarding support \)







