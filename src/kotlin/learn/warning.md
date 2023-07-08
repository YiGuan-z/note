# kotlin的注意事项

## 自动推断的变量

运行下面代码

```kotlin
val a: Int = 1
val b: Int? = 1 as Int?
val c: Integer = 1 as Integer
val d: Integer? = 1 as Integer?
println("a ${a::class.java}")
println("b ${b!!::class.java}")
println("c ${c::class.java}")
println("d ${d!!::class.java}")
```

可以发现只有第一个才是int基元类型，可空性的Int输出的Java类型为Integer。
如果想要Java类型为Integer就需要自行断言。
用字节码编写方法的需要注意这点。

## 注意使用内联函数

内联函数可以给我们带来类似于真泛型的体验，但是⚠️！，如果给一个非常巨大的方法使用内联函数会显著的增加代码体积。

建议使用内联方法来获取泛型，然后将具体的方法体交给另一个方法调用，这样就不会增加巨量的字节码体积。
