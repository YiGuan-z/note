# lambda表达式

lambda表达式本质上是一块被保存下来的一段方法，由于这种lambda接口通常只有一个方法，所以我们不需要用`new Runnable`接口，而是可以直接使用`()->{}`来简化。
lambda允许将函数作为参数进行传递，使代码变得简洁紧凑。

## 没有简化

没有使用lambda写法的`runnable`如：

```java
//一个匿名内部类
Runable run = new Runnable(){
    @Override
    void run(){
        //...
    }
}
```

## 简化

使用了lambda的`runnable`写法:

```java
Runnable run = ()->{/*...*/}
```

这么一看是不是简便了许多？因为里面只有一个需要重写的抽象方法，所以你不管写什么，它都知道你在重写什么方法。

### 如果有入参和出参呢？

*简写前：*

```java
Function<Integer,String> func = new Function(){
    @Override
    String apply(Integer t){
        //...
    }
};
```

*简写后：*

```java
Function<Integer,String> func = (i)->{/*...*/};
```

>好几行代码瞬间精简为一行代码，减少了过多的无意义字符，只是看着有点抽象。
>使用lambda接口的时候需要注意使用`var`关键字，因为lambda很依赖类型表达式，要么像`(i:Integer)->{}`这样标注类型，要么在左边将类型标识出来。

## 方法引用

那么我们知道了`()->{}`是`new Runnable`的简写，如果我在里面只使用一个方法，并且它和`Runnable`接口的入参和出参一样，那么我就可以简写为。

```java
Runnable run = this::print;

void print(){
    //...
}
```

## END

这次没有参考链接，这玩意还是需要多看多写。
