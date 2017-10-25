CAdvisor是一个容器资源监控工具，包括容器的内存，CPU，网络IO，磁盘IO等监控，同时提供了一个WEB页面用于查看容器的实时运行状态。CAdvisor默认存储2分钟的数据，而且只是针对单物理机。不过，CAdvisor提供了很多数据集成接口，支持InfluxDB，Redis，Kafka，Elasticsearch等集成，可以加上对应配置将监控数据发往这些数据库存储起来。

## **跨多台主机上容器的监控**

cAdivsor虽然能采集到监控数据，也有很好的界面展示，但是并不能显示跨主机的监控数据，当主机多的情况，需要有一种集中式的管理方法将数据进行汇总展示，最经典的方案就是 cAdvisor+ Influxdb+grafana，可以在每台主机上运行一个cAdvisor容器负责数据采集，再将采集后的数据都存到时序型数据库influxdb中，再通过图形展示工具grafana定制展示面板。结构如下：

![](/assets/CAdvisor_Influxdb_Grafana.png)

这三个工具的安装也非常简单，可以直接启动三个容器快速安装。如下所示：  
![](/assets/install_CAdvisor_influxdb_grafana.png)

在上面的安装步骤中，先是启动influxdb容器，然后进行到容器内部配置一个数据库给cadvisor专用，然后再启动cadvisor容器，容器启动的时候指定把数据存储到influxdb中，最后启动grafana容器，在展示页面里配置grafana的数据源为influxdb，再定制要展示的数据，一个简单的跨多主机的监控系统就构建成功了。下图为Grafana的界面：

![](/assets/Grafana_CAdvisor.png)  


