# 完整代码

```kotlin
package com.cqsd.chat

import io.ktor.server.application.*
import io.ktor.server.engine.*
import io.ktor.server.netty.*
import io.ktor.server.plugins.callloging.*
import io.ktor.server.plugins.defaultheaders.*
import io.ktor.server.routing.*
import io.ktor.server.sessions.*
import io.ktor.server.websocket.*
import io.ktor.util.*
import io.ktor.websocket.*
import kotlinx.coroutines.channels.ClosedSendChannelException
import kotlinx.coroutines.channels.consumeEach
import java.time.Duration
import java.util.*
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.CopyOnWriteArrayList
import java.util.concurrent.atomic.AtomicInteger

/**
 * @author caseycheng
 * @date 2023/7/4 16:19
 * @doc ktor的启动方法
 */
fun main() {
    embeddedServer(Netty, port = 8080) {
        ChatApplication().apply { configure() }
    }.start(wait = true)
}

class ChatApplication {
    private val server = ChatServer()
    fun Application.configure() {
        install(DefaultHeaders)
        install(CallLogging)
        install(WebSockets) {
            pingPeriod = Duration.ofMinutes(1)
        }
        install(Sessions) {
            cookie<ChatSession>("session")
        }
        intercept(ApplicationCallPipeline.Plugins) {
            if (call.sessions.get<ChatSession>() == null) {
                call.sessions.set(ChatSession(generateNonce()))
            }
        }
        routing {
            configureWS()
        }
    }

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
                        receivedMessage(session.id, frame.readText())
                    }
                }
            } finally {
                server.memberLeft(session.id, this)
            }

        }
    }

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
                            if (entry.value == name) {
                                val recipient = entry.key
                                val message = cmd.toList().subList(1, cmd.size - 1).joinToString { " " }
                                server.sendTo(recipient, server.memberNames[id]!!, message)
                            }
                        }
                        server.sendTo(id, "server::help", "No user found")
                    }
                }
            }

            else -> server.message(id, command)
        }
    }

    data class ChatSession(val id: String)
}

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

    /**
     * 为[member]的用户重命名，并广播消息给全体成员
     */
    suspend fun memberRenamed(member: SessionId, to: String) {
        val oldName = memberNames.put(member, to) ?: member
        broadcast("server", "Member renamed from $oldName to $to")
    }

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
    suspend fun who(member: SessionId) {
        members[member]?.send(Frame.Text(memberNames.values.joinToString(prefix = "[server::who] ")))
    }

    /**
     * 向服务器请求帮助
     */
    suspend fun help(member: SessionId) {
        members[member]?.send(Frame.Text("[server::help] Possible commands are: /user, /help , /who , /count"))
    }

    /**
     * 私聊方法
     * @param recipient 收件人
     * @param sender 发件人
     * @param message 消息
     */
    suspend fun sendTo(recipient: SessionId, sender: SessionId, message: Message) {
        members[recipient]?.send(Frame.Text("[$sender] $message"))
    }

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

}

```
