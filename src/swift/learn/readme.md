# swift

由于本人在学习swift，所以才会有这个页面，相当于是笔记吧。也方便我之后来查看内容。

[Swift](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/aboutswift)是苹果官方的一种开发语言，只能够在苹果生态圈中使用，对苹果开发感兴趣的开发者必学语言之一。

Swift对新手程序员友好。它是一种现代化编程语言，拥有和脚本语言一样的表现力。可以在Playground中编写Swift代码并立即查看结果，而无需构建和运行引用程序的开销。

Swift通过采用现代编程模式解决了大量常见的编程错误：

- 变量总是在使用前进行初始化。
- 检查数组索引是否有越界错误。
- 检查整数是否溢出。
- 可选选项确保显示处理nil值。
- 可选项确保显示处理nil值。
- 自动管理内存。
- 错误处理允许从异常中进行可选恢复。

Swift具有强大的类型推导能力和模式匹配与现代化语法的相互配合，允许我们使用简洁明了的方式表达复杂的想法。因此，代码不仅容易编写，而且更容易阅读与维护。

## 第一个Swift程序

```swift
print("Hello, world!!!")
```

如果你熟悉其它语言，例如python、c、Java、...，那么这个语法看起来就很熟悉，在swift中，这一行代码就是一个完整的程序。无需为输入输出字符串等处理导入单独的库。在全局范围内编写的代码作为程序的入口点，不需要使用main函数，也不需要在每个语句末尾写分号。

## 变量&常量

我们使用`let`来定义常量，使用`var`定义变量。常量的值不需要在编译时知道，但是需要为它预先分配值。你可以使用常量来定义一个你确定的值并且在多个地方使用它。

```swift
var myVariable = 42
myVariable = 43
let myConstant = 42
```

常量或变量必须与你要分配给它的值类型相同。你也可以不用显示编写类型。在创建常量或变量时提供值可以让编译器推断其类型。在上面的例子中，编译器判断`myVariable`是一个整数，因为它的初始值就是一个整数。

如果初始值没有足够信息推断变量的类型，可以通过在变量后指定类型，使用`:`指定。

```swift
let imlicitInteger = 70
let implicitDouble = 70.0
let explicitDouble: Double = 70
```

一个值永远都不会隐式转换成另一个类型。如果想转换为其它类型，请显示指定所需类型的实例。

```swift
let label = "the width is"
let width = 20
let widthLabel = label + String(width)
```

