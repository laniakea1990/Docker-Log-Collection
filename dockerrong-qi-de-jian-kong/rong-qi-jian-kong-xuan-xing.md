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



* **Host Agents **– The host agent represents the “arms and legs” of the monitoring solution, extracting time-series data from various sources like APIs and log files. Agents are usually installed on each cluster host \(either on-premises or cloud-resident\) and are themselves often packaged as Docker containers for ease of deployment and management.
* **Data gathering framework **– While single-host metrics are sometimes useful, administrators likely need a consolidated view of all hosts and applications. Monitoring solutions typically have some mechanism to gather data from each host and persist it in a shared data store.
* **Datastore **– The datastore may be a traditional database, but more commonly it is some form of scalable, distributed database optimized for time-series data comprised of key-value pairs. Some solutions have native datastores while others leverage pluggable open-source datastores.
* **Aggregation engine **– The problem with storing raw metrics from dozens of hosts is that the amount of data can become overwhelming. Monitoring frameworks often provide data aggregation capabilities, periodically crunching raw data into consolidated metrics \(like hourly or daily summaries\), purging old data that is no longer needed, or re-factoring data in some fashion to support anticipated queries and analysis.
* **Filtering & Analysis **– A monitoring solution is only as good as the insights you can gain from the data. Filtering and analysis capabilities vary widely. Some solutions support a few pre-packaged queries presented as simple time-series graphs, while others have customizable dashboards, embedded query languages, and sophisticated analytic functions.
* **Visualization tier **– Monitoring tools usually have a visualization tier where users can interact with a web interface to generate charts, formulate queries and, in some cases, define alerting conditions. The visualization tier may be tightly coupled with the filtering and analysis functionality, or it may be separate depending on the solution.
* **Alerting & Notification **– Few administrators have time to sit and monitor graphs all day. Another common feature of monitoring systems is an alerting subsystem that can provide notification if pre-defined thresholds are met or exceeded.

  
  


# 



