# go语言小技巧

## 接口检查

```go
var _ io.Writer = (*TCPWriter)(nil)

type TCPWriter struct {
	Config TCPWriterConfig

	stopRunning chan bool
	pending     chan *tcpMessageToSend
	wg          sync.WaitGroup

	muconn sync.Mutex
	conn   net.Conn
}
```

这段代码将nil转换为*TcpWriter再赋值给 io.Writer类型，如果赋值失败，则接口就未实现，编译器将会报错。
