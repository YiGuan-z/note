<!-- ---
title: swift的combine框架介绍
date: 2023/08/23
tags: [ios,swift,combine]
--- -->
# combine in swift

date：2023/08/23

tags：[ios,swift,combine]

```admonish info
阅读<https://www.icodesign.me/posts/swift-combine>有感。
```

## 导读

文中先介绍了观察者模式和响应式编程，并以此引出combine，combine有发布者、订阅者、操作符三个重要组成部分，并介绍了里面的Publisher、Subscriber、Subject，
并且谈到了AnyPublisher、AnySubscriber、AnySubject，和Cancellable，最后聊了聊操作符。

（虽然看上去像是AI写的，但我不是AI，我只是粗略的看了一遍写了这段话，还没消化呢。）

---

## 观察者模式

这是一种设计模式，它通常描述一对多的关系，当内部对象被修改的时候通知观察者对象，观察者对象就能获得通知，可以看作是回调函数，不过回调函数是一对一的依赖关系。

文中给出的示例代码：

```swift
protocol Observable {
    associatedtype T: Observer
    mutating func attach(observer: T)
}

protocol Observer {
    associatedtype State
    func notify(_ state: State)
}

struct AnyObservable<T: Observer>: Observable{

    var state: T.State {
        didSet {
            notifyStateChange()
        }
    }

    var observers: [T] = []

    init(_ state: T.State) {
        self.state = state
    }

    mutating func attach(observer: T) {
        observers.append(observer)
        observer.notify(state)
    }

    private func notifyStateChange() {
        for observer in observers {
            observer.notify(state)
        }
    }
}

struct AnyObserver<S>: Observer {

    private let name: String

    init(name: String) {
        self.name = name
    }

    func notify(_ state: S) {
        print("\(name)'s state updated to \(state)")
    }
}

var observable = AnyObservable<AnyObserver<String>>("hello")
let observer = AnyObserver<String>(name: "My Observer")
observable.attach(observer: observer)
observable.state = "world"

// "My Observer's state updated: hello"
// "My Observer's state updated: world"
```

在这个demo中，定义了一个可观察对象和一个观察者对象，可观察对象可以给自己添加观察者，可观察对象主要是使用了`didSet`关键字为自己在值更新完毕后可以拉起通知所有观察者的方法，观察者你定义接收通知需要做的操作。

---

说实话，我对这些概念有点不敏感，看完了代码才发现我写过很多类似的东西，这也算是巩固知识了吧。

这段代码俺寻思可以修改一下，将Observer的notify方法修改为onChange，在Observer中，使用属性获取State的类型，那样就能够修改类型后直接知道方法了，不过那都不是重点。

---

## 响应式编程

响应式编程是一种编程思想，与之相对应的有面向过程、面向对象、函数式编程等等。不一样的是，响应式编程的核心思想是面向异步数据流和变化的。

>注：
>
>其实很多编程思想要结合实际，之前在别人群里看见了一个写Clojure的老哥，天天说着自己的LISP编程思想有多厉害，andorid中的UI它都要使用lisp进行编写，大家可不要学它，每一门留下了社区的语言基本上都是为了解决某一个问题诞生的，它们有着自己的特性和编程思想。
>
>其实，汇编比它更加高级，但是没见到写汇编的出来吹牛。
>我大致看了一下Clojure的一个demo，这要是能写UI，那汇编UI早就飞起来了。

在前端中，我们需要往浏览器注册大量的事件监听，例如用户交互，网络监听，还有委托给浏览器的系统调用。因此无可避免的产生纷繁复杂的状态。在使用响应式编程后，所有的事件都将成为异步的数据流，更加方便的是，我们可以对这些数据流进行组合变换，最终，我们只需要监听我们关心的数据流变化做出响应即可。

文中给出了两段代码，分别是命令式编程代码和响应式编程代码

命令式：

```swift
func goodMorning() {
    wake {
        let group = DispatchGroup()
        group.enter()
        wash {
            group.leave()
        }
        group.enter()
        cook {
            group.leave()
        }
        group.notify(queue: .main) {
            eat {
                print("Finished")
            }
        }
    }
}
```

响应式：

```swift
func reactiveGoodMorning() {
    let routine = wake.rx.flapLatest {
        return Observable.zip(wash, cook)
    }.flapLatest {
        return eat.rx
    }
    routine.subsribe(onCompleted: {
        print("Finished")
    })
}
```

这两者实现的功能是完全相同的，但是结构却大不相同，在响应式中，使用连接操作符将不同操作组合成一个流操作，最后我们可以对它进行订阅。

## 什么是combine？

>The Combine framework provides a declarative Swift API for processing values over time.These values can represent user interface events, network responses, scheduled events, and many other kinds of asynchronous data.
>
>By adopting Combine, you’ll make your code easier to read and maintain, by centralizing your event-processing code and eliminating troublesome techniques like nested closures and convention-based callbacks.

combine框架提供了一个声明式的Swift API，用于随时间变化处理值。这些值可以表示用户界面事件、网络响应、计划事件和许多其他类型的异步数据。

通过采用combine，可以集中事件处理代码，消除回调地狱，从而使代码便于阅读。

在combine中，有着几个重要的组成部分。

- 发布者 Publiser
- 订阅者 Subscriber
- 操作符 Operator

### Publiser

在combine里面，Publiser就是观察者模式中的Observable，并通过一些运算符，生成新的Publisher。

