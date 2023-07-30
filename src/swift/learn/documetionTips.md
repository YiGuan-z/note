# 新手开发者请注意

**又名，程序员防止枪击指南。**

## 组件逻辑要清晰

组件的逻辑最好要清晰的呈现出来

如果有一个组件在许多地方都能够复用，那么最好将它抽取为一个方法。

### 不要讲将鸡蛋放到一个篮子里

```admonish warning
如果有一个组件，它的`body`里面的内容包含了一大堆让人不想看的控制判断和组件声明的话{{footnote:如果两次没有看懂，那么这个组件可以重构了，不然就是💩山要开始堆起来了。}}，那么这个组件将会是失败的并且极难维护。
```

如果有一个组件的修饰符很长很长，干扰到阅读代码的效率，那么就可以将它声明为该结构体中的一个变量或者抽取为一个子视图。

如果需要对组件的创建流程进行控制，传入不同参数就输出不一样的组件，那么使用方法进行封装是最好的选择。

如果一个组件的泛用性很广，那么可以将这些泛用性广的代码抽取到一个文件或文件夹中。

### 多用注释

```admonish error title="警告"
曾经有个人，因为他的代码从不写注释，并且逻辑非常混乱，同事提枪上门，然后他死了。

除非你的逻辑非常浅显易懂，否则不要不写注释或说明文档。

不然喜提🩸👴<---🚄🔫🤬
```

与其它语言一样，swift也有着单行注释和多行注释

单行注释使用`//`即可

多行注释使用

```swift

//单行注释

/*
多行注释
*/

//带标题的多行注释
/*

*/
```

```admonish info
对于一个组件，最好的方法是使用`// MARK:`注释对你这个组件的功能区域进行注释
```

~~~admonish example
需要打开`Minimap`~~卧槽，中文名叫啥来着~~
```swift
struct DarkModeBootcamp: View {
    // MARK: 变量
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        // MARK: 导航视图
        NavigationView{
            ScrollView{
                VStack(spacing:20){
                    Text("This color is PRIMARY")
                        .foregroundColor(.primary)
                    
                    Text("This color is SECONDARY")
                        .foregroundColor(.secondary)
                    
                    Text("This color is black")
                        .foregroundColor(.black)
                    
                    Text("This color is white")
                        .foregroundColor(.white)
                    
                    Text("This Color is globally adaptive!")
                        .foregroundColor(Color("AdaptiveColor"))
                    
                    Text("This color is locally adaptive!")
                        .foregroundColor(colorScheme == .light ? .blue:.yellow)
                }
            }
            .navigationTitle("Dark Mode Bootcamp")
        }
    }
}
// MARK: 预览视图
#Preview {
        DarkModeBootcamp()
}
```
~~~

效果如下：
![效果](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307301601125.jpg)

与其相似的注释标记还有

- //MARK: - 这是一个带分割线的标记
- //TODO: 待办事项
- //FIXME: 需要修复的问题

如果有些时候，你实在理不清代码结构，例如这个`{`的`}`在那里。

你可以使用单行注释事先为他们标记上，例如。

![标记代码范围](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307301638170.jpg)

不要忘记添加说明性的注释。

在一个方法的头顶，使用`///`即可声明一个方法注释，这样别人就能够快速查看这个api在做什么，例如：

![api示例](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307301653662.jpg)

![api文档示例](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307301654648.jpg)

也可以在注释里面编写示例代码。

![完整的方法注释](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307301702500.jpg)

现在，按住option，点击方法名，看看效果吧。
