# 数据结构和数据持久化

在swift中，有`class`和`struct`可以定义数据类型，我们一般使用`struct`来对数据进行定义。因为结构体是值类型，赋给另一个变量的时候会创建一个副本而不影响原类型。

但在某些情况下使用`class`类型更合适，这取决于是否需要变量引用到同一实例。

## 自定义数据结构并创建一个界面

```swift
struct ModelBootcamp: View {
    @State var users:[String] = ["Cheng","Nick","sonoma","Chris"]
    var body: some View {
        NavigationView{
            VStack{
                List{
                    ForEach(users, id: \.self) { user in
                        HStack(spacing:25){
                            Circle()
                                .frame(width: 35,height: 35)
                            
                            Text(user)
                                
                        }
                        .padding(.vertical,10)
                    }
                }
            }
            .navigationTitle("Users")
        }
    }
}

#Preview {
    ModelBootcamp()
}
```

```admonish quote collapsible=true title="一点叨叨"
swift让我最爱的就是它会默认创建一个无参构造和一个全参构造。

点名批评java，`get`,`set`到处飞，这么久了才出一个`record`，还不好用。

最重要的一点是，没有自带的`copy`函数，想要修改就只能重新创建一个，但是传入参数的时候好烦人。
```

我们真实的用户数据肯定不会是一个字符串数组，因此我们需要声明一个结构体。

```swift
struct UserModel {
    let dispayName:String
    let userName:String
    let followerCount:Int
}
```

更新我们的用户数据

```swift
@State var users:[UserModel] = [
        UserModel(dispayName: "ChengCY", userName: "Cheng", followerCount: 5),
        UserModel(dispayName: "Nick", userName: "Nick", followerCount: 5),
        UserModel(dispayName: "Sonoma", userName: "Sonoma", followerCount: 5),
        UserModel(dispayName: "Chris", userName: "Chris", followerCount: 5)
    ]
```

因为我们没有为用户模型实现`Hashable`协议，所以我们无法使用这个带id的forEach循环。

![错误](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307302227380.jpg)

让我们换为不使用id的ForEach循环

出现了一个新错误。

![error](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307302230107.jpg)

这个错误就很好解决，我们为结构体实现这个协议即可。

```swift
struct UserModel:Identifiable {
    let id: String = UUID().uuidString
    let dispayName:String
    let userName:String
    let followerCount:Int
}
```

```admonish note title="拓展" collapsible=true
让我们看一下`Identifiable`协议的定义，它有一个关联类型为ID，它必须实现`Hashable`协议，没错，就是需求id的那个ForEach所需要的协议实现。

使用`Identifiable`只是让它绕了个路，最终目标还是`Hashable`。

里面还声明了一个id属性，它的类型就是刚才的关联类型ID。
![源码](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307302233496.jpg)
```

让我们修改`ForEach`中的内容。

为它添加用户名和关注数量

```swift
ForEach(users) { user in
    HStack(spacing:25){
        Circle()
            .frame(width: 35,height: 35)
        
        VStack(alignment: .leading){
            Text(user.dispayName)
                .font(.headline)
            Text("@\(user.userName)")
                .foregroundColor(.blue)
                .font(.caption)
        }
        Spacer()
        VStack {
            Text("\(user.followerCount)")
            Text("Followers")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
    .padding(.vertical,10)
}
```

最后我们为这个界面添加是否验证的标记。

首先修改结构体，添加一个是否验证的属性。

```swift
struct UserModel:Identifiable {
    let id: String = UUID().uuidString
    let dispayName:String
    let userName:String
    let followerCount:Int
    let isVerified:Bool
}
@State var users:[UserModel] = [
        UserModel(dispayName: "ChengCY", userName: "ChengCY2829", followerCount: 5,isVerified: true),
        UserModel(dispayName: "Nick", userName: "Nick123", followerCount: 10,isVerified: true),
        UserModel(dispayName: "Sonoma", userName: "Sonoma562", followerCount: 15,isVerified: false),
        UserModel(dispayName: "Chris", userName: "Chris234", followerCount: 20,isVerified: false)
    ]
```

最后，再修改我们`ForEach`中的内容。

```swift
ForEach(users) { user in
    HStack(spacing:25){
        Circle()
            .frame(width: 35,height: 35)
        
        VStack(alignment: .leading){
            Text(user.dispayName)
                .font(.headline)
            Text("@\(user.userName)")
                .foregroundColor(.blue)
                .font(.caption)
        }
        Spacer()
        
        if user.isVerified{
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.blue)
        }
        
        VStack {
            Text("\(user.followerCount)")
            Text("Followers")
                .foregroundColor(.gray)
                .font(.caption)
        }
    }
    .padding(.vertical,10)
}
```

## @ObservableObject & @StateObject

先创建一个通过自定义数据结构创建的视图页面

```swift
struct FruitModel:Identifiable {
    let id: String = UUID().uuidString
    let name:String
    let count:Int
}

struct ViewModelBootcamp: View {
    @State var fruitArray:[FruitModel] = []
    var body: some View {
        NavigationView{
            List{
                ForEach(fruitArray){ fruit in
                    HStack{
                        Text("\(fruit.count)")
                            .foregroundColor(.red)
                        Text("\(fruit.name)")
                            .font(.headline)
                            .bold()
                        
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Fruit List")
            .onAppear{getFruits()}
            
            
        }
    }
    
    func getFruits(){
        let fruit1 = FruitModel(name: "Apples", count: 5)
        let fruit2 = FruitModel(name: "Banana", count: 10)
        let fruit3 = FruitModel(name: "Orange", count: 15)
        fruitArray.append(fruit1)
        fruitArray.append(fruit2)
        fruitArray.append(fruit3)
    }
    
}

#Preview {
    ViewModelBootcamp()
}
```

