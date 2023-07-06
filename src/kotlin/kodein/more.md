# 更多示例

此为选择性汉化文档，现仅供自己参考使用。

## 各种绑定

### 使用tag进行绑定

---

所有的绑定都可以有一个tag，允许你使用相同绑定类型绑定不同实例。

*示例：不同的绑定：*

```kotlin
val di = DI {
    bind<Dice> {...}
    bind<Dice>(tag = "DnD10") {...}
    bind<Dice>(tag = "DnD20") {...}
}

```

> 标签类型为any，不一定为String
>
> 在定义、注入、还是检索的时候，如果声明了tag，那么tag都应该作为命名参数进行传递。
>

### 生产者绑定

---

会提供一个生产者方法给提供者函数，该函数不接受参数并返回创造后的实例。

*示例：每次在注入的时候，都会构建一个新的对象：*

```kotlin
val di = DI{
    bind<Dice> { provider { RandomDice(6) } }
}
```

### 单例绑定

---

会提供一个类型绑定到这种类型的实例，该实例将会在首次使用的时候调用该函数进行创建。
因此，提供的函数将会只调用一次：第一次需要实例。

*示例：创建一个DataSource单例，该单例将会在首次访问的时候进行初始化。

```kotlin

val di = DI{
    bind<DataSource> {singleton { SqliteDS.open("path/to/file")} }
}

```

### 非同步单例

---

依据定义，单例只能有一个实例，为了实现它，DI将会使用互斥锁进行实例的构建。如果你为了提高启动性能，你最好关闭同步的风险。

```kotlin
val di = DI {
    bind<DataSource> { singleton(sync=false) {SqliteDS.open("path/to/file") } }
}
```

使用了`sync = false`将会意味着：

- 可能会有多个线程同时构建
- 构建出了多个实例

### 立即构建的单例

---

这与常规单例相同，不同的是一旦创建了DI实例并且定义了所有绑定后，将立即调用提供的函数。

*示例：创建一个DataSource单例，该单例将在绑定块结束的时候立即进行初始化。*

```kotlin
val di = DI {
    bind<DataSource> {eagerSingleton{ SqliteDS.open("path/to/file") } }
}

```

### 工厂构建

---

这将类型绑定到工厂函数，每次需要绑定到类型的实例时，都会调用一次提供函数。

该工厂仅支持一个参数

*示例：根据代表的边数Int，每次需要时创建一个新的骰子：*

```kotlin
val di = DI {
    bind<Dice> {facotry {sides:Int ->RandomDice(sides) } }
}
```

> 如果每次都是相同的结果，可以使用`bindFactory<Int,Dice> { RandomDice(it) }`

### 多参数工厂

---

可以使用数据类进行多参数的传递

*示例：使用数据类进行参数的传递:*

```kotlin
data class DiceParams(val startNumber:Int,val sides:Int)

val di = DI{
    bind<Dice> { factory {params:DiceParams->RandomDice(params) } }
} 
```

使用数据类传递这些参数不会导致内存浪费，也不会导致不优雅，尽情使用吧。（只要没有对象将其引用起来，它就会因为缺乏引用而被jvm自动干掉）

### 缓存实例构建工厂

---

这可以被认为是单例工厂的一种不同参数版本，它能够保证给予相同参数的时候始终返回相同的对象。换句话说，对于第一次调用参数获取对象时，它将调用函数进行实例的创建，当使用相同的参数进行调用时，将始终产生相同的实例。

*示例：为每个值创建一个随机生成器：*

```kotlin
val di = DI{
    bind<RandomGenerator> { multiton {max:Int->SecureRandomGenerator(max)} }
}
```

>可简化为`bindMultiton`方法，第一个泛型是参数，第二个泛型是生成类型。

### 非同步缓存实例构建工厂

---

就如同单例一样，可以禁用同步：

*示例：禁用同步：*

```kotlin
val di = DI{
    bind<RandomGenerator> { multiton(sync=false) {max:Int->SecureRandomGenerator(max)} }
}
```

>`bindMultiton`函数也可以控制sync选项。

### 软引用和弱引用

这些对象在jvm中不能保证其一直存在，如果没有多个引用，则会被CG干掉，然后重新创建。
因此，在程序的声明周期中，提供的函数可能会多次调用，也可能不会多次调用。

#### [软引用](../../java/ref/learn.md#软引用)

*示例：创建一个给定时间仅存在一次的缓存对象：软引用：*

```kotlin
val di = DI {
    bind<Map> { singleton(ref = softReference) { WorldMap() } }
}

```

#### [弱引用](../../java/ref/learn.md#弱引用)

*示例：创建一个给定时间仅存在一次的缓存对象：虚引用：*

```kotlin
val di = DI {
    bind<Map> { singleton(ref = weakReference) { WorldMap() } }
}
```

#### ThreadLocal

这与标准的单例绑定相同，只是每个线程能够获取到独属于自己的实例。因此在第一次请求实例时，每个需要实例的线程将调用一次函数进行创建。

*示例：创建一个缓存对象，每个线程都有一个：*

```kotlin
    bind<Cache> { singleton(ref = threadLocal) { LRUCache(16*1024) } }

```

### 绑定常量

绑定常量通常可以用来当作配置

*示例：创建两个常量绑定：*

```kotlin
val di = DI{
    bindConstant(tag="port") {8080}
    bindConstant(tag="password") {"1234567890"}
}
```

### 引用与参考

[依赖项目的声明](https://kosi-libs.org/kodein/7.19/core/bindings.html)

[引用类型](../../java/ref/learn.md)
