# SpringBoot

Gradle+SpringBoot3生态+Kotlin是真的非常好用，我专门给它写了一个demo，SpringBoot3有一个依赖可以自动使用电脑上存在的docker容器进行自动部署。

并且容器中的端口是随机的，SpringBoot也能检测到这种随机，也就意味着容器的端口问题可以不用担心了。

## validation

由于kotlin本身就对空值有验证，再加上Spring本身也会对空值进行验证，所以不太好逮住抛出的异常，毕竟我们不可能在一个由编译器确定是不会空的成员属性上面添加上`@NotNull`注解，这光是看着就令人费解。

所以只好另辟蹊径，kotlin来保证这个值不会为空，而`@NotEmpty`来保证这个值是一个一定有长度的值

```kotlin
data class UserSignUpRequest(
    @field:NotEmpty
    val driverId: String = "",
    @field:NotEmpty
    val login: String = "",
    @field:NotEmpty
    val name: String = "",
    @field:Email
    val email: String,
    val avatarUrl: String? = null,
    val bio: String? = null,
    @field:NotEmpty
    val htmlUrl: String =""
)
```

## with

其实我在之前一直没懂这个with函数有什么作用，直到有一次偶然，我将一个builder放到了`with`方法中，我才发现它可以根据表达式的输出结果来改变类型，其表现的方式相当于在builder内部中调用方法一样，不需要接上一堆`.`，直接上代码。

```kotlin

class PersonBuilder {
    var name: String = ""
    var age: Int = 0
    var gender: String = ""
}

fun PersonBuilder.setName(name: String): PersonBuilder {
    this.name = name
    return this
}

fun PersonBuilder.setAge(age: Int): PersonBuilder {
    this.age = age
    return this
}

fun PersonBuilder.setGender(gender: String): PersonBuilder {
    this.gender = gender
    return this
}

fun PersonBuilder.toPerson(): Person {
    return Person(name, age, gender)
}

data class Person(
    val name: String,
    val age: Int,
    val gender: String
)

fun main(array: Array<String>) {
    val person = PersonBuilder()
        .setName("cheng")
        .setAge(20)
        .setGender("mam")
        .toPerson()

    val person1 = with(PersonBuilder()) {
        setName("cheng")
        setAge(20)
        setGender("woman")
        toPerson()
    }
}
```

## 嵌套类和类型别名

嵌套类写着是非常麻烦的，例如什么Persion.Builder，或者在kt中对一个密封类使用的时候，要无穷的`.`下去，找到你需要的那个类。

类型别名刚好能够解决这个问题。

就例如这么一个对象树，这是我定义依赖的时候使用的一个语法。

```kotlin
object Dependence {
    object Version {
        object DB
        object Log
        object Ktor
        object ApiDoc
    }
}
```

我们想要使用内部的`DB`对象，就需要`Dependence.Version.DB`这种看起来巨长的东西。

这时候我们可以给他添加上别名。

```kotlin
typealias DependTreeDB = Dependence.Version.DB
```

我们就可以随意调用这个对象上挂载的属性和对象了。
