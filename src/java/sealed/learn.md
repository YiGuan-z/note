# 密封类

密封类(sealed Classes)是JDK17的一个新特性，它可以让类和接口之间的继承关系更明确，一个类或者接口可以定义哪些类进行实现或扩展。

## 示例

*这是定义一个密封接口的示例：*

```java
public sealed interface Shape permits Circle, Rectangle , Square {
    //...
}

final class Circle extends Shape {
    //...
}

abstract non-sealed class Rectangle extends Shape{
    //...
}

abstract sealed class Square extends Shape permits //其它的类//{
    //...
}

```

>在这个示例中，我们定义了一个密封接口`Shape`，指定它只能被`Circle,Rectangle,Square`类实现。
>
>在第一个类`Circle`中，我们直接将其定义为final，就意味着它是最终不可改的，该接口的`Circle`实现就只有它一个。
>
>在第二个类`Rectangle`中，我们使用了`non-sealed`关键字将其继承开放出去，任何类都可以对它进行继承。
>
>在第三个类`Square`中，我们使用了`sealed permits`关键字将其进行限制，和我们定义的`Shape`接口一样，指定它只能被xx类继承。

## END

密封类是一个非常棒🎉的特性，它可以帮助我们限制住继承关系，以防止你写的代码被其它人乱继承并使用，最后找你背锅。

防止本不应该由这个类实现，但是被不知名开发者给实现了并导致的错误。
