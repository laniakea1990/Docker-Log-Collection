The`journald`logging driver sends container logs to the[`systemd`journal](http://www.freedesktop.org/software/systemd/man/systemd-journald.service.html). Log entries can be retrieved using the`journalctl`command, through use of the`journal`API, or using the`docker logs`command.

In addition to the text of the log message itself, the`journald`log driver stores the following metadata in the journal with each message:

| Field | Description |
| :--- | :--- |
| `CONTAINER_ID` | The container ID truncated to 12 characters. |
| `CONTAINER_ID_FULL` | The full 64-character container ID. |
| `CONTAINER_NAME` | The container name at the time it was started. If you use`docker rename`to rename a container, the new name is not reflected in the journal entries. |
| `CONTAINER_TAG` | The container tag \([log tag option documentation](https://docs.docker.com/engine/admin/logging/log_tags/)\). |
| `CONTAINER_PARTIAL_MESSAGE` | A field that flags log integrity. Improve logging of long log lines. |



