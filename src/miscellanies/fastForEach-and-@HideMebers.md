# 关于List的快速迭代和@HidesMembers

## List快速迭代

我们平常在kotlin中使用的List接口forEach方法，我们可以查看其内部定义，发现它使用的是`Iterable`进行迭代。

这是一种兼容性用法，因为所有的List都会实现`iterator`接口，所以不管是链表实现，还是数组实现，我们都可以通过`iterator`实现一个通用的forEach。

但是，对于数组实现的List来说，使用迭代器是一个效能低下的方式，因为它可以直接通过数组下标获取到数据，也就是我们在Java中写的

```java
for(int i=0; i<= list.length;i++){
    list.get(i)
}
```

所以我们可以在kotlin中使用

```kotlin
for (index in this.indices) {
    val e = this[index]
    action(e)
}
```

这和上面的效果是一样的，只要你知道你的列表是数组实现的，那么用它就能得到比迭代器更快的迭代速度。~~虽然用不用没什么区别，不差这点速度~~

## @HidesMembers

在kotlin中，@HidesMembers注解可以让我们在同名方法中，优先选择这个。

我们可以用它将List接口的`forEach`替换为我们自己实现的`forEach`。

@HidesMembers不让用，没问题，不让编译器叫便是。

```kotlin
@Suppress("INVISIBLE_MEMBER","INVISIBLE_REFERENCE")
@kotlin.internal.HidesMembers
fun <E> List<E>.forEach(action:(E)->Unit)
        where E:Any
{
    for (index in this.indices) {
        val e = this[index]
        action(e)
    }
    println("感谢使用")
}
```

测试代码如下

```kotlin
@Test
fun testFastForEach(){
    listOf(1,2,3).forEach {
        println(it)
    }
}
```

输出结果为

```log
1
2
3
感谢使用
```

这样，我们就直接覆盖掉了kotlin的forEach方法。

## @Suppress

这个注解可以让我们的编译器不要叫。

它甚至可以忽略权限，但是对于private只能够忽略本模块的权限，对于internal的话能够跨模块访问。但是，仅限于kotlin，对于Java的权限修饰符这个方法不起效果。

所有的屏蔽类型都可以在<https://github.com/JetBrains/kotlin/blob/master/compiler/frontend/src/org/jetbrains/kotlin/diagnostics/rendering/DefaultErrorMessages.java>中找到。

![测试代码](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202308112057740.jpg)

![成功代码](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202308112058764.jpg)

