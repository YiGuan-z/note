# swift

## 引言

由于本人在学习swift，所以才会有这个页面，相当于是笔记吧。也方便我之后来查看内容。

本人是通过kotlin转换到swift，所以也可看做为对应的转换笔记。

## 正文

[Swift](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/aboutswift)是苹果官方的一种开发语言，只能够在苹果生态圈中使用，对苹果开发感兴趣的开发者必学语言之一。

### 自动引用计数

> swift和我们平常使用的jvm平台有点不一样，它只有一种垃圾回收算法，在此之前的[object-c](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/Introduction/Introduction.html)，和C语言一样，使用的是手动内存管理方案。

- 弱引用

弱引用在这里用于防止循环强引用对象，也就是A和B的相互依赖导致的对象永远无法被回收。

在声明属性或变量的时候，在前面加上关键字weak关键字即可标识这是一个弱引用。

因为弱引用可能会随时回收，所以它需要被定义为可选空的变量，而不是非空变量。

- 无主引用

无主引用是一种不会增加对象引用计数的引用，它和弱引用相似，无主引用不会阻止所引用对象的释放，无主引用和弱引用的一个区别是，无主引用不是可选类型。你可以直接访问无主引用。弱引用会在对象内被内存压力触发后才会进行回收，或者引用它的对象被移除的时候。

无主引用使用`unowned`关键字进行定义，无主引用会在引用它的对象被销毁时销毁，它不是可选类型。
不可以访问一个已被销毁对象的无主引用。

> 无主引用和弱引用都是用来解决循环强引用问题的解决方案。当两个实例互相持有对方的时候，他们就会形成一个强引用循环，导致内存无法释放。从而出现了无主引用和弱引用。
>
> 无主引用和弱引用的区别在与他们对所选引用对象的生命周期影响。无主引用不会增加对象的引用计数，也不会阻止对象被释放。但是，无主引用不是可选类型，这就以为着可以直接访问无主引用对象，不需要对`nil`进行判断，但是，使用无主引用的时候需要保证所引用的对象在无主引用的生命周期中一直存在。如果访问一个被释放的无主引用，你的程序将会崩溃。

- 在闭包中定义捕获列表

```swift
    lazy var someClosure = {
        [unowned self, weak delegate = self.delegate]
        (index: Int, stringToProcess: String) -> String in

    }
```

> 用于防止对自己捕获的变量强引用循环，所以需要声明为弱引用或无主引用。

### class&struct

在swift中，分为class和struct两种数据类型，class是引用类型，struct是值类型。

#### 突变方法

`mutating`关键字可以让struct或enum内部保存的值发生改变，这两种类型一般不变，但特殊情况就需要标注一下。

### init&deinit

在swift中，`init`是构造函数，这点和kotlin的init是不同的，swift还有一个特殊的函数:`deinit`，用于对象的析构它将在这个对象被回收的时候执行。

### protocol

在swift中，协议起到了kotlin中的interface的功能。

值得注意的一点是，有一个`mutating`关键字标注的异变方法，它用来表示可以修改其所属实例的熟悉。由于swift中的结构体和枚举是值类型，他们的实例在默认情况下是不可变的。这时候如果想要修改值类型的熟悉，就需要使用`mutating`关键字来标记该方法。

你也可以在协议`protocol`中就声明它的构造器。声明出它的方法签名即可。

被协议声明了构造器在实现的时候，都必须为构造器标注`required`关键字来修饰。
它表示该类的所有子类都必须实现该构造器。
如果是`final`那么久不必使用`required`修饰符进行标注，因为`final`不会有子类。

可以给协议添加`AnyObject`关键字到继承列表，就可以限制协议只能被class实现而不是枚举和结构体。

### 扩展

和kotlin一样，swift也是可以为某个类型扩展方法或者变量，但是和kotlin不同的一点是，它的扩展方法统一写在了`extension`关键字展开的作用域里面，入下所示。

```swift
extension TextRepresentable{
    var textualDescription: String { get }
}
```

也可以为某个类型实现某个协议。

```swift
extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
```

### 泛型

swift使用的是真泛型，编译器会专门生成泛型所使用类型的代码。

