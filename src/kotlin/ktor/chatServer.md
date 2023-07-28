# 使用ktor创建一个webSocket聊天服务器

> 本文讲是由官方示例演变而来，为防止官方变动，我fork了一份到我的账号下[仓库链接🔗](https://github.com/YiGuan-z/ktor-samples.git)

官方分了三个根出来，我就简便一点，只对backendMain进行说明，使用[wscat](../../util/wscat.md)对其进行测试。

## 配置ktor启动

在主方法中配置嵌入式服务器

```kotlin
// 这是ktor的运行主方法，有着嵌入式服务和配置式两种。
// 参考链接 https://ktor.io/docs/modules.html
fun main(){
    embeddedServer(Netty, port = 8080) {}.start(wait = true)
}
```

## [需要实现的功能](#再来看看我们打算实现的功能)

   1. 支持用户实时聊天
   2. 支持用户使用一些控制命令
      1. 广播消息
      2. 用户重命名
      3. 检查服务器在线人数
      4. 检查服务器有哪些人在线
      5. 显示命令列表
      6. 私聊功能
   3. 统计有多少用户在线

## 编写主要逻辑

### 编写配置

```kotlin
class ChatApplication {
    fun Application.configure() {
        //用来配置自定义头
        install(DefaultHeaders)
        //用来配置日志系统
        install(CallLogging)
        //配置websocket并将心跳设置为一分钟一次
        install(WebSockets) {
            pingPeriod = Duration.ofMinutes(1)
        }
        //配置会话，会话名为session
        install(Sessions) {
            cookie<ChatSession>("session")
        }
        //配置拦截器，如果发现该用户的会话微空，那么就设置一个会话。
        //generateNonce方法用于生成一个随机数
        intercept(ApplicationCallPipeline.Plugins) {
            if (call.sessions.get<ChatSession>() == null) {
                call.sessions.set(ChatSession(generateNonce()))
            }
        }
        //开始对路由进行配置
        routing {
            configureWS()
        }
    }
    //在这里对websocket路由进行配置
    private fun Route.configureWS() {
        
    }
    //这是用来存储会话id的数据类
    data class ChatSession(val id: String)
}
```

### 配置websocket的主要逻辑

```kotlin
private fun Route.configureWS() {
        webSocket("/ws") {
            val session = call.sessions.get<ChatSession>()

            if (session==null){
                //检查用户是否有会话来进行标记，如果没有，就关闭链接。
                //并返回错误，虽然我们之前配置了拦截器对用户会话进行生成
                //但是这种判断是必不可少的。
                close(CloseReason(CloseReason.Codes.VIOLATED_POLICY, "No session"))
                return@webSocket
            }
            //在这里对传入的数据帧进行判断
            //如果是文本类型我们才开始处理

            //TODO在这里处理连接加入的情况
            try {
                incoming.consumeEach { frame->
                    if (frame is Frame.Text){
                        //TODO 在这里对连接进行处理
                    }
                }
            }finally {
                //TODO 这里处理连接离开的情况
            }

        }
    }
```

### 编写消息处理器ChatServer

这里使用了别名来对String的不同用法进行区分，全写String也不会怎么样，只会增加理解难度。

```kotlin
typealias SessionId = String
typealias UserName = String
typealias Message = String

class ChatServer {
    /**
    * 用于获取唯一id 
    */
    val userCounter = AtomicInteger()

    /**
    * 将sessionId和用户名关联起来
    */
    val memberNames = ConcurrentHashMap<SessionId, UserName>()

    /**
    * 将会话id和websocket关联起来，因为浏览器窗口可以开很多个，所以是一对多的关系
    */
    val members = ConcurrentHashMap<SessionId, MutableList<WebSocketSession>>()

    /**
    * 历史信息
    */
    val lastMessages = LinkedList<Message>()
}

```

## [再来看看我们打算实现的功能](#需要实现的功能)

- 统计用户在线数量由`ChatServer`的`memberNames`做了
- 用户的控制命令由`ChatServer`的后续方法进行负责
- 支持用户的实时聊天也交由`ChatServer`方法进行负责
  
### 开始实现具体的服务逻辑

#### 首先先编写一个广播消息的方法

为了减少方法的复杂度，使用了一个扩展函数为WebSocketSession类型的列表集体发送消息。

```kotlin
/**
* 给一组链接发送消息
* 发送失败，则报告错误给客户端并关闭链接
*/
private suspend fun MutableList<WebSocketSession>.send(text: Frame.Text) {
    forEach {
        try {
            it.send(text.copy())
        } catch (e: Throwable) {
            try {
                it.close(CloseReason(CloseReason.Codes.PROTOCOL_ERROR, ""))
            } catch (_: ClosedSendChannelException) {
            }
        }
    }
}
```

广播消息的具体逻辑

```kotlin
/**
* 向全体用户广播消息
* @param sender 广播者
* @param message 消息
*/
private suspend fun broadcast(sender: String, message: String) {
    //尝试获取与sessionId对应的用户名，如果没有，那就直接使用它
    val name = memberNames[sender] ?: sender
    broadcast("[$name] $message")
}

/**
* 向全体用户广播消息
* @param message 消息
*/
private suspend fun broadcast(message: String) {
    members.values.forEach { socket ->
        socket.send(Frame.Text(message))
    }
}

/**
* 向每个用户发送消息，[lastMessages]中只保存100条消息，多了就删除。
* @param sender 发送者
* @param message 消息正文
*/
suspend fun message(sender: String, message: Message) {
    val name = memberNames[sender] ?: sender
    val msg = "[$name] $message"
    broadcast(msg)
    synchronized(lastMessages) {
        lastMessages.add(msg)
        if (lastMessages.size > 100) {
            lastMessages.pop()
        }
    }
}

```

其中，message方法才是向外暴露的广播消息方法。

#### 用户重命名的方法实现

为用户进行重命名然后将新名字广播出去

```kotlin
/**
* 为[member]的用户重命名，并广播消息给全体成员
*/
suspend fun memberRenamed(member: SessionId, to: String) {
    val oldName = memberNames.put(member, to) ?: member
    broadcast("server", "Member renamed from $oldName to $to")
}
```

#### 返回服务器在线人数和服务器成员列表

```kotlin
/**
* 服务器在线人员数量统计
* @param member 会话id
*/
suspend fun numberOfMember(member: SessionId) {
    members[member]?.send(Frame.Text("[server::count] $member"))
}
/**
* 向服务器请求人员列表
*/
suspend fun who(member: SessionId){
    members[member]?.send(Frame.Text(memberNames.values.joinToString(prefix = "[server::who] ")))
}
```

#### 返回帮助

```kotlin
/**
* 向服务器请求帮助
*/
suspend fun help(member: SessionId){
    members[member]?.send(Frame.Text("[server::help] Possible commands are: /user, /help , /who , /count"))
}
```

#### 私聊方法

```kotlin
/**
* 私聊方法
* @param recipient 收件人
* @param sender 发件人
* @param message 消息
*/
suspend fun sendTo(recipient: SessionId, sender: SessionId, message: Message) {
    members[recipient]?.send(Frame.Text("[$sender] $message"))
}
```

#### 用户加入和退出的方法

用户加入

```kotlin
/**
* 处理用户链接加入
* @param member 会话id
* @param socket 对应的套接字
*/
suspend fun memberJoin(member: SessionId, socket: WebSocketSession) {
    //给一个会话分配一个默认用户名
    val name = memberNames.computeIfAbsent(member) { "user${userCounter.incrementAndGet()}" }
    //给会话创建连接列表
    //这是个读多写少的场景，所以使用[CopyOnWriteArrayList]进行快速遍历
    val list = members.computeIfAbsent(member) { CopyOnWriteArrayList() }
    list.add(socket)

    if (list.size == 1) {
        broadcast("server", "Member joined: $name.")
    }

    //给历史消息上锁，并拷贝一份出来发送给新人。
    val messages = synchronized(lastMessages) { lastMessages.toList() }
    for (message in messages) {
        socket.send(Frame.Text(message))
    }

}
```

用户退出

```kotlin
/**
* 处理用户的离开逻辑
*/
suspend fun memberLeft(member: SessionId, socket: WebSocketSession) {
    val connections = members[member]
    connections?.remove(socket)
    //列表没有链接的时候通知其它用户xx已离开
    if (connections != null && connections.isEmpty()) {
        val name = memberNames.remove(member) ?: member
        broadcast("server", "Member left: $name.")
    }
}
```

### 继续配置路由

首先，我们在ChatApplication中添加一个成员变量

```kotlin
class ChatApplication{
    private val server = ChatServer()
    //...
}
```

现在，我们已经有了用户加入退出方法和一系列命令处理方法，我们可以回到`configureWS`方法中继续配置了。

```kotlin
private fun Route.configureWS() {
    webSocket("/ws") {
        val session = call.sessions.get<ChatSession>()

        if (session == null) {
            close(CloseReason(CloseReason.Codes.VIOLATED_POLICY, "No session"))
            return@webSocket
        }
        server.memberJoin(session.id, this)
        try {
            incoming.consumeEach { frame ->
                if (frame is Frame.Text) {
                    //TODO
                }
            }
        } finally {
            server.memberLeft(session.id, this)
        }

    }
}
```

两个TODO都被我们解决了，现在还有最后一个TODO，它用来处理我们的服务器交互逻辑。

我们还缺少最后一个交互逻辑，我们定义一个方法receivedMessage，它接收两个参数，一个是session id一个是读取到的帧数据。

我们可以先把TODO替换为`receivedMessage(session.id, frame.readText())`。

在configureWS的下方实现它

```kotlin
private suspend fun receivedMessage(id: String, command: String) {
        when {
            command.startsWith("/who") -> server.who(id)
            command.startsWith("/user") -> {
                val newName = command.removePrefix("/user").trim()
                when {
                    newName.isEmpty() -> server.sendTo(id, "server::help", "/user [newName]")
                    newName.length > 50 -> server.sendTo(
                        id,
                        "server::help",
                        "new name is too long: 50 characters limit"
                    )

                    else -> server.memberRenamed(id, newName)
                }
            }

            command.startsWith("/help") -> server.help(id)
            command.startsWith("/") -> server.sendTo(
                id,
                "server::help",
                "Unknown command ${command.takeWhile { !it.isWhitespace() }}"
            )

            command.startsWith("/send") -> {
                val cmd = command.removePrefix("/send").split(" ")
                when {
                    cmd.size < 2 -> server.sendTo(id, "server::help", "need more param /send [user] [message]")
                    else -> {
                        val name = cmd[0]
                        for (entry in server.memberNames.entries) {
                            if (entry.value==name){
                                val recipient = entry.key
                                val message = cmd.toList().subList(1, cmd.size - 1).joinToString { " " }
                                server.sendTo(recipient,server.memberNames[id]!!,message)
                            }
                        }
                        server.sendTo(id,"server::help","No user found")
                    }
                }
            }

            else -> server.message(id, command)
        }
    }
```

这些方法可以使用一系列扩展函数来进行重构，我就不在这里写了。官方这个其实并没有加上根据用户名来私聊的功能，我暂时不想加一个特别精细的，只能简单粗暴点。

可以说说思路，聊天软件都有对应的好友列表，加入一个数据库，再做一个账号登陆，数据库里存入对应账号的消息队列和对应的好友列表，历史消息在数据库中存储N条，待接收消息N条，在通过id添加好友，就相当于这里使用session来标记的会话，在客户端每次登陆的时候拉取好友列表。

好友列表获取完毕后，客户端构建对应好友消息的时候直接把本地的好友id传过去即可。这个方法是比较复杂，总结一下就是预先把好友id查出来，可以使用这个方案做出最经典的即时通讯。

### 添加到主函数并启动

```kotlin
fun main() {
    embeddedServer(Netty, port = 8080) {
        ChatApplication().apply { configure() }
    }.start(wait = true)
}
```

## 测试

打开终端，输入`wscat -c localhost:8080`开始测试。

如下图所示。

![image](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307281400664.jpg)

## END

[完整代码](code.md)

[Github](https://github.com/YiGuan-z/ktor-chat.git)
