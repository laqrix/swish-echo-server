## Swish Echo Server Example

This example strives to incrementally demonstrate building an echo
server with Swish.

Each code file can be run via `swish -- filname.ss`, then connect to
it using `nc localhost 5300` typing input as desired. Use `^C` to
shutdown.

| Example | Shows how to |
|---------|--------------|
|[echo1](echo1.ss)| use the low-level API to send a constant string over a single TCP connection and close. This is not really an echo server, but it is starting from this [issue](https://github.com/becls/swish/issues/118). |
|[echo2](echo2.ss)| spawn a separate process to read and write data allowing multiple connections. |
|[echo3](echo3.ss)| use a gen-server to handle asynchronous input. This keeps the input port and output port separate so we can perform a blocking `get-bytevector-some` call without affecting the write side of the connection. |
|[echo4](echo4.ss)| use a gen-server to maintain a named server. This upgrades the processing loop, but starts the server directly. |
|[echo5](echo5.ss)| use supervision tree to get benefits of logging. This upgrades the startup to use the application and logging subsystems. You can find the log in data/Log.db3 |
