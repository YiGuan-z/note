# 数据结构和数据持久化

在swift中，有`class`和`struct`可以定义数据类型，我们一般使用`struct`来对数据进行定义。因为结构体是值类型，赋给另一个变量的时候会创建一个副本而不影响原类型。

但在某些情况下使用`class`类型更合适，这取决于是否需要变量引用到同一实例。

## 创建一个用户界面

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
