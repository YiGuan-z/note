# 300行给你一个小型Ioc容器

本文专供于 ~~新手~~ 入门🤔

（代码去掉注释连三百行都没有哦）😁

（再去掉一些无关内容，预计得减半）😁

## 注意

- 仅供参考，以阐明Ioc容器到底是个什么东西，以及尝试编写一个小型的Ioc容器。
- [stream](../stream/stream.md)到处都是，练习练习stream（不要练习到steam🙅‍♂️）。
- 需要理解一下[函数式编程](../lambda/lambda.md)。
  - 其实也很简单，本质上是在对象中保存了一段代码，以供需要时运行。
  - 又因为一系列的简化规则，所以看上去可能有点不明所以。
- 使用了高版本的Java特性，如果不支持该特性，可以自己尝试将其去掉。
  - [密封类](../sealed/learn.md)
  - [记录类](../record/record.md)

## 正文

由于Spring框架在Java历史中占据了举足轻重的地位，谈及Ioc容器就避免不了它。
Ioc容器是一个实现自动依赖注入的一个框架，它管理对象的创建和生命周期，并自动寻找到程序依赖注入到类中。可以将它理解为应用程序中组件仓库，你可以提供任何组件给它，它通过程序内容自动（是需要编写定义的）管理组件。

ps：当初是轻量级，现在是重量级+巨无霸

可以依据下面的完整代码来创建一个类似于Spring的Ioc容器，只需要添加一个包扫描，使用包扫描来扫描class字节码，通过classloader进行加载，加载完毕后就可以疯狂遍历里面的内容了，疯狂遍历！不要担心消耗CPU和内存，CPU速度非常快，这么点字节码占不了多少内存。

过程大致为

- 通过包扫描感知组件对象。
- 对组件对象的类型进行探测，检查是组件是预处理器，还是待实例化的容器组件class。
- 构建容器对象，将扫描出来的预处理器插入容器中运行，扫描到的组件class也一同交给容器对象。
- 对组件的类型进行一系列感知，并处理。
- 容器初始化结束。

### 创建依赖链

要完成这个链的创建，我们只需要定义两个方法，一个用来创建对象，一个用来获取对象。

```java
//将context返回出去是为了链式调用，也可以不返回Context，将它修改为void即可
public interface Context{
    /**
     * 提供一个类对象，寻找里面的公开构造，创建出对象
     * @param type
     * @param name
     * @return
     */
    Context provide(Class<?> type, String name);

    /**
     * 获取一个对象
     * @param type
     * @return
     * @param <T>
     */
    <T> T solver(Class<T> type);    
}
```

让我们来看看创建对象方法的具体逻辑

```java
    //创建实例
   /**
     * 提供一个类对象，寻找里面的公开构造，创建出对象
     *
     * @param type
     * @param name
     * @return
     */
    @Override
    public Context provide(Class<?> type, String name) {
        requireNonNull(type, "type is null");
        requireNonNull(name, "name is null");

        Object instance;
        final var instance1 = createByNoArgsConstructor(type);
        if (isNull(instance1)) {
            instance = createByAllArgsConstructor(type);
        } else {
            instance = instance1;
        }

        provide(instance, name);
        return this;
    }
    //获取实例
    @Override
    @SuppressWarnings("unchecked")
    public <T> T solver(Class<T> type) {
        var pairs = super.context.get(type);
        if (isNull(pairs)) {
            provide(type);
            pairs = super.context.get(type);
        }
        requireNonNull(pairs, String.format("类型%s不存在", type.getSimpleName()));
        final var o = pairs.get(0).second();
        requireNonNull(o, String.format("与%s对应的实例不存在", type.getSimpleName()));
        return (T) o;
    }
```

provide方法获取了两个参数，一个需要被创建出来的类型，一个是与之对应的名称,它做了两件事，直接使用无参构造进行对象创建，若无法创建对象，则使用全参构造进行对象创建，使用全参构造进行创建的方法如果找不到公开的构造器中则会抛出一个`NoSuchElementException`异常以拒绝执行。

