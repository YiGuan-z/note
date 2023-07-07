# stream流运算

Java8版本是一个很经典的Java版本，已经被无数的培训班叨叨过了，stream在Java8中是一个很伟大的动作，它允许一系列的动作拆分组合，并且它是语义化的（可以配合翻译）。

stream 就像一个工厂流水线车间一样，一步步的对数据内容进行操作（映射，组合，过滤，收集）。

## 常用的Stream操作

`filter` 通常用作筛选对象

> 过滤掉不能被2整除的对象

```java
Stream.of(1, 2, 3, 4, 5, 6, 7).filter(it -> it % 2 == 0).toList();
```

`map` 用作映射为另一个对象

> 将数字转化为字符串列表，转化出来的是不可变列表

```java
Stream.of(1, 2, 3, 4).map(String::valueOf).collect(Collectors.toList());
```

`max` 查找最大的那个对象

> 找出最大的数字orElse是为了解开Optional使用的。

```java
Integer integer = Stream.of(1, 2, 3, 4, 5).max(Integer::compareTo).orElse(-1);
        System.out.printf("最大的数字是:%d%n", integer);
```

`min` 查找最小的那个对象

> 和最max的使用方法一样，换一个方法即可.

```java
Integer integer = Stream.of(1, 2, 3, 4, 5).min(Integer::compareTo).orElse(-1);
        System.out.printf("最小的数字是:%d%n", integer);

```

`limit` 限制流过多少次数据

> 生成一个无限流，限制生产5个数字
> 无限流可用迭代器和生产器进行构建，停止方法只有limit，或者使用函数签名为
> `public static<T> Stream<T> iterate(T seed, Predicate<? super T> hasNext, UnaryOperator<T> next)`
> 的迭代器进行迭代生成。

```java
Stream.iterate(0, (it) -> it + 1).limit(5).forEach(System.out::println);
```

`forEach` 对结果进行遍历

> 和其它方法的forEach一样的使用方式，在stream中这属于终结方法。

```java
Stream.iterate(0, (it) -> it + 1).limit(5).forEach(System.out::println);
```

`collect` 对结果进行收集，一般配合Collectors里的方法收集为各种数据结构

> 收集为hashMap
>
> Function.identity()是指的自己，也就是将传入的int作为键

```java
var collect = Stream.of(1, 2, 3, 4, 5)
                .collect(
                        Collectors.toMap(
                                Function.identity(),
                                (it) -> String.valueOf(it*2)
                        )
                );
        System.out.println(collect);
```

`toList` 高版本Java可用。

>因为大部分时间都是收集内容为list，所以官方直接将方法抽了出来，注意，该方法返回的是不可变列表，由于一些历史原因，Java无法对List做出较大的改动，所以这个坑需要注意。
>
>可以点击toList的源码查看，使用的unmodifiableList进行了包装

```java
List<Integer> integers = Stream.of(1, 2, 3, 4, 5).filter((it) -> it % 2 == 0).toList();
```

`toArray` 转化为对象数组
>使用方法和toList一样，只是这个转换为了数组
>
>可以转换为object数组或其它的对象数组
>
>不填参数会转化为对象数组

```java
Integer[] array = Stream.of(1, 2, 3, 4, 5).filter((it) -> it % 2 == 0).toArray(Integer[]::new);
```

`reduce` 累积操作，可以将一个数字列表累加为一个结果。
>对流中的数据进行累加，例如计算出1+2+3...+100的结果

```java
Optional<Integer> reduce = Stream.iterate(1, (it) -> it <= 100, (it) -> it + 1).reduce(Integer::sum);
        reduce.ifPresent(System.out::println);
```

`peek` 可对流中的每个项目进行操作。
>若想对流中的每个项目都做一次操作的话，可以使用它

```java
List<Person> people = Stream.generate(Person::new).limit(5).peek(it -> it.eat(new Date())).toList();
    System.out.println(people);
```
