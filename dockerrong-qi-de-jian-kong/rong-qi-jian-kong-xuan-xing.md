The number of monitoring solutions is daunting. New solutions are coming on the scene continuously, and existing solutions evolve in functionality. Rather than looking at each solution in depth, I’ve taken the approach of drawing high-level comparisons. With this approach, readers can hopefully “narrow the list” and do more serious evaluations of solutions best suited to their own needs.

The monitoring solutions covered here include:

* [Native Docker](https://docs.docker.com/engine/reference/commandline/stats/)
* [cAdvisor](https://github.com/google/cadvisor)
* [Scout](http://scoutapp.com/)
* [Pingdom](https://pingdom.com/)
* [Datadog](https://www.datadoghq.com/)
* [Sysdig](https://sysdig.com/)
* [Prometheus](https://prometheus.io/)
* [Heapster / Grafana](https://github.com/kubernetes/heapster)
* [ELK stack](https://www.elastic.co/)
* [Sensu](http://sensuapp.org/)

In the following sections, I suggest a framework for comparing monitoring solutions, present a high-level comparison of each, and then discuss each solution in more detail by addressing how each solution works with Rancher. I also cover a few additional solutions you may have come across that did not make my top 10.

# A Framework for Comparison

A challenge with objectively comparing monitoring solutions is that architectures, capabilities, deployment models, and costs can vary widely. One solution may extract and graph Docker-related metrics from a single host while another aggregates data from many hosts, measures application response times, and sends automated alerts under particular conditions.

Having a framework is useful when comparing solutions. I’ve somewhat arbitrarily proposed the following tiers of functionality that most monitoring solutions have in common as a basis for my comparison. Like any self-respecting architectural stack, this one has seven layers.

![](/assets/A seven-layer model for comparing monitoring solutions.png)

* **Host Agents **– The host agent represents the “arms and legs” of the monitoring solution, extracting time-series data from various sources like APIs and log files. Agents are usually installed on each cluster host \(either on-premises or cloud-resident\) and are themselves often packaged as Docker containers for ease of deployment and management.
* **Data gathering framework **– While single-host metrics are sometimes useful, administrators likely need a consolidated view of all hosts and applications. Monitoring solutions typically have some mechanism to gather data from each host and persist it in a shared data store.
* **Datastore **– The datastore may be a traditional database, but more commonly it is some form of scalable, distributed database optimized for time-series data comprised of key-value pairs. Some solutions have native datastores while others leverage pluggable open-source datastores.
* **Aggregation engine **– The problem with storing raw metrics from dozens of hosts is that the amount of data can become overwhelming. Monitoring frameworks often provide data aggregation capabilities, periodically crunching raw data into consolidated metrics \(like hourly or daily summaries\), purging old data that is no longer needed, or re-factoring data in some fashion to support anticipated queries and analysis.
* **Filtering & Analysis **– A monitoring solution is only as good as the insights you can gain from the data. Filtering and analysis capabilities vary widely. Some solutions support a few pre-packaged queries presented as simple time-series graphs, while others have customizable dashboards, embedded query languages, and sophisticated analytic functions.
* **Visualization tier **– Monitoring tools usually have a visualization tier where users can interact with a web interface to generate charts, formulate queries and, in some cases, define alerting conditions. The visualization tier may be tightly coupled with the filtering and analysis functionality, or it may be separate depending on the solution.
* **Alerting & Notification **– Few administrators have time to sit and monitor graphs all day. Another common feature of monitoring systems is an alerting subsystem that can provide notification if pre-defined thresholds are met or exceeded.

Beyond understanding how each monitoring solution implements the basic capabilities above, users will be interested in other aspects of the monitoring solution as well:

* Completeness of the solution
* Ease of installation and configuration
* Details about the web UI
* Ability to forward alerts to external services
* Level of community support and engagement \(for open-source projects\)
* Availability in Rancher Catalog
* Support for monitoring non-container environments and apps
* Native Kubernetes support \(Pods, Services, Namespaces, etc.\)
* Extensibility \(APIs, other interfaces\)
* Deployment model \(self-hosted, cloud\)
* Cost, if applicable

# Comparing Our 10 Monitoring Solutions

The diagram below shows a high-level view of how our 10 monitoring solutions map to our seven-layer model, which components implement the capabilities at each layer, and where the components reside. Each framework is complicated, and this is a simplification to be sure, but it provides a useful view of which component does what. Read on for additional detail.

![](/assets/10 monitoring solutions at a glance.png)

Additional attributes of each monitoring solution are presented in a summary fashion below. For some solutions, there are multiple deployment options, so the comparisons become a little more nuanced.

![](/assets/Additional attributes of each monitoring solution.png)

# Looking at Each Solution in More Depth

### DOCKER STATS

[https://www.docker.com/docker-community](https://www.docker.com/docker-community)

At the most basic level, Docker provides built-in command monitoring for Docker hosts via the[`docker stats`](https://docs.docker.com/engine/reference/commandline/stats/)command. Administrators can query the Docker daemon and obtain detailed, real-time information about container resource consumption metrics, including CPU and memory usage, disk and network I/O, and the number of running processes. Docker stats leverages the [Docker Engine API](https://docs.docker.com/engine/api/) to retrieve this information. Docker stats has no notion of history, and it can only monitor a single host, but clever administrators can write scripts to gather metrics from multiple hosts.

Docker stats is of limited use on its own, but`docker stats`data can be combined with other data sources like [Docker log files](https://docs.docker.com/engine/reference/commandline/logs/) and[`docker events`](https://docs.docker.com/engine/reference/commandline/events/)to feed higher level monitoring services. Docker only knows about metrics reported by a single host, so Docker stats is of limited use monitoring Kubernetes or Swarm clusters with multi-host application services. With no visualization interface, no aggregation, no datastore, and no ability to collect data from multiple hosts, Docker stats does not fare well against our seven-layer model. Because [Rancher](http://rancher.com/) runs on Docker, basic`docker stats`functionality is automatically available to Rancher users.

### CADVISOR

[https://github.com/google/cadvisor](https://github.com/google/cadvisor)

cAdvisor \(container advisor\) is an [open-source project](https://github.com/google/cadvisor) that like Docker stats provides users with resource usage information about running containers. cAdvisor was originally developed by Google to manage its [lmctfy](https://en.wikipedia.org/wiki/Lmctfy) containers, but it now supports Docker as well. It is implemented as a daemon process that collects, aggregates, processes, and exports information about running containers.

cAdvisor exposes a web interface and can generate multiple graphs but, like Docker stats, it monitors only a single Docker host. It can be installed on a Docker machine either as a container or natively on the Docker host itself.

cAdvisor itself only retains information for 60 seconds. cAdvisor needs to be configured to log data to an external datastore. Datastores commonly used with cAdvisor data include [Prometheus](https://prometheus.io/) and [InfluxDB](https://github.com/influxdata/influxdb). While cAdvisor itself is not a complete monitoring solution, it is often a component of other monitoring solutions. Before Rancher version 1.2 \(late December\), Rancher embedded cAdvisor in the`rancher-agent`\(for internal use by Rancher\), but this is no longer the case. More recent versions of Rancher use Docker stats to gather information exposed through the Rancher UI because they can do so with less overhead.

Administrators can easily deploy cAdvisor on Rancher, and it is part of several comprehensive monitoring stacks, but cAdvisor is no longer part of Rancher itself.

### SCOUT

[http://scoutapp.com](http://scoutapp.com/)

[Scout](http://scoutapp.com/) is a Colorado-based company that provides a cloud-based application and database-monitoring service aimed mainly at Ruby and Elixir environments. One of many use cases it supports is monitoring Docker containers leveraging its existing monitoring and alerting framework.

We mention Scout because it was covered in previous comparisons as a solution for monitoring Docker. Scout provides comprehensive data gathering, filtering, and monitoring functionality with flexible alerts and integrations to third-party alerting services.

The team at Scout provides guidance on how to write scripts using Ruby and [StatsD](https://github.com/etsy/statsd/wiki) to tap the [Docker Stats API](http://blog.scoutapp.com/articles/2015/06/22/monitoring-docker-containers-from-scratch) \(above\), the Docker Event API, and relay metrics to Scout for monitoring.  They’ve also packaged a`docker-scout`container, available on Docker Hub \([`scoutapp/docker-scout`](https://hub.docker.com/r/scoutapp/docker-scout/)\), that makes installing and configuring the scout agent simple. The ease of use will depend on whether users configure the StatsD agent themselves or leverage the packaged`docker-scout`container.

As a hosted cloud service, ScoutApp can save a lot of headaches when it comes to getting a container-monitoring solution up and running quickly. If you’re deploying Ruby apps or running the database environments supported by Scout, it probably makes good sense to consolidate your Docker, application, and database-level monitoring and use the Scout solution.

Users might want to watch out for a few things, however. At most service levels, the platform only allows for 30 days of data retention, and rather than being priced month per monitored host, standard packages are priced per transaction ranging from $99 to $299 per month. The solution out of the box is not Kubernetes-aware, and extracts and relays a limited set of metrics. Also, while`docker-scout`is available on Docker Hub, development is by Pingdom, and there have been only minor updates in the last two years to the agent component.

Scout is not natively supported in Rancher but, because it is a cloud service, it is easy to deploy and use, particularly when the container-based agent is used. At present, the`docker-scout`agent is not in the Rancher Catalog.

  




