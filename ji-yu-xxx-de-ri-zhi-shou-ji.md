# Fluentd Architecture Overview

Fluentd is an open source log collector, which lets you unify the data collection and consumption for a better use and understanding of data.

Fluentd treats logs as JSON, a popular machine-readable format. It is written primarily in C with a thin-Ruby wrapper that gives users flexibility.

Fluentd’s scalability has been proven in the field: its largest user currently collects logs from 500,000+ servers.

Fluentd是一个免费，而且完全开源的日志管理工具，简化了日志的收集、处理、和存储，你可以不需要再维护编写特殊的日志处理脚本。Fluentd的性能已经在各领域得到了证明：目前最大的用户从5000+服务器收集日志，每天5TB的数据量，在高峰时间处理50,000条信息每秒。

**Before Fluentd：**

![](/assets/Before Fluentd.png)

**After Fluentd：**

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

Fluentd supports memory and file-based buffering to prevent inter-node data loss. Fluentd also support robust failover and can be set up for high availability. [2,000+ data-driven companies](https://www.fluentd.org/testimonials) rely on Fluentd to differentiate their products and services through a better use and understanding of their log data.

![](/assets/Built-in Reliability.png)

# Life of a Fluentd event

The following content describe a global overview of how events are processed by Fluentd using examples. It covers the complete cycle including Setup, Inputs, Filters, Matches and Labels.

### Basic Setup

The configuration files is the fundamental piece to connect all things together, as it allows to define which _Inputs or listeners _[_Fluentd_](http://fluentd.org/)_ will have and set up common matching rules to route the  Event  data to a specific  Output_.

We will use the [in\_http](https://docs.fluentd.org/v0.12/articles/in_http) and the [out\_stdout](https://docs.fluentd.org/v0.12/articles/out_stdout) plugins as examples to describe the events cycle. The following is a basic definition on the configuration file to specify an http input, for short: we will be listening for **HTTP Requests**:

```
<source>
  @type http
  port 8888
  bind 0.0.0.0
</source>
```

This definition specifies that a HTTP server will be listening on TCP port 8888. Now let’s define a  \_Matching  \_rule and a desired output that will just print the data that arrived on each incoming request to standard output:

```
<match test.cycle>
  @type stdout
</match>
```

The _Match \_directive sets a rule that matches each \_Incoming \_event that arrives with a **Tag **equal to_ test.cycle _will use the \_Output \_plugin type called \_stdout_. At this point we have an _Input \_type, a \_Match \_and an \_Output_. Let’s test the setup using _curl_:

```
$ curl -i -X POST -d 'json={"action":"login","user":2}' http://localhost:9880/test.cycle
HTTP/1.1 200 OK
Content-type: text/plain
Connection: Keep-Alive
Content-length: 0
```

On the Fluentd server side the output should look like this:

```
$ bin/fluentd -c in_http.conf
2015-01-19 12:37:41 -0600 [info]: reading config file path="in_http.conf"
2015-01-19 12:37:41 -0600 [info]: starting fluentd-0.12.3
2015-01-19 12:37:41 -0600 [info]: using configuration file: <ROOT>
  <source>
    @type http
    bind 0.0.0.0
    port 8888
  </source>
  <match test.cycle>
    @type stdout
  </match>
</ROOT>
2015-01-19 12:37:41 -0600 [info]: adding match pattern="test.cycle" type="stdout"
2015-01-19 12:37:41 -0600 [info]: adding source type="http"
2015-01-19 12:39:57 -0600 test.cycle: {"action":"login","user":2}
```

### Event structure

A Fluentd event consists of a tag, time and record.

* tag: Where an event comes from. For message routing
* time: When an event happens. Epoch time
* record: Actual log content. JSON object

The input plugin is responsible for generating Fluentd events from specified data sources.  
For example,`in_tail`generates events from text lines. If you have the following line in apache logs:

```
192.168.0.1 - - [28/Feb/2013:12:00:00 +0900] "GET / HTTP/1.1" 200 777
```

the following event is generated:

```
tag: apache.access # set by configuration
time: 1362020400   # 28/Feb/2013:12:00:00 +0900
record: {"user":"-","method":"GET","code":200,"size":777,"host":"192.168.0.1","path":"/"}
```

### Processing Events

When a Setup is defined, the Router Engine already contains several rules to apply for different input data. Internally an Event will pass through a chain of procedures that may alter the Events cycle.

Now we will expand the previous basic example and add more steps in our Setup to demonstrate how the Events cycle can be altered. We will do this through the new Filters implementation.

#### Filters

---

A \_Filter \_aims to behave like a rule to either accept or reject an event. The following configuration adds a \_Filter \_definition:

```
<source>
  @type http
  port 8888
  bind 0.0.0.0
</source>

<filter test.cycle>
  @type grep
  exclude1 action logout
</filter>

<match test.cycle>
  @type stdout
</match>
```

As you can see, the new Filter definition added will be a mandatory step before passing control to the Match section. The Filter basically accepts or rejects the Event based on it type and the defined rule. For our example we want to discard any user `logout`action, we only care about the `login`action. The way this is accomplished is by the Filter doing a `grep`that will exclude any message where the `action`key has the string value “logout”.

From a Terminal, run the following two `curl`commands \(please note that each one contains a different `action`value\):

```
$ curl -i -X POST -d 'json={"action":"login","user":2}' http://localhost:8880/test.cycle
HTTP/1.1 200 OK
Content-type: text/plain
Connection: Keep-Alive
Content-length: 0

$ curl -i -X POST -d 'json={"action":"logout","user":2}' http://localhost:8880/test.cycle
HTTP/1.1 200 OK
Content-type: text/plain
Connection: Keep-Alive
Content-length: 0
```

Now looking at the Fluentd service output we can see that only the event with `action`equal to “login” is matched. The `logout`Event was discarded:

## 参考

Docker Logging via EFK \(Elasticsearch + Fluentd + Kibana\) Stack with Docker Compose  
：[https://docs.fluentd.org/v0.12/articles/docker-logging-efk-compose](https://docs.fluentd.org/v0.12/articles/docker-logging-efk-compose)

Docker Logging Driver and Fluentd：[https://docs.fluentd.org/v0.12/articles/docker-logging](https://docs.fluentd.org/v0.12/articles/docker-logging)

Docker Logging：[https://www.fluentd.org/guides/recipes/docker-logging](https://www.fluentd.org/guides/recipes/docker-logging)

What is Fluentd?：[https://www.fluentd.org/architecture](https://www.fluentd.org/architecture)

Why Use Fluentd?：[https://www.fluentd.org/why](https://www.fluentd.org/why)

Unified Logging Layer: Turning Data into Action：[https://www.fluentd.org/blog/unified-logging-layer](https://www.fluentd.org/blog/unified-logging-layer)

Quickstart Guide：[https://docs.fluentd.org/v0.12/articles/quickstart](https://docs.fluentd.org/v0.12/articles/quickstart)

kubernetes Logging Architecture：[https://kubernetes.io/docs/concepts/cluster-ad](https://kubernetes.io/docs/concepts/cluster-ad)