让我们来尝试编写列表的删除。

~~~admonish example title="栗子" collapsible=true
```swift
func deleteFruit(index:IndexSet){
        fruitArray.remove(atOffsets: index)
}

List{
    ForEach(fruitArray){ fruit in
        HStack{
            Text("\(fruit.count)")
                .foregroundColor(.red)
            Text("\(fruit.name)")
                .font(.headline)
                .bold()
            
        }
    }
    .onDelete(perform: deleteFruit)
}
.listStyle(GroupedListStyle())
.navigationTitle("Fruit List")
.onAppear{getFruits()}

```
~~~

现在，我们需要将页面逻辑和业务逻辑分离开来，一个页面中不应该存在业务逻辑层面的方法，除非这个页面是专门为该业务逻辑定制的一个专用页面{{footnote:就是将与渲染页面无关的方法分离出去，例如`deleteFruit`和`getFruits`}}。

我们来编写一个class，专门用于管理`Fruit`数据的一个class。

```admonish info title="@Published" collapsible=true
`@Published`可以用来创建一个可观察的对象，当对象的属性发生了变化，它就会自动通知观察者。当你使用`@Published`标记一个属性的时候，SwiftUI会自动监听属性的变化，并在属性发生变化的时候刷新视图。
```

```swift
class FruitViewModel{
    @Published var fruitArray:[FruitModel] = []
    
    func getFruits(){
        let fruit1 = FruitModel(name: "Apples", count: 5)
        let fruit2 = FruitModel(name: "Banana", count: 10)
        let fruit3 = FruitModel(name: "Orange", count: 15)
        fruitArray.append(fruit1)
        fruitArray.append(fruit2)
        fruitArray.append(fruit3)
    }
    
    
    func deleteFruit(index:IndexSet){
        fruitArray.remove(atOffsets: index)
    }
}
```

修改视图中的数据对象

```swift
var fruitViewModel:FruitViewModel = FruitViewModel()
```

将我们的`onAppear`和`onDelete`修改为如下所示。

```swift
.onAppear(perform: fruitViewModel.getFruits)
.onDelete(perform: fruitViewModel.deleteFruit)
```

别忘了修改ForEach中的遍历对象。

这时候，我们就会发现预览中没有数据，因为我们没有使用`@ObservedObject`对`fruitViewModel`进行标注。

加入标注后，我们会遇到如下错误。
![错误](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307311915839.jpg)

这时，我们只需要按照错误内容所述，让`FruitViewModel`实现`ObservableObject`协议即可。

```admonish info collapsible=true
`ObservableObject`协议用于标注实现该协议的对象都是一个观察对象，里面的`@Published`代表了具体哪个字段发生变化就刷新UI。

同时，我们在视图层使用`@ObservedObject`标注的好处在于，**不是所有可观察对象的更改都需要刷新视图**，具体哪些可观察对象需要刷新视图由我们自己定义即可。
```

我们再增加一个加载时转圈圈功能

```admonish info collapsible=true
![转圈圈](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307301856642.gif)

好想做一个黑塔转圈圈。
```

让我们对`FruitViewModel`进行修改。

使用了无主引用对self进行捕获。

```swift
class FruitViewModel :ObservableObject{
    @Published var fruitArray:[FruitModel] = []
    @Published var isLoading: Bool = false
    
    func getFruits(){
        isLoading = true
        let fruit1 = FruitModel(name: "Apples", count: 5)
        let fruit2 = FruitModel(name: "Banana", count: 10)
        let fruit3 = FruitModel(name: "Orange", count: 15)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5)  {[unowned self] in
            fruitArray.append(fruit1)
            fruitArray.append(fruit2)
            fruitArray.append(fruit3)
            isLoading = false
        }
    }
    
    
    func deleteFruit(index:IndexSet){
        fruitArray.remove(atOffsets: index)
    }
}
```

```admonish info collapsible=true
不要被其它语言便利的闭包忽悠导致忘记闭包本身也是有点引用问题的东西。

[来看看这个](./index.md#自动引用计数)
```

再修改我们的List组件

```swift
List{
    if fruitViewModel.isLoading{
        //我比较喜欢在中间
        HStack{
            Spacer()
            ProgressView()
            Spacer()
        }
    }else{
        ForEach(fruitViewModel.fruitArray){ fruit in
            HStack{
                Text("\(fruit.count)")
                    .foregroundColor(.red)
                Text("\(fruit.name)")
                    .font(.headline)
                    .bold()
                
            }
        }
        .onDelete(perform: fruitViewModel.deleteFruit)
    }
}
.listStyle(GroupedListStyle())
.navigationTitle("Fruit List")
.onAppear(perform: fruitViewModel.getFruits)      
```

可以使用`@StateObject`来代替`@ObservedObject`，前者在视图刷新的时候不会重新加载，后者会在视图刷新的时候重新加载。相当于前者是每次都引用的一个对象重新加载的时候不会销毁，后者是每次都创建一个对象，如果视图被重新加载，它也会重新创建和销毁。
