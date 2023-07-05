# 关于在jvm上修改字符串缓存

## 开始

今天群里聊天的时候，不知怎的就聊到了String的不可变性，突然啊，就开始思考击破字符串不可变性的方法，有人提议修改字节码，有人提议魔改jdk，最终有一位动手能力满分的群友给出了如下代码。

```kotlin
@JvmField val a="a"

fun main(){
    val valueField = String::class.java.getDeclaredField("value")
    valueField.isAccessible=true

    valueField.set(a,byteArrayOf('b'.toByte()))

    println(a)
    println("a")
}
```

最终的输出结果为两个b。

## 尝试

由此可见，jvm里由硬编码创建的字符串也遭到了更改（硬编码字符串是不会改变的，这个方法改变的是由硬编码字符串构建出来的字符串对象）。

我见此立马跟着仿写了一遍，点击运行，报错！，再运行，还是报错！

```kotlin
fun main(){
    val s = "a"
    val version = System.getProperty("java.version")
    println("current java version: $version")

    val field = String::class.java.getDeclaredField("value")
                .apply { this.isAccessible = true }

    println(s)
    field.set(s, byteArrayOf('b'.toByte()))

    println(s)
    println("a")
}
```

见此情景我不得不看一看报错内容。

`
Unable to make field private final byte[] java.lang.String.value accessible: module java.base does not "opens java.lang" to unnamed module @1a451d4d
`

翻译：

`
无法使字段私有最终字节[] java.lang.String.value可访问：模块java.base没有“打开java.lang”到未命名模块@1a451d4d
`

脑海里闪过一丝不对劲，将这段报错内容发了出去，很快我就得到了群友使用newBing的回答。

>这个错误通常出现在尝试使用反射访问模块化JDK（Java9及其以上版本）中的某些私有类成员时。在模块化JDK中，模块之间的访问是受限的，除非模块显式地打开了对其它模块的访问权限。在这种情况之下，`java.base`模块没有打开`java.lang`包的访问权限，因此无法反射访问`java.lang.String.value`字段。
>
>要解决这个问题，可以添加JVM参数 `--add-opens`来打开模块之间的访问权限。例如，可以使用一下命令来运行程序：
>
>`java --add-opens java.base/java.lang=ALL-UNNAMED -jar myprogram.jar`
>
>这将允许未命名模块访问`java.base`模块中`java.lang`包的所有成员。
>
>另外，也可以考虑使用更低版本的jdk来运行程序，因为Java8及一下版本中不存在模块化限制。

看完这个回答，我就陷入了思索，因为我没有Java8，很快就选择了Java17（之前的报错为Java20），还是报错，切换到Java11，没有报错，但是有警告⚠️。

## 上头

同时，又有一位动手能力强的使用了unsafe进行修改，这是Java反射底层的逻辑支持库。同时，我也想知道unsafe在高版本Java上会不会被限制，于是我改造了我的代码。

```kotlin
val unsafe = Unsafe::class.java.getDeclaredField("theUnsafe")
            .apply { isAccessible = true }.get(null) as Unsafe
val version = System.getProperty("java.version")
println("current java version: $version")

val field = String::class.java.getDeclaredField("value").apply { this.isAccessible = true }

println(s)
val addr = unsafe.objectFieldOffset(field)
unsafe.putObject(s, addr, byteArrayOf('b'.toByte()))

println(s)
println("a")

```

以下是运行情况

| jdk11 | jdk17 | jdk20 |
| :---: | :---: | :---: |
|   ⚠️   |   ❌   |   ❌   |

unsafe在高版本jdk上被已限制。

## 总结

- 在jdk11以下，运行修改常量池里的对象是可行的，在jdk17及以上则会被限制，添加jvm参数也没什么意义。
- unsafe在jdk17也被限制了。
- 字符串分为两种，一种是硬编码的字符串，一种是存在于内存中的字符串。记得有一道面试题，问的就是`new String("a")`会创建几个对象？
  - 如果在之前使用了`"a"`则创建一个对象。
  - 如果在此之前没有使用`"a"`则会创建两个对象。
  - 硬编码的字符串想要可用也得进行创建，所以硬编码只会被运行一次，之后都使用的由它创建的字符串对象。
- 没事别玩这个，它严重破坏了字符串的安全性。
