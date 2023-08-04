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