### 字典

没错，swift的字典就是其它语言中的Map，但是对于用惯了Map的我来说，突然要写那么长的单词有点不习惯，不知道能不能使用`[K:V]`来表示字典。

### 关联类型

`associatedtype` 用于定义关联类型，Rust中也有这个概念，这是一个类型上的占位符，可以表示该协议需要使用到哪些类型，跟泛型类似，在我看来，这是一个带注释的泛型，可以解决写泛型的时候出现一堆莫名其妙的缩写。

### where

和kotlin一样，过于复杂的泛型条件可以通过where来进行指定。

### 不透明类型

在指南里说可以使用`some`关键字来指定类型为不透明，如下所示。

```swift
func makeShape<T:Shape>(shape1:T) -> some Shape{
    return shape1
}

```

这代表了我们只知道返回了一个可用的协议，并不知道它的具体类型，感觉和和许多语言的直接返回接口类似。不过，不透明类型在底层上有着更强的类型规定，一个不透明类型只能对应一个具体的类型。

例如

```swift
protocol A{}

class A1:A{}
class A2:A{}
func A1Create()->some A{
    return A1()
}
func A2Create()->some A{
    return A2()
}
let coll :[some A] = [
    A1Create(),A1Create(),A2Create()
]
```

这样的代码将会报错，当你把`A2Create`删除后才会正常，同理，把`A1Create`删除后也会恢复正常。

### 访问等级

swift中有有五个访问级别。

|关键字|作用|
|:---:|:---:|
|`open&public`|让实体可在所有地方访问，open修饰得类可继承，方法可重写|
|`internal`|模块访问级别|
|`fileprivate`|文件访问权限，只有在一个文件中的内容才能相互访问|
|`private`|限制访问，只有实体中才能够进行访问|

这样子看下来，这些修饰符和kotlin的权限修饰符一样，但是新增了一个文件内访问权限，用于粒度更精细的访问控制。

在swift中，不写权限控制符的话，默认给予的权限是`internal`级别。

### 算术运算

在swift中，进行算数运算符将不会允许溢出，如果一个运算结果溢出了，将会产生一个异常，如果想要溢出结果，就需要使用`&`声明这是一个溢出的算术运算。

### 自定义运算符

使用`static func`即可定义运算符重载，将方法名指定为需要编写的运算符即可。

可自定义运算符声明，使用`operator`修饰符来声明。

可声明的运算符有前缀 中缀 后缀。 运算符的位置指定了运算符与其对象的相对位置。

### 集合类型

#### 数组

```swift
var items: [Int] = []
items.append(1)
items.append(2)
items.append(3)
//初始化一个个带默认值的数组
var moreItems: [Int] = Array(repeating:1 , count: 5)
/// moreItems[5, 5, 5, 5, 5]
//通过运算符将两个数组想家构建一个新的数组。
var newItems = items + moreItem
// newItems[1, 2, 3, 5, 5, 5, 5, 5] 
```

#### Set

和其它语言的Set声明没什么区别，不过它也可以使用中括号来进行初始化。

```swift
var favoriteGenres: Set<String> = ["a","b","c"]
```

#### 字典的使用

相较于字典，我其实更喜欢叫它Map，不过这都是一个东西，没搞懂为什么会有两个名字。
看了字典的初始化方法后，不由得感叹，这中括号用法真多啊。

```swift
var map:[Int:String] =  [:]
map[1] = "A"
print(map)
map[1] = "B"
print(map)
```

### 异步编程

想要标记某个函数是异步的，可以在声明中的参数列表后面加上`async`关键字，和使用`throw`关键字来标记抛出异常的函数是类似的。如果一个函数或方法有返回值，可以在返回箭头`->`前添加`async`关键字。

调用一个异步方法的时候，执行将会被挂起直到这个异步方法返回。需要在调用前添加await关键字来标记此处为可能暂停的调用。在一个异步方法中，执行指挥调用另一个异步方法的时候会被挂起，挂起永远都不会是隐式或优先的，也就意味着所有可暂停的地方都需要被标记为`await`。

评价：语法上和js很像，又带了一点点kotlin协程的味道。