还有一种更简便的方法可以将值转换为字符串：将值写入括号中，并在括号前写一个反斜杠 `\`。

*例如:*

```swift
let width = 20
let widthLabel = "the width is \(width)"
```

## 文本块

对于占据多行的字符串，可以使用`"""`。删除每个引号开头的缩进，只需要它与结束引号的缩进匹配。例如：

```swift
let text = """
           Even though there's whitespace to the left,
           the actual lines aren't indented.
                Except for the line.
            Double quotes (") can appear without being escaped.

            I still have \(apples + oranges) pieces of fruit.
           """
```

## 数组&字典

使用中括号创建数组和字典`[]`，并使用括号写入索引或者字典key来访问其元素。

```swift
// 将下标为1的项目替换为 grapes
var fruits = ["strawberries","limes","tangerines"]
fruits[1] = "grapes"

var occupations = [
    "Malcolm":"Captain",
    "Maylee":"Mechanic",
]
// 往 Jayne 键中写入值 Public Relations
occupations["Jayne"] = "Public Relations"
```

可以使用append方法为数组添加值。

```swift
fruits.append("blueberries")
print(fruits)
```

也可以使用中括号来定义空数组或看那个字典。对于一个数组，使用`[]`，对于字典，使用`[:]`。

```swift
fruits = []
occupations = [:]
```

## 流程控制语句

可以使用`if`和`switch`来选择路径，并使用`for-in`、`while`和`repeat-while`来定义循环。条件和循环变量周围的括号是可选择的。

```swift
let individualScores = [75,43,103,87,12]
let teamScore = 0
for score in individualScores{
    if score > 50 {
        teamScore += 3
    }else{
        teamScore += 1
    }
}

print(teamScore)
```

可以使用`let if`和`let switch`语句对变量初始化路径进行选择。

```swift
let scoreDecoration = if teamScore >10{
    "yes"
}else{
    ""
}
print("Score:", teamScore, scoreDecoration)
```

可以使用`if let`表达式来处理可空值。可空值要么包含一个值，要么包含nil，以知识缺少一个值。在类型后面添加一个`?`，可以将值标记为可选值。

```swift
var optionalString:String? = "Hello"
print(optionalString == nil) //false

var optionalName:String? = "John"
var greeting = "Hello!"
//如果OptionalName有值，将其改名为name，就会执行方法体里的语句
//如果OptionalName值为nil，将会执行到else方法体
if let name = optionalName {
    greeting = "Hello,\(name)"
}else{
    greeting = "?"
}
// 可以不重命名进行结构
if let optionalName{
    print("Hey, \(optionalName)")
}
```

另一种处理可选值的方法是使用`??`来提供默认值。如果值为空，则使用默认值。

```swift
let nickname:String? = nil
let fullName:String = "John Appleseed"
let informalGreeting = "Hi \(nickname ?? fullName)"
```

`swift`支持任何类型的数据比较操作，不限于整数和相等测试，也可以调用方法。

```swift
let vegetable = "red pepper"
switch vegetable{
    case "celery":
        print("Add some raisins and make ants on a log.")
    case "cucumber","wathercress":
        print("That would make a good tea sandwich.")
    case let x where x.hasSuffix("pepper"):
        print("Is it a spicy \(x)")
    default:
        print("Everything tastes good in soup.")
}
```

使用`for-in`来迭代字典中的项目。字典是一个无序的集合，他们的键值可以以任意顺序进行迭代。

> 在Java&Kotlin中，map也是无序迭代，数据量小容易看不出来，有序迭代使用LinkedHashMap。

```swift
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
for (_, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
print(largest)
```

使用`while`对一块代码块进行循环，直到循环条件变为`false`。使用`repeat while`进行`do while`循环。

```swift
var n = 2
while n < 100 {
    n *= 2
}
print(n)

var m = 2
repeat {
    m *= 2
} while m < 100
print(m)
```

可以使用`..<`和`...`生成一个迭代序列，并在循环中使用。

> ..< 不包含上值，...包含上值

```swift
var total = 0
for i in 0..<4{
    total += i
}
print(total)
```

使用`func`进行方法的声明。

*示例：声明一个返回值为`String`的方法*

```swift
func greet(person:String,day:String) -> String{
    return "Hello \(person), today is \(day)"
}
greet(person:"Bob",day:"Tuesday")
```

> 在默认情况下，使用函数参数名作为参数标签，在参数名前可以编写自定义参数标签，也可以添加`_`不使用参数标签。

```swift
func greet(_ person:String,day:String) -> String{
    return "Hello \(person), today is \(day)"
}
greet("Bob",day:"Tuesday")
```

使用元组充当返回值，例如：

```swift
func calculateStatistics(scores: [Int])->(min: Int, max: Int, sum: Int){
    var min = scores[0]
    var max = scores[0]
    var sum = 0


    for score in scores {
        if score > max {
            max = score
        } else if score < min {
            min = score
        }
        sum += score
    }


    return (min, max, sum)
}
let statistics = calculateStatistics(scores: [5, 3, 100, 3, 9])
print(statistics.sum)
print(statistics.2)
```

使用函数当成参数进行传递

```swift
func hasAnyMatches(list: [Int], condition: (Int) -> Bool) -> Bool {
    for item in list {
        if condition(item) {
            return true
        }
    }
    return false
}
func lessThanTen(number: Int) -> Bool {
    return number < 10
}
var numbers = [20, 19, 7, 12]
hasAnyMatches(list: numbers, condition: lessThanTen)
```

定义闭包

> 这个闭包给所有进来的数字进行+1操作并返回出去。

```swift
let inc = {
    (i: Int) -> Int in
    return i+1
    
}
```

你可以更简洁的传递闭包，当闭包的类型是已知的时候，你可以省略参数类型和返回值。

```swift
let numbers = [1,2,3,4,5]
let incs=numbers.map{num in num + 1 }
```

## 参考链接
