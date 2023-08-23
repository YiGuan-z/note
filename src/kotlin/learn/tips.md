# kotlin小技巧

## 得知对象初始化逻辑

假设有这么一段代码。

```kotlin
sealed class Demo{
    init{
        println("init ${javaClass.simpleName} completed")
    }

    companion object{
        val all = listOf(
            Demo1,Demo2,Demo3,Demo4
        ).also{ println("init all completed") }
    }

    object Demo1:Demo()
    object Demo2:Demo()
    object Demo3:Demo()
    object Demo4:Demo()
    
    override fun toString():String{
        return javaClass.simpleName
    }
}

fun main(){
    val demo = Demo.Demo2
    println(demo)
    println(Demo.all)
}
/*
init Demo1 completed
init Demo3 completed
init Demo4 completed
init all completed
init Demo2 completed
Demo2
[Demo1, null, Demo3, Demo4]
*/
```

你仔细看了看逻辑，再看看输出，大为震撼，你想得知这一切究竟是怎么发送的，但是你脑海你一头雾水，这时候，我们就可以在对象创建时往初始化函数中写入一个异常并打印，我们就可以看到函数调用栈，便能够对调用过程进行反推。

放入一个异常到Demo1的初始化函数中。
```kotlin
object Demo1:Demo(){
    init {
        RuntimeException().printStackTrace()
    }
}
```

```log
java.lang.RuntimeException
	at com.example.Demo$Demo1.<clinit>(Question.kt:23)
	at com.example.Demo.<clinit>(Question.kt:17)
	at com.example.QuestionKt.main(Question.kt:34)
	at com.example.QuestionKt.main(Question.kt)
```

运行后我们就可以发现，Demo1的上一帧在伴生对象中的属性初始化中。

根据伴生对象的初始化规则，它会在第一次访问的时候立即进行初始化，所以我们有着以下线索：

初始化顺序为1、3、4、all、2

初始化完成后立即打印了demo2

demo的伴生对象中的all属性中，2为空。

我们只使用了demo2

由此我们可以大胆假设，首先没有初始化demo的伴生对象，而是先去初始化demo2去了，demo2有着父类构造访问了demo，触发了demo的伴生对象的初始化，对demo1、3、4进行初始化。

因为object关键字在kotlin中只能被初始化一次，而这次初始化又正在进行中，所以获得了空指针。在伴生对象初始化完毕后，我们的demo2也初始化完毕了。接着就是打印demo变量和打印Demo的伴生对象中的属性all了。
