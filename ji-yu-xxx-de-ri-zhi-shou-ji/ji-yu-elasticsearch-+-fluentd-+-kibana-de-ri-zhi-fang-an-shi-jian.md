Elasticsearch is an open source search engine known for its ease of use. Kibana is an open source Web UI that makes Elasticsearch user friendly for marketers, engineers and data scientists alike.

By combining these three tools EFK \(Elasticsearch + Fluentd + Kibana\) we get a scalable, flexible, easy to use log collection and analytics pipeline. In this article, we will set up 4 containers, each includes:

* [Apache HTTP Server](https://hub.docker.com/_/httpd/)
* [Fluentd](https://hub.docker.com/r/fluent/fluentd/)
* [Elasticsearch](https://hub.docker.com/_/elasticsearch/)
* [Kibana](https://hub.docker.com/_/kibana/)

All of `httpd`’s logs will be ingested into Elasticsearch + Kibana, via Fluentd.



