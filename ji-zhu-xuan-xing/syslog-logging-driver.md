The`syslog`logging driver routes logs to a`syslog`server. The`syslog`protocol uses a raw string as the log message and supports a limited set of metadata. The syslog message must be formatted in a specific way to be valid. From a valid message, the receiver can extract the following information:

* **priority**: the logging level, such as`debug`,`warning`,`error`,`info`.
* **timestamp**: when the event occurred.
* **hostname**: where the event happened.
* **facility**: which subsystem logged the message, such as`mail`or`kernel`.
* **process name **and **process ID \(PID\)**: The name and ID of the process that generated the log.

The format is defined in[RFC 5424](https://tools.ietf.org/html/rfc5424)and Docker’s syslog driver implements the[ABNF reference](https://tools.ietf.org/html/rfc5424#section-6)in the following way:

```
                TIMESTAMP SP HOSTNAME SP APP-NAME SP PROCID SP MSGID
                    +          +             +           |        +
                    |          |             |           |        |
                    |          |             |           |        |
       +------------+          +----+        |           +----+   +---------+
       v                            v        v                v             v
2017-04-01T17:41:05.616647+08:00 a.vm {taskid:aa,version:} 1787791 {taskid:aa,version:}
```

## Usage {#usage}

To use the`syslog`driver as the default logging driver, set the`log-driver`and`log-opt`keys to appropriate values in the`daemon.json`file, which is located in`/etc/docker/`on Linux hosts or`C:\ProgramData\docker\config\daemon.json`on Windows Server. For more about configuring Docker using`daemon.json`, see[daemon.json](https://docs.docker.com/engine/reference/commandline/dockerd/#daemon-configuration-file).

The following example sets the log driver to`syslog`and sets the`syslog-address`option.

```
{
  "log-driver": "syslog",
  "log-opts": {
    "syslog-address": "udp://1.2.3.4:1111"
  }
}
```

Restart Docker for the changes to take effect.

> **Note**: The syslog-address supports both UDP and TCP.

You can set the logging driver for a specific container by using the`--log-driver`flag to`docker create`or`docker run`:

```
docker run \
      -–log-driver syslog –-log-opt syslog-address=udp://1.2.3.4:1111 \
      alpine echo hello world
```

## Options {#options}



