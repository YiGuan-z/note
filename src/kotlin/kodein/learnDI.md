# kodein-di

<!-- toc -->
---

[kodein-di](https://kosi-libs.org/kodein/7.19/getting-started.html)是一个kotlin的依赖注入框架，它可以更方便的管理整个应用程序的代码依赖，与Spring不同的是，它是声明式的，通过[DSL语法](https://zhuanlan.zhihu.com/p/110757158)操作。

自7.0版本以来，kodein-DI可以对所有平台使用真泛型，但是仍然可以使用假泛型。
因为jvm有自己的泛型，所以使用真泛型的时候会遇到大量反射操作，所以优化程度较低。但是因为Ioc只会在程序开始的时候启动一次，所以不会是性能瓶颈。

[平台兼容性与通用型](https://kosi-libs.org/kodein/7.19/platform-and-genericity.html)

**本文是官方文档的翻译版本。**

## 安装

添加下列依赖

### Maven

```xml
<dependencies>
    <dependency>
        <groupId>org.kodein.di</groupId>
        <artifactId>kodein-di-jvm</artifactId>
        <version>7.19.0</version>
    </dependency>
</dependencies>
```

### Gradle

添加mavenCentral仓库

```kotlin
buildscript {
    repositories {
        mavenCentral()
    }
}
```

然后添加依赖项

```kotlin

dependencies{
        implementation("org.kodein.di:kodein-di-jvm:7.17.0")
}

```

## 使用

### 创建一个DI

在kodein-DI中，在块中声明一个bind非常简单：

*DI容器的初始化:*

```kotlin
val kodein = DI {
    bindProvider<Random> { SecureRandom() }
    bindSingletion<Database> { SQLiteDatabase() }
}
```

kodein-DI提供了一系列DSL，可以非常轻松地声明绑定。
kodein-DI提供了一系列可以管理实现的绑定：`provider`、`singleton`、`factory`、`multion`、`instance`等。

大多数时候，依赖的接口类型足以识别它。应用程序中只会有一个Database，所以，如果我请求一个Database的时候。我不需要那个Database，只需要这唯一一个Database。

`Random`也是这样。我们只会使用一个`Random`的实现。如果我想要获取`Random`将会每次获取到`SecureRandom`。

但是，有时依赖项的类型不足以识别它。例如，你可能会有多个数据库，对于这种情况kodein-dl允许使用`tag`进行标记绑定，就像这样。

```kotlin
val kodein = DI {
    bindSingleton<Database>(tag = "local") { SQLiteDatabase() }
    bindProvider<Database>(tag = "remote") { DatabaseProxy() }
}
```

### 模块化

在一些大型应用程序时，通常都有不同的模块，有着不同的功能，每个模块可以定义与自己相关联的业务。

Kodein-DI允许定义稍后在DI容器中导入的绑定模块：

*定义一个DI模块：*

```kotlin
val module = DI.Module {
    bindSingleton<Database>(tag = "local") { SQLiteDatabase() }
    bindProvider<Database>(tag = "remote") { DatabaseProxy() }
}
```

*导入一个DI模块：*

```kotlin
val di = DI{
    import(module)
}
```

### 注入和检索

---

#### 容器

所有声明都必须在DI容器的构造函数中。将DI容器视为你要求依赖的粘合剂。无论需要什么依赖，只要在DI容器中有声明，你都可以通过DI容器来获取它。这将一位着您始终需要或得DI对象。有多种方法可以做到这一点：

- 将DI对象作为构造参数传递
- 让DI对象变得静态可用

#### 注入与检索

kodein-DI支持两种不同的方法，允许业务访问其依赖项目：注入和检索。

- 当注入依赖时，该类在构建时提供其依赖项。
- 当检索依赖时，该类负责获取自己的依赖项。

依赖注入更纯粹，因为被注入的类在构建时不会用到DI。然而，它更笨重，而且没有提供很多功能。
相反，依赖检索更容易且功能齐全，但需要class获取DI。

最后，它归结为一个问题： 你需要这个class使用DI吗？  如果你正在构建在多个架构中使用的库，你可以在class中加入DI，如果你正在编写应用程序，大概率不会。

##### 注入

如果你希望类被注入，那么你需要再编写类的时候声明其依赖项：

*示例：*

```kotlin
class Persenter(private val db:Database,private val rnd:Random){
 //...   
}
```

现在，你需要能构建此Presenter类的一个实例。使用Kodein-DI，非常简单：

*示例：创建注入类的对象：*

```kotlin
val presenter by di.newInstance { Presenter(instance(), instance() )}
```

对于`Presentre`构造函数的每个参数，都可以使用`instance()`函数进行依赖传递，Kodein-DI将会传递正确的依赖项目。

##### 检索

使用检索时，该类需要可用，以静态方式或通过参数访问DI实例。在这些示例中，我们将使用参数。

*示例：检索自身需要的依赖项：*

```kotlin
class Presenter(val di:DI){
    private val db:Database by di.instance()
    private val rnd:Random by di.instance()
}
```

这里使用的是`by`关键字进行属性委托，将db委托给`di.instance()`，`di.instance`本身实现了`LazyDelegate`接口，其内部的委托方法又实现了`Lazy`，所以，这部分是惰性求值。

如果不希望惰性求值的话。参照以下示例

```kotlin
val directDI = di.direct
val ds:Datasource = directDI.instance()
val persenter = directDI.newInstance {Persenter(instance(),instance)}
```

如果所有内容都想直接访问的话，可以将di直接定义为DirectDI:

```kotlin
val di = DI.direct{
    /*bindings*/
}

```

##### 过渡性依赖

假设我们想在绑定中声明一个`Provider`。它又自己的依赖性。处理这些依赖实际上非常容易。

如果你在使用注入，你可以以相同方式传递参数：

*示例：用注入绑定一个类：*

```kotlin
val di = DI {
    bindSingleton<Persenter> {Presenter( instance(), instance() )}
}
```

如果正在使用检索，只需要传递di属性

```kotlin
val di = DI {
    bindSingleton<Presenter> { Presenter(di) }
}
```

## 引用与参考

[koden Open Source Initiative](https://kosi-libs.org/kodein/7.19/getting-started.html#core:bindings)

[koden 平台兼容性与通用型](https://kosi-libs.org/kodein/7.19/platform-and-genericity.html)

[dsl介绍](https://zhuanlan.zhihu.com/p/110757158)