获取实例的时候使用的是`<T> T solver(Class<T> type)`方法，我们在如果在solver方法中发现当前类的实例还没被创建，则会调用上面的方法进行创建。

与所有递归一样，如果能找到一个可用的解，则整个被构建类的构建链就会正常运转，如果无法正常运转就表明这条依赖链是错误的，应该好好思考自己的代码依赖关系了。
（如果发现有人写代码依赖都能写循环，还不知道为什么的，那就快跑🏃🚨）

这两个是ioc容器最核心的方法，其它的都是锦上添花，不要担心数据量或数据结构的复杂性带来的耗时，
因为最大的耗时永远都在IO，创建这么点数据炸不了机器，内存也该用就用。

### 在已被创建的实例池中通过某一特性来获取集合

在下面的完整代码中，定义了这么一个接口

```java
<T, Coll extends Collection<T>> Coll collect(Class<T> type, Supplier<? extends Coll> container);
```

在我的定义中，它通过接收一个class对象和一个供给者供给`Collection`方法进行调用，判断type是接口还是类定义来进行查找内容，在我的构思中，应该在一个地方一次对这些内容配置完毕，不应该东一个，西一个。

所以我假设了在方法运行完毕后，不应该再提供内容给容器，所以我在抽象类中定义了一个查询缓存，先去缓存中查找，缓存中找不到再开始运行真正的查询方法。

由于Java是可被擦除的泛型，所以将带泛型接口传进去查询出来的将会是是所有实现了该泛型的对象，需要自行对内容进行判断。

**这是定义在抽象类中的查询方法.**

```java
    protected final Map<Class<?>, Collection<Object>> cache = new HashMap<>();

    @SuppressWarnings("unchecked")
    protected <T> Collection<T> search(Class<T> type) {
        if (type == null) {
            throw new NullPointerException("type are null");
        }
        if (cache.containsKey(type)) {
            return (Collection<T>) cache.get(type);
        }
        if (type.isInterface()) {
            return searchByInterface(type);
        } else {
            return searchByType(type);
        }
    }

    /**
     * 通过类型搜索
     *
     * @param type
     * @param <T>
     * @return
     */
    private <T> Collection<T> searchByType(Class<?> type) {
        return searchByAction(type, entry -> entry.getKey().equals(type));
    }

    /**
     * 通过接口搜索
     *
     * @param interfaceType
     * @param <T>
     * @return
     */
    private <T> Collection<T> searchByInterface(Class<?> interfaceType) {
        return searchByAction(interfaceType, entry -> Arrays.asList(entry.getKey().getInterfaces()).contains(interfaceType));
    }

    @SuppressWarnings("unchecked")
    private <T> Collection<T> searchByAction(Class<?> type, Predicate<Map.Entry<Class<?>, List<Pair<String, Object>>>> action) {
        try {
            final var result = context
                    .entrySet()
                    .stream()
                    .filter(action)
                    .map(Map.Entry::getValue)
                    .flatMap(Collection::stream)
                    .map(Pair::second)
                    .toList();
            cache.put(type, result);

            return (Collection<T>) result;
        } catch (Exception e) {
            return null;
        }
    }
```

通过类型进行搜索和通过接口进行搜索只有在过滤方法才会有具体的差别，所以我将其抽象出来成为一个单独的方法，分别定义两个方法的搜索逻辑，该`search`方法为子类方法的`collect`进行了支持。

使用方法如下，可以将下面三个变量打印出来看看内容。

```java
final var context = AppContent.create("app")
                .provide("卧槽","config")
                .provide("2")
                .provide(1)
                .provide(3);
        final var strings = context.collect(String.class, ArrayList::new);
        final var integers = context.collect(Integer.class, ArrayList::new);
        final var charSequences = context.collect(CharSequence.class, ArrayList::new);
```

## END

[完整代码](./context.md#完整代码)

[GitHub仓库](https://github.com/YiGuan-z/mini_ioc)
