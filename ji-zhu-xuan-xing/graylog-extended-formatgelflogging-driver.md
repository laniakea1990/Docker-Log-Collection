The`gelf`logging driver is a convenient format that is understood by a number of tools such as[Graylog](https://www.graylog.org/),[Logstash](https://www.elastic.co/products/logstash), and[Fluentd](http://www.fluentd.org/). Many tools use this format.

In GELF, every log message is a dict with the following fields:

* version
* host \(who sent the message in the first place\)
* timestamp
* short and long version of the message
* any custom fields you configure yourself

## Usage {#usage}

To use the`gelf`driver as the default logging driver, set the`log-driver`and`log-opt`keys to appropriate values in the`daemon.json`file, which is located in`/etc/docker/`on Linux hosts or`C:\ProgramData\docker\config\daemon.json`on Windows Server. For more about configuring Docker using`daemon.json`, see[daemon.json](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file).

The following example sets the log driver to`gelf`and sets the`gelf-address`option.



