Elasticsearch is an open source search engine known for its ease of use. Kibana is an open source Web UI that makes Elasticsearch user friendly for marketers, engineers and data scientists alike.

By combining these three tools EFK \(Elasticsearch + Fluentd + Kibana\) we get a scalable, flexible, easy to use log collection and analytics pipeline. In this article, we will set up 4 containers, each includes:

* [Apache HTTP Server](https://hub.docker.com/_/httpd/)
* [Fluentd](https://hub.docker.com/r/fluent/fluentd/)
* [Elasticsearch](https://hub.docker.com/_/elasticsearch/)
* [Kibana](https://hub.docker.com/_/kibana/)

All of `httpd`’s logs will be ingested into Elasticsearch + Kibana, via Fluentd.

## Step 0: prepare docker-compose.yml

First, please prepare docker-compose.yml for Docker Compose. Docker Compose is a tool for defining and running multi-container Docker applications.

With the YAML file below, you can create and start all the services \(in this case, Apache, Fluentd, Elasticsearch, Kibana\) by one command.

```
version: '2'
services:
  web:
    image: httpd
    ports:
      - "80:80"
    links:
      - fluentd
    logging:
      driver: "fluentd"
      options:
        fluentd-address: localhost:24224
        tag: httpd.access

  fluentd:
    build: ./fluentd
    volumes:
      - ./fluentd/conf:/fluentd/etc
    links:
      - "elasticsearch"
    ports:
      - "24224:24224"
      - "24224:24224/udp"

  elasticsearch:
    image: elasticsearch
    expose:
      - 9200
    ports:
      - "9200:9200"

  kibana:
    image: kibana
    links:
      - "elasticsearch"
    ports:
      - "5601:5601"
```

`logging`section \(check [Docker Compose documentation](https://docs.docker.com/compose/compose-file/#/logging) \) of`web`container specifies [Docker Fluentd Logging Driver](https://docs.docker.com/engine/admin/logging/fluentd/) as a default  container logging driver. All of the logs from`web`container will be automatically forwarded to host:port specified by`fluentd-address`.

.



