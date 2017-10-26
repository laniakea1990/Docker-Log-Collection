CAdvisor是一个容器资源监控工具，包括容器的内存，CPU，网络IO，磁盘IO等监控，同时提供了一个WEB页面用于查看容器的实时运行状态。CAdvisor默认存储2分钟的数据，而且只是针对单物理机。不过，CAdvisor提供了很多数据集成接口，支持InfluxDB，Redis，Kafka，Elasticsearch等集成，可以加上对应配置将监控数据发往这些数据库存储起来。

## **跨多台主机上容器的监控**

cAdivsor虽然能采集到监控数据，也有很好的界面展示，但是并不能显示跨主机的监控数据，当主机多的情况，需要有一种集中式的管理方法将数据进行汇总展示，最经典的方案就是 cAdvisor+ Influxdb+grafana，可以在每台主机上运行一个cAdvisor容器负责数据采集，再将采集后的数据都存到时序型数据库influxdb中，再通过图形展示工具grafana定制展示面板。结构如下：

![](/assets/CAdvisor_Influxdb_Grafana.png)

这三个工具的安装也非常简单，可以直接启动三个容器快速安装。

### InfluxDB重要概念

influxdb有一些重要概念：database，timestamp，field key， field value， field set，tag key，tag value，tag set，measurement， retention policy ，series，point，下面简要说明一下：

* database：数据库，如之前创建的数据库 cadvisor。InfluxDB不是CRUD数据库，更像是一个CR-ud数据库，它优先考虑的是增加和读取数据而不是更新删除数据的性能。
* timestamp：时间戳，因为InfluxDB是时序数据库，它的数据里面都有一列名为time的列，存储记录生成时间。如 rx\_bytes 中的 time 列，存储的就是时间戳。
* fields: 包括field key，field value和field set几个概念。field key是字段名，在rx\_bytes表中，字段名为 value。field value是字段值，如 `17858781633`，`1359398`等。而field set是字段集合，由field key和field value构成，如rx\_bytes中的字段集合如下：
  ```
  value = 17858781633
  value = 1359398
  ```

  在InfluxDB表中，字段必须存在，而且字段是没有索引的。所以，字段相当于传统数据库中没有索引的列。

* tags：包括tag key， tag value， tag set几个概念。tag key是标签名，在rx\_bytes表中，`container_name`, `game`, `machine`, `namespace`，`type`都是标签。tag value就是标签的值了。tag set就是标签集合，由tag key和tag value构成。**InfluxDB中标签是可选的，不过标签是有索引的**。如果查询中经常用的字段，建议设置为标签而不是字段。标签相当于传统数据库中有索引的列。

* 




### 基于docker-compose.yml文件安装**InfluxDB、influxDB、Grafana**

InfluxDB是一个开源的分布式时序数据库，使用GO语言开发。特别适合用于时序类型数据存储，CAdvisor搜集的容器监控数据用InfluxDB存储就很合适，而且CAdvisor本身就提供了InfluxDB的支持，集成起来非常方便。



