# 安全编码指南🧑‍💻

这是一个寻常的获取并展示数据的页面。

```swift
@State var displayText:String = ""
var body: some View {
    NavigationView{
        VStack{
            Text("Here we are practicing safe coding!")
            Text(displayText)
                .font(.title)
            Spacer()
        }
        .navigationTitle("Safe coding")
        .onAppear(perform:loadData)
    }
}

func loadData(){
    DispatchQueue.main.asyncAfter(deadline: .now()+5) {
        displayText = "This is the new Data!"
    }
}
```

我们想要让`Text(displayText)`在为空字符串的时候不要将`Text`这个组件渲染出来。

可以使用`if let`进行数据判断，如果不为`nil`就渲染。

```swift
@State var displayText:String?

if let displayText{
    Text(displayText)
        .font(.title)
}
//你也可以写成这种
if let text = displayText{
    Text(displayText)
        .font(.title)
}
```

我们可以为视图添加上加载页面常用的转圈圈。

![转圈圈](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307301856642.gif)

```swift
@State var displayText:String?
@State var isLoading = false
var body: some View {
    NavigationView{
        VStack{
            Text("Here we are practicing safe coding!")
            if let displayText{
                Text(displayText)
                    .font(.title)
            }
            
            if isLoading{
                ProgressView()
            }
            
            Spacer()
        }
        .navigationTitle("Safe coding")
        .onAppear(perform:loadData)
    }
}

func loadData(){
    isLoading = true
    DispatchQueue.main.asyncAfter(deadline: .now()+5) {
        displayText = "This is the new Data!"
        isLoading = false
    }
}
```

当然，我们还可以检查当前视图有没有一些用户信息什么的，如果有，则正常加载数据，如果没有，则填充一个错误信息。

```swift
@State var userId:String?
@State var displayText:String?
@State var isLoading = false
var body: some View {
    NavigationView{
        VStack{
            Text("Here we are practicing safe coding!")
            if let displayText{
                Text(displayText)
                    .font(.title)
            }
            
            if isLoading{
                ProgressView()
            }
            
            Spacer()
        }
        .navigationTitle("Safe coding")
        .onAppear(perform:loadData2)
    }
}

func loadData(){
    isLoading = true
    DispatchQueue.main.asyncAfter(deadline: .now()+5) {
        displayText = "This is the new Data!"
        isLoading = false
    }
}

func loadData2(){
    isLoading = true
    guard (userId != nil) else {
        displayText = "Error There is no user id"
        isLoading = false
        return
    }
    DispatchQueue.main.asyncAfter(deadline: .now()+5) {
        displayText = "This is the new Data!"
        isLoading = false
    }
    
}
```

这里我们使用了`guard`语句，他们好像俗称卫语句。

该语句的作用为保护方法的变量，如果卫语句判断为`false`，那么它就会退出这个方法，不会进行后续执行，如果是`if let`语句，即使判断不成立也不会影响该方法的后续执行。

```admonish warning title="强制解包需注意"
好的代码总会正确使用`!`，如果看到这个，就仔细检查有没有可能性会为`nil`。

没有为`nil`的可能性还好，如果有这个可能性将会引发巨大的麻烦。
```
