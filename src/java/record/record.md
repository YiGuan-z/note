# record

## 介绍

有使用过kotlin吗？这就是kotlin中的`data class`没有使用过也没关系，因为`record`非常简单。

不知道是否被Java的数据类型写得不耐烦了，毕竟需要编写一堆`get`,`set`，我们早就看不下去这些东西了，所以会出现Lombok。

但是！Lombok是在编译时生产代码，所以会产生一种现象。我们在阅读源代码的时候会发现，源代码和字节码不对应。这会大大影响我们阅读源码的体验。（idea会有一个大大的警告⚠️）

## 模型定义

record通常用来数据传递，用户模型也可以使用它来定义。

*例如:*

```java
class User{
    private Integer id;
    private String name;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
```

>我们在这里定义了一个用户模型，但是它太冗余了我们就将其简化为。

```java
public record Pair(Integer id,String name) {
}
```

它的get方法被修改为了字段名，并且没有`set`方法。
这样可以对反射方法帮了大忙了，没有`set`，只有`get`，并且`get`的名字就是属性名。

>这样我们就可以获得一个简便的记录类了，但有一点。
>
>它是不可变的，不过这没问题，我们可以使用

```java
var pair=new Pair(1,"xiaoming")
var copy=new Pair(pair.id(),"xiaocheng")
```

>这样就可以对记录进行修改了，这不会有什么问题，构建出来的对象如果长时间不引用是会被回收的，并且内容都是传递的引用，所以速度也会非常快。

## 规范构造和紧凑构造

### 规范构造

规范构造的参数列表与record声明处的参数列表相同。规范构造函数用于初始化record对象的状态。
没有写规范构造的时候会自动生成一个规范构造。

```java
public record Pair(Integer id,String name){
    public Pair(Integer id,String name){

    }
}
```

### 紧凑构造

紧凑构造是规范构造的一种简写，通常用于做一些参数验证，日志记录...

```java
public record Pair(Integer id,String name){
    public Pair{

    }
}
```

### 普通构造

和普通类的构造参数一样，不过它需要委托给规范构造

```java
public record Pair(Integer id,String name){
    public Pair(Pair p){
        this(p.id(),p.name())
    }
}
```

## END

没有参考，大家可以去搜索引擎去查找更多用法。(java `record`不怎么好用，还是kotlin的`data class`比较好)

kotlin的`data class`比这个好用，因为它自带一个copy方法，并且它是可声明参数，不填写参数就是对该类型的复制。填写参数就是对该类型的修改。
