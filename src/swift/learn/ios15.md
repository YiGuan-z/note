# IOS15

在ios15中，增加了一系列全新API，让我们来看看吧。

## AsyncImage

```admonish info
这是一个异步图像API，需要你将url传入，它就能自动获取远程图像并展示出来。
```

示例：

```swift
struct AsyncImageBootcamp: View {
    let remoteImage = URL(string: "https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307301856642.gif")
    var body: some View {
        VStack{
            AsyncImage(url: remoteImage){ remoteImage in
                remoteImage
                    .resizable()
                    .scaledToFill()
                    .frame(width:150,height:150)
                    .cornerRadius(10)
                
                
            } placeholder: {
              ProgressView()
            }

            AsyncImage(url: remoteImage) { remoteImage in
                switch remoteImage{
                case .empty:
                    ProgressView()
                case .success(let img):
                    img
                        .resizable()
                        .scaledToFill()
                        .frame(width:150,height:150)
                        .cornerRadius(10)
                case .failure:
                    Image("questionmark")
                        .font(.headline)
                default:
                    Image("questionmark")
                        .font(.headline)
                }
            }
        }
    }
}
```

## Material

```admonish info
这是一种背景材料的类型。可以使用`background`修饰符往里面添加材料，实现模糊效果。
```

~~~admonish example
```swift
struct BackgroundMateialsBootcamp: View {
    var body: some View {
        VStack{
            Spacer()
            VStack{
                RoundedRectangle(cornerRadius: 4.0)
                    .frame(width: 50,height: 4)
                    .padding()
                Spacer()
                
            }
            .frame(height: 350)
            .frame(maxWidth: .infinity)
            //半透明
            .background(.thinMaterial)
            .cornerRadius(30)
        }
        .ignoresSafeArea()
        .background(
            AsyncImage(url: URL(string: "https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307301856642.gif"))
        )
    }
}
```
~~~

## TextSelection

```admonish info
这是一个决定是否可以选择文本的修饰符
```

~~~admonish example
```swift
Text("Hello,World!")
    .textSelection(.enabled)
```
~~~

## ButtonStyle

```swift
Button("Button"){
            
    }
    .frame(height: 50)
    .frame(maxWidth: .infinity)
    .buttonStyle(.borderedProminent)
```

## swipeActions

```admonish info
它可以为列表中的行添加自定义滑动操作，可以使用 `swipeActions` 修饰符来指定滑动操作的位置。
```

下面是一个demo

```swift
struct ListSwipeactionBootcamp: View {
    @State var fruits :[String] = [
        "apple","orange","banana"
    ]
    var body: some View {
        List{
            ForEach(fruits,id: \.self){ fruit in
                Text(fruit.capitalized)
                    .swipeActions(edge:.trailing,allowsFullSwipe: true){
                        Button("删除"){
                            if let index = fruits.firstIndex(of: fruit){
                                removeFruits(index)
                            }
                            
                        }
                        .tint(.red)
                        Button("详细信息"){
                            
                        }
                        .tint(.green)
                    
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: true) {
                        Button("共享"){
                            
                        }
                        .tint(.yellow)
                    }
            }
        }
        .background(Color.purple.ignoresSafeArea())
    }
    func removeFruits(_ index:Int){
        fruits.remove(at: index)
    }
}
```

## badge

```admonish info
这是一个提示器

只能使用在`List`、`Tab bars`、`Menus`中。
```

```swift
var body: some View {
    //List rows
    //Tab bars
    //Menus
    
    TabView {
        Color.red
            .tabItem {
                Image(systemName: "heart.fill")
                Text("hello")
            }
            .badge(5)
        
        Color.green
            .tabItem {
                Image(systemName: "heart.fill")
                Text("hello")
            }
            .badge(10)
        
        Color.yellow
            .tabItem {
                Image(systemName: "heart.fill")
                Text("hello")
            }
            .badge(15)
    }
}
```

## @FocusState

```admonish info
@FocuState可以用来切换应用程序的焦点。

例如我们的登陆页面，通常而言程序启动的时候焦点位于用户名输入框就好。
```

我们也可以手动控制焦点，例如，我们有两个输入框和一个按钮，这时候我们点击按钮对输入框内容检测，如果有哪个条件检测成功，我们就可以设置为对应的程序焦点。

```swift
struct LoginForm {
    enum Field: Hashable {
        case usernameField
        case passwordField
    }


    @State private var username = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?


    var body: some View {
        Form {
            TextField("Username", text: $username)
                .focused($focusedField, equals: .usernameField)


            SecureField("Password", text: $password)
                .focused($focusedField, equals: .passwordField)


            Button("Sign In") {
                if username.isEmpty {
                    focusedField = .usernameField
                } else if password.isEmpty {
                    focusedField = .passwordField
                } else {
                    handleLogin(username, password)
                }
            }
        }
    }
}
```

## onSubmit & submitLabel

`onSubmit`将会在用户提交一个值的时候执行一个操作

`submitLabel`将会为键盘右下角显示对应的枚举值

例如下面这段代码的键盘显示的是：

```swift
@State private var currentText=""
@State private var showAlert = false
var body: some View {
    ZStack{
        Color.purple.ignoresSafeArea()
        VStack{
            TextField("请输入提示内容", text: $currentText)
                .submitLabel(.continue)
                .onSubmit {
                    showAlert.toggle()
                }
                .background()
                .cornerRadius(10)
        }
        .padding()
        
    }
    .alert(isPresented: $showAlert, content: {
        Alert(title:Text("这是一条提示消息"),message: Text(currentText))
    })
    
}
```

```admonish info title="image" collapsible=true
![image](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202308051536015.jpg)
```

