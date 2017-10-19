The`fluentd`logging driver sends container logs to the[Fluentd](http://www.fluentd.org/)collector as structured log data. Then, users can use any of the[various output plugins of Fluentd](http://www.fluentd.org/plugins)to write these logs to various destinations.

In addition to the log message itself, the`fluentd`log driver sends the following metadata in the structured log message:

|  | Description |
| :--- | :--- |
| `container_id` | The full 64-character container ID. |
| `container_name` | The container name at the time it was started. If you use`docker rename`to rename a container, the new name is not reflected in the journal entries. |
| `source` | `stdout`or`stderr` |



