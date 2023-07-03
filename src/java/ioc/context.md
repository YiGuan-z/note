# 完整代码

```java
package com.cqsd.dl;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.*;
import java.util.function.Predicate;
import java.util.function.Supplier;

import static java.util.Objects.isNull;
import static java.util.Objects.requireNonNull;

/**
 * @author caseycheng
 * @date 2023/6/30-20:56
 **/
public sealed interface Context permits BaseContext {
    /**
     * 提供一个对象，它的名字为它自己的hashcode
     *
     * @param o
     * @return
     */
    Context provide(Object o);

    /**
     * 提供一个对象，并给予一个名字
     *
     * @param o
     * @param name
     * @return
     */
    Context provide(Object o, String name);

    /**
     * 提供一个类对象，寻找里面的公开构造，创建出对象
     *
     * @param type
     * @param name
     * @return
     */
    Context provide(Class<?> type, String name);

    /**
     * 提供一个类让dl进行创建
     *
     * @param type
     * @return
     */
    Context provide(Class<?> type);

    /**
     * 获取一个对象
     *
     * @param type
     * @param <T>
     * @return
     */
    <T> T solver(Class<T> type);

    /**
     * 通过name获取一个对象
     *
     * @param name
     * @param <T>
     * @return
     */
    <T> T solver(String name);

    /**
     * 通过name和class获取一个对象
     *
     * @param type
     * @param name
     * @param <T>
     * @return
     */
    <T> T solver(Class<T> type, String name);

    /**
     * 获取某个类型的集合
     * 如果是接口类型，就检索所有值的该接口，并返回集合
     *
     * @param type      类型
     * @param container 需要被放入的容器
     * @param <T>       类型
     * @return 容器
     */
    <T, Coll extends Collection<T>> Coll collect(Class<T> type, Supplier<? extends Coll> container);

    /**
     * 获取上下文名称
     *
     * @return
     */
    String getName();
}

record Pair<A, B>(A first, B second) {
    public static <A, B> Pair<A, B> createNotNull(A first, B second) {
        requireNonNull(first, "first is null");
        requireNonNull(second, "first is null");
        return new Pair<>(first, second);
    }

    public static <A, B> Pair<A, B> createNullable(A first, B second) {
        return new Pair<>(first, second);
    }
}


abstract non-sealed class BaseContext implements Context {
    // env name
    private final String name;
    // map[key:class,value: List:name instance] 不写名字的就给一个类型名首字母小写
    protected final Map<Class<?>, List<Pair<String, Object>>> context = new HashMap<>();
    //对[collection]接口的查询缓存
    protected final Map<Class<?>, Collection<Object>> cache = new HashMap<>();

    public BaseContext(String envName) {
        requireNonNull(envName, "The name of the environment is required");
        this.name = envName;
    }

    /**
     * 提供给子类设置对象的方法，这里只管添加
     *
     * @param o    实例
     * @param name 实例名
     */
    protected void addObject(Object o, String name) {
        final Class<?> key = o.getClass();
        if (!context.containsKey(key)) {
            context.put(key, new ArrayList<>());
        }
        context.get(key).add(Pair.createNotNull(name, o));
    }

    /**
     * 通过类型或接口进行寻找
     *
     * @param type
     * @param <T>
     * @return
     */
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


    @Override
    public String getName() {
        return this.name;
    }
}

class AppContent extends BaseContext {
    private AppContent(String envName) {
        super(envName);
    }

    public static Context create(String name) {
        return new AppContent(name);
    }

    /**
     * 提供一个对象，它的名字为它自己的hashcode
     *
     * @param o
     * @return
     */
    @Override
    public Context provide(Object o) {
        this.provide(o, String.valueOf(Objects.hashCode(o)));
        return this;
    }

    /**
     * 提供一个对象，并给予一个名字
     *
     * @param o
     * @param name
     * @return
     */
    @Override
    public Context provide(Object o, String name) {
        requireNonNull(o, "instance is null");

        super.addObject(o, name);
        return this;
    }

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

    /**
     * 通过无参构造创建
     *
     * @param type
     * @return
     */
    private Object createByNoArgsConstructor(Class<?> type) {
        try {
            return type.getConstructor().newInstance();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 通过全参构造创建
     *
     * @param type
     * @return
     */
    private Object createByAllArgsConstructor(Class<?> type) {
        final var constructor = Arrays.stream(type.getConstructors())
                .max(Comparator.comparingInt(Constructor::getParameterCount))
                .orElseThrow(() -> new NullPointerException("no such public constructor"));
        final var args = Arrays.stream(constructor.getParameterTypes()).map(this::solver).toArray();
        try {
            return constructor.newInstance(args);
        } catch (InstantiationException | IllegalAccessException | InvocationTargetException e) {
            throw new NoSuchElementException(String.format("%s缺少一个方法参数，请考虑将参数提供给容器", type.getSimpleName()), e);
        }
    }


    /**
     * 提供一个类让dl进行创建
     *
     * @param type
     * @return
     */
    @Override
    public Context provide(Class<?> type) {
        return provide(type, String.valueOf(Objects.hashCode(type)));
    }

    /**
     * 获取一个对象
     *
     * @param type
     * @param <T>
     * @return
     */
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

    /**
     * 通过name获取一个对象
     *
     * @param name
     * @param <T>
     * @return
     */
    @Override
    @SuppressWarnings("unchecked")
    public <T> T solver(String name) {
        requireNonNull(name, "请输入name");
        final var result = super.context.values()
                .stream()
                .flatMap(Collection::stream)
                .filter(pair -> pair.first().equals(name))
                .findFirst();
        result.orElseThrow(() -> new NullPointerException(String.format("名为%s的对象不存在", name)));
        return (T) result.get().second();
    }

    /**
     * 通过name和class获取一个对象
     *
     * @param type
     * @param name
     * @param <T>
     * @return
     */
    @Override
    @SuppressWarnings("unchecked")
    public <T> T solver(Class<T> type, String name) {
        requireNonNull(type, "type is null");
        requireNonNull(name, "name is null");
        final var list = super.context.get(type);
        requireNonNull(list, String.format("类型为%s的内容尚未提供", type.getSimpleName()));
        for (Pair<String, Object> pair : list) {
            if (pair.first().equals(name)) {
                return (T) pair.second();
            }
        }
        throw new NullPointerException(String.format("名为%s的对象不存在", name));
    }

    /**
     * 获取某个类型的集合
     * 如果是接口类型，就检索所有值的该接口，并返回集合
     *
     * @param type      类型
     * @param container 需要被放入的容器
     * @return 容器
     */
    @Override
    public <T, Coll extends Collection<T>> Coll collect(Class<T> type, Supplier<? extends Coll> container) {
        final var result = super.search(type);
        final var ts = container.get();
        if (isNull(result)) {
            ts.addAll(Collections.emptyList());
        } else {
            ts.addAll(result);
        }
        return ts;
    }
}

```