注意⚠️：以下代码看个概念即可，因为作者编写文章的时间点是2019年，现在是2023年。

关于苹果开发的文档真少啊。

```swift
public protocol Publisher {
    associatedtype Output

    associatedtype Failure : Error

    func receive<S>(subscriber: S) where S : Subscriber, 
        Self.Failure == S.Failure, Self.Output == S.Input
}
```

在Publisher中，Output代表的是数据流中的输出，值的更新可能是同步，也可能是异步，Failure代表的是中间可能产生的错误。

Publisher通过`receive<S>(subscriber: S)`来接收订阅，并且要求`subscriber`的值类型一致来保证其类型安全。

```admonish info collapsible=true
完全不会这一套话术，能将泛型说得那么厉害，我还是得学习这一套话术啊。~~酸了酸了~~
```

```swift
let justPubliser = Publishers.Just("Hello")
```

这段代码会为每一个订阅者发送一个`"Hello"`消息，然后立即结束，后续交由订阅者做出反应。

combine为我们提供了一些方便的Publisher实现，除了`Just`，下面是列出一些有趣的Publisher

在以下API中，只有Sequence还存在于这里，其它的都要么换了位置，要么改了名字。

**Empty**

`Empty`不提供任何值的更新，因为它是空的，并可以选择立即正常结束。

**Once**

`Once`可以提供两种数据流之一

- 发送一次值更新，然后立即结束，和只使用Just一样。
- 立即因错误而终止

**Fail**

`Fail`和`Once`很是相似，也提供两种情况之一

- 发送一次更新后立即因为错误而终止
- 立即因错误而终止

**Sequence**

`sequence`提交一个序列给订阅者。

是一个一个的给到订阅者手里。

**Future**

`Future`初始化需要提供具体执行内容的闭包，它可以是异步操作，并且最终返回一个Result，所以Future要么发送一个值，然后正常结束，要么因为错误而终止。在将一些异步操作转换为Publisher的时候非常有用，尤其是网络请求。

```swift
let apiRequest = Publishers.Future { promise in
    URLSession.shared.dataTask(with: url) { data, _, _ in
        promise(.success(data))
    }.resume()
}
```

看上去非常像前端的`Promise`，没错我也是这么想的。

**Deferred**

`Deferred` 初始化需要提供一个生成Publisher的闭包，只有在有`Subscriber`订阅的时候才会生成指定的`Publisher`，并且每个`Subscriber`获得的 `Publisher` 都是全新的。

如果我们想要一个消息间隔两秒后发送出去，我们就可以写为以下方式，其中我们使用到了delay操作符。

```swift
let delayedJustPublisher = justPubliser.delay(for: 2, scheduler: DispatchQueue.main)
```

### Subscriber

Subscriber是观察者模式中的观察者，以下是它的定义代码。

```swift
public protocol Subscriber : CustomCombineIdentifierConvertible {
    associatedtype Input
    associatedtype Failure : Error
    func receive(subscription: Subscription)
    func receive(_ input: Self.Input) -> Subscribers.Demand
    func receive(completion: Subscribers.Completion<Self.Failure>)
}
```

通过代码我们可以得知，`Subscriber`有两个关联类型{{footnote:泛型的一种}}，`Input`约束了该观察者所能够观察到的对象，`Failure`标示了可能会遇到的错误情况。

Publisher会发出三种类型的通知：

- Subsription: 成功订阅的消息，只会发送一次，取消订阅会调用它的cancel方法来释放资源
- Value: Subsription的Input，Publisher中的Output，可能会发送0次或多次。
- Completion: 数据终止的消息，有两种状态，`.finished`和`.failure(err)`，在数据流终止的时候就会接收到。

Publisher在自己的状态被更改时，将会调用`Subscriber`{{footnote:注册的监听}}中的三个不同的`receive`方法来通知`Subscriber`{{footnote:你的回调}}

大部分情况下，我们都只关心后面两种消息，即数据和数据的终止信息。

Combine内置有三种Subscriber

- sink
- assign
- subject

sink是一个非常通用的Subscriber，我们可以自由处理数据流的状态。

sink：

```swift
//这里定义了一个发布者，它只提供一个
let once: Publishers.Once<Int, Never> = Publishers.Once(100)
let observer: Subscribers.Sink<Publishers.Once<Int, Never>> = Subscribers.Sink(receiveCompletion: {
    print("completed: \($0)")
}, receiveValue: {
    print("received value: \($0)")
})
once.subscribe(observer)

// received value: 100
// completed: finished
```

assign可以很方便的将接收到的值通过keyPath设置到指定的class上，适合将已有程序改造为reactive。

```swift
class Student {
    let name: String
    var score: Int

    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
}

let student = Student(name: "Jack", score: 90)
print(student.score)
//将观察者绑定到Student.score中
let observer = Subscribers.Assign(object: student, keyPath: \Student.score)
//创建一个Int发布者
let publisher = PassthroughSubject<Int, Never>()
//添加观察者给它，检测值的变化，并自动设置值。
publisher.subscribe(observer)
publisher.send(91)
print(student.score)
publisher.send(100)
print(student.score)

// 90
// 91
// 100
```

在这个demo中，由于我们有一个Assign订阅者，绑定了student对象中的score变量，所以，我们往发布者里面发送一个值，与之关联的订阅者都会被更新字段，看上去很适合级联操作。

### Operator
