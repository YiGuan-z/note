# 布局与控件

## 组件

### Text

```swift
//.capitalized是大写选项卡
Text("hello,world".capitalized)
        //字体
            .font(.caption)
        //文字粗细
            .fontWeight(.black)
        //使用粗体
            .bold()
        //下划线
            .underline(true,color: Color.black)
        //使用拉丁字体
            .italic()
        //文字删除线
            .strikethrough(true,color: Color.green)
        //基线偏移量
            .baselineOffset(-10.0)
        //在每个字之间添加一点间距
            .kerning(1.0)
        //多行文本对齐方式
            .multilineTextAlignment(.center)
        //文字前景色
            .foregroundColor(.red)
        //添加一个盒子对内容进行限制
            .frame(width: 200,height: 100,alignment: .center)
        //缩放
            .minimumScaleFactor(0.1)
```

### Creating Shapes

```admonish
`.fill`和`.foregroundColor`的区别是前者为指定的形状填充颜色，后者会改变文本和模版渲染元素的颜色。
```

```swift
// Ellipse()
//Capsule(style: .continuous)
RoundedRectangle(cornerRadius: 10.0)
//Circle()
        //填充颜色
        //.fill(.red)
        //描边
        //.stroke(Color.blue,style: StrokeStyle(lineWidth: 30,lineCap: .round,dash: [40]))
        //修剪✂️
        //.trim(from: 0.2,to: 1)
        //.stroke(Color.pink,lineWidth: 30)
        //设置前景色 会改变文本和模版渲染元素的颜色。
        //.foregroundColor(.green)
        //.frame(width: 300,height: 200)
```

将这些修饰符组合起来，可以获得一些非常好的效果。

### Color

```admonish info
`Color.primary`会自动根据设备的显示模式(深色模式&浅色模式)来切换黑白。

~~我们还可以在`Assets.xcassets`中自定义自己的颜色，由于视频里面的代码中使用的拾色器在这个版本中找不到（根据弹幕内容，这个功能好像无了。），所以只能在`Assets.xcassets`中设置颜色。~~

经过群佬的补充，可以使用宏来进行颜色设定。

![](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307291500651.jpg)

![](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307291502171.jpg)

最后打个括号，即可唤出拾色器
![](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307291503778.jpg)

在`Assets.xcassets`中设置完颜色后，就可以在代码中使用这个颜色了，在构造Color的时候传入在`Assets.xcassets`中自定义颜色的名称即可使用。

```

### Gradients

做设计的时候不要使用颜色太过于激烈的渐变

- linear gradinets {{footnote:线性渐变}}
- angular gradients {{footnote:径向渐变}}
- radial gradients {{footnote:角度渐变}}

```swift
RoundedRectangle(cornerRadius: 25.0)
            .fill(
                //线性渐变
//                LinearGradient(
//                    //色彩
//                    gradient:Gradient(colors: [Color.red, Color.blue,Color.orange,Color("CustomColor")]),
//                    //开始位置
//                    startPoint: .topLeading,
//                    //结束位置
//                    endPoint: .bottomTrailing
//                )
                //径向渐变
//                RadialGradient(
//                    colors: [Color.red,Color.green],
//                    center: .topLeading,
//                    startRadius: 5,
//                    endRadius: 400
//                )
                //角度渐变
//                AngularGradient(
//                    gradient: Gradient(colors: [Color.primary, Color.blue]),
//                    center: .bottomTrailing,
//                    angle: .degrees(180+45)
//                )
            )
            .frame(width: 300,height: 200)
```

### System Icon

可以使用apple设计资源网站中获取的SF symbols，里面可以检查并使用系统自带的一些图标。

```swift
        Image(systemName: "person.fill.badge.plus")
        //渲染模式
            .renderingMode(.original)
        //自动调整大小
//            .resizable()
            .font(.largeTitle)
        //缩放以适应盒子
//            .scaledToFit()
        //按照比例来填充盒子
//            .scaledToFill()
        //盒子大小
//            .frame(width: 300,height: 300)
        //前景色
            .foregroundColor(.yellow)
        //裁剪超出边框的部分
            .clipped()
            
```

### Image

```swift
        Image(systemName: "person.fill.badge.plus")
            .renderingMode(.original)
//            .resizable()
            .font(.largeTitle)
            .scaledToFit()
//            .scaledToFill()
//            .frame(width: 300,height: 300)
            .foregroundColor(.yellow)
        //裁剪超出边框的部分
//            .clipped()
```

### Farme

```swift
//        Text("Hello, World!")
//            .frame(width: 100)
//            .background(Color.blue)
//        //设置最大宽度为无穷，最大高度为无穷
//            .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .topLeading)
//            .background(Color.red)
        Text("Hello World!@")
            .background(Color.red)
            .frame(height: 100)
            .background(Color.orange)
            .frame(height: 150)
            .background(Color.purple)
            .frame(maxWidth: .infinity)
            .background(Color.pink)
            .frame(height: 400)
            .background(Color.green)
            .frame(maxHeight: .infinity)
            .background(Color.yellow)
```

### Backgrounds and Overlays

怎么说呢，非常的有组件化前端开发的感觉，可以让写TS的人没事来客串客串一下这些声明式布局，反正他们熟。

```swift
Text("Hello, World!")
            .background(
                Circle().fill(
                LinearGradient(
                    gradient: Gradient(colors: [Color.red, Color.blue]),
                    startPoint: .leading,
                    endPoint: .trailing)
                )
                .frame(width: 100,height: 200,alignment: .center)
            )
            .background(
                Circle()
                    .fill(LinearGradient(
                    gradient: Gradient(
                        colors: [Color.blue, Color.red]),
                        startPoint: .leading,
                        endPoint: .trailing)
                    )
                    .frame(width: 150,height: 150,alignment: .center)
                
            )

Circle()
            .fill(Color.red)
            .frame(width: 200,height: 200)
            .overlay(
                Text("我是一段文本")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
            )
            .background(
            Circle()
                .fill(Color.purple)
                .frame(width: 220,height: 220)
            )

//▪️套▪️
Rectangle()
            .frame(width: 100,height: 100)
            .overlay(
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 50,height: 50)
                ,
                alignment: .center
            )
            .background(
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 150,height: 150),
                alignment: .center
            )

// 绘制一个图标
Image(systemName: "heart.fill")
            .font(.system(size: 40))
            .foregroundColor(.white)
            .background(
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.red,Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100,height: 100)
                    .shadow(color:.purple,radius: 10,y: 10)
                    .overlay(
                        Circle()
                            .fill(Color.purple)
                            .frame(width: 35,height: 35)
                            .overlay(
                                Text("5")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    
                            )
                            .shadow(color:.purple,radius: 10,x: 5, y: 10),
                        alignment: .bottomTrailing
                    )
                    
            )
```

### VStack,Hstack, and ZStack

VStacks -> Vertical{{footnote:垂直}}

Hstacks -> Horizontal{{footnote:水平}}

ZStacks -> zIndex (back to front){{footnote:堆叠}}

可以将以下的`ZStack`替换为`VStack`和`HStack`并进行观察。

在`VStack`的`spacing`参数中，如果`spacing`为`nil`，那么默认的分割间距就为8。如果不想要间距，那么可以直接设置为0。

```swift
        ZStack {
            Rectangle()
                .fill(Color.red)
                .frame(width: 110,height: 110)
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 80,height: 80)
            Rectangle()
                .fill(Color.blue)
                .frame(width: 50,height: 50)
        }

        VStack(spacing: 0)  {
            Rectangle()
                .fill(Color.red)
                .frame(width: 50,height: 50)
            
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 50,height: 50)
            
            Rectangle()
                .fill(Color.blue)
                .frame(width: 50,height: 50)
        }

        ZStack(alignment:.top){
            Rectangle()
                .fill(Color.yellow)
                .frame(width: 350,height: 500,alignment: .center)
            VStack(alignment:.leading){
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 150,height: 150)
                
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 100,height: 100)
                                
                HStack(alignment:.bottom) {
                        Rectangle()
                            .fill(Color.purple)
                            .frame(width: 50,height: 50)
                        
                        Rectangle()
                            .fill(Color.pink)
                            .frame(width: 75,height: 75)
                        
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 25,height: 25)
                    }
                    .background(Color.white)

            }.background(Color.black)
        }
```

### padding

```swift
VStack(alignment:.leading) {
    Text("Hello, World!")
        .font(.largeTitle)
    .fontWeight(.semibold)
    .padding(.bottom,10)
    
    Text("this is the description of what we weil do on this screen. Is is multiple lines and we will align the text to the leading edge.")
        
}
.padding()
.padding(.vertical,10)
.background(
    Color.white
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 10,x: 0.0,y: 10)
)
.padding(.horizontal,10)
```

### Spacer

spacer会对内容进行隔离操作，它会自动调整大小，并填满一个盒子。

```swift
    HStack(spacing:0){
        Spacer()
        
        Rectangle()
            .fill(Color.red)
            .frame(width: 50,height: 50)
        
        Spacer()
                        
        Rectangle()
            .fill(Color.yellow)
            .frame(width: 50,height: 50)
        
        Spacer()
        
        Rectangle()
            .fill(Color.blue)
            .frame(width: 50,height: 50)
        
        Spacer()
    }

VStack {
        HStack (spacing:0){
            Image(systemName: "xmark")
            Spacer()
            Image(systemName: "gear")
        }
        .font(.title)
        .padding(.horizontal)
        
        Spacer()
        
        Rectangle()
            .fill(Color.red)
            .frame(width: 50,height: 50)
        
        Spacer()
                        
        Rectangle()
            .fill(Color.yellow)
            .frame(width: 50,height: 50)
        
        Spacer()
        
        Rectangle()
            .fill(Color.blue)
            .frame(width: 50,height: 50)
        
        Spacer()
```

### inits and enums

这一集主要讲述了如何定义多个地方共同使用的变量，并且自定义一个结构体的构造函数，算是编程基础。swift会为所有未赋值的变量默认生成一个构造器。

```swift
import SwiftUI
enum Fruit {
    case apple;
    case oranges;
    case other(Color,String)
}

struct InitializerBootcamp: View {
    let backgroundColor :Color
    
    let count: Int
    
    let title :String
    
   
    init(backgroundColor: Color, count: Int, title: String) {
        self.backgroundColor = backgroundColor
        self.count = count
        self.title = title
    }
    
    init(fruit:Fruit,count:Int) {
        let (color,title) = switch fruit{
        case .apple:
            (Color.red,"Apples")
        case .oranges:
            (Color.yellow,"Oranges")
        case .other(let c, let s):
            (c,s)
        }
        self.backgroundColor = color
        self.count = count
        self.title = title
    }
    
    var body: some View {
        VStack(spacing:12){
            Text("\(count)")
                .font(.largeTitle)
                .foregroundColor(.white)
                .underline()
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 150,height: 150)
        .background(backgroundColor)
        .cornerRadius(10)
    }
}

#Preview {
    VStack{
        HStack{
            InitializerBootcamp(fruit: .apple, count: 5)
            
            InitializerBootcamp(fruit: .oranges, count: 5)
        }
        
        HStack{
            InitializerBootcamp(fruit: .apple, count: 5)
            
            InitializerBootcamp(fruit: .oranges, count: 5)
        }
    }
    
}

```

### ForEach and loops

`ForEach`语句在想要重复ui元素的时候就可以使用它们

```swift
let data: [String] = ["hi","hello world"]
    
var body: some View {
    VStack{
        ForEach(data.indices){ item in
            HStack{
                Text("\(data[item])")
            }
        }
    }
    
}    
var body: some View {
    VStack{
        ForEach(0..<4){ item in
            HStack{
                Text("index: \(item)")
            }
        }
    }
        
    }
```

### ScrollView

`ScrollView`可以对ui进行滚动，避免数据显示被截断，将其完整的展示出来。

还谈到了懒加载`VStack`，只需要在`Vstack`加上`Lazy`，即可变更为懒加载堆栈。

懒加载堆栈适用于内部组件过多或者需要网络加载大量内容的场景，会在滑动时进行创建。

```swift
ScrollView{
            VStack{
                ForEach(0..<50){ item in
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color.yellow)
                        .frame(width: .infinity,height: 300)
                        .shadow(radius: 10,x: 5,y:10)
                        .padding()
                        .overlay(
                                Text("\(item)")
                                    .foregroundColor(.blue)
                                    .font(.largeTitle),
                                alignment: .center
                        )
                        
                }
            }
        }
```

### LazyVGrid

讲述了如何编写适应性网格布局，swiftui中的所有网格都是惰性的。

nice，开始熟练起来了，是个好兆头。

```swift
    
    let colums:[GridItem] = [
        //fixed 为固定大小
//        GridItem(.fixed(50),spacing: nil,alignment: nil),
        //柔软的，会将内容延申
        GridItem(.flexible(),spacing: 1,alignment: nil),
        GridItem(.flexible(),spacing: 1,alignment: nil),
        GridItem(.flexible(),spacing: 1,alignment: nil),
        //自适应内容大小 不够放置 会自动扩展列
//        GridItem(.adaptive(minimum: 50, maximum: 300),spacing: nil,alignment: nil),
    ]
    
    var body: some View {
        
        ScrollView{
            Rectangle()
                .fill(Color.white)
                .frame(height: 400)
                .overlay(
                    VStack{
                        Circle()
                            .stroke(Color.blue,lineWidth:2)
                            .shadow(color:Color.blue,radius: 10,x: 5,y: 10)
                            .frame(height: 100)
                        Text("ChengCY")
                            .font(.title)
                        Rectangle()
                            .fill(Color.white)
                            .overlay(
                                Text("我是用户介绍，这是一大段测试文本，我喜欢Java，kotlin，javascript，typescript，swift，rust，讨厌python的诡异语法，因为我看不懂里面的参数在怎么传递的。")
                            ,alignment: .topLeading
                            )
                            .padding()
                    },
                    alignment: .top
                )
            
            LazyVGrid(
                columns: colums,
                alignment: .center,
                spacing: 1,
                pinnedViews: [.sectionHeaders],
                content: {
                    Section(header:
                                Text("Section 1")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .background(Color.blue)
                        .font(.title)
                        .padding()
                    
                    ) {
                        ForEach(0..<10){ _ in
                            Rectangle()
                                .frame(height: 150)
                        }
                    }
                    Section(header:
                                Text("Section 2")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .background(Color.blue)
                        .font(.title)
                        .padding()
                    
                    ) {
                        ForEach(0..<10){ _ in
                            Rectangle()
                                .frame(height: 150)
                        }
                    }
                })
            
        }
    }
```

### safeArea

`.ignoresSafeArea()`和`.edgeslgnoringSafeArea()`

保持在安全区域内编码，以及了解如何使用不安全区域进行编码。

```admonish
参考[Apple人机交互指南](https://developer.apple.com/cn/design/human-interface-guidelines/layout)中的内容布局章节。
```

忽略安全区域一般适用于背景之类的组件，例如：

```swift
Text("Hello,World!")
    .frame(maxWidth: .infinity,maxHeight: .infinity)
    .background(Color.red)
    .edgesIgnoringSafeArea(.all)
```

但是有些时候会导致内容在非安全区中，并且因为机型不同，导致有一些内容无法看到，例如：

> 将实时预览的模型切换为带有刘海的机型。

示例1

```swift
VStack {
    Text("Hello,World!")
    Spacer()
}
.frame(maxWidth: .infinity,maxHeight: .infinity)
.background(Color.red)
.edgesIgnoringSafeArea(.all)
```

我们就看不到文本内容在哪里了。

但是，我们可以使用 ZStack来堆叠内容，Zstack中先声明的内容堆叠在下层，后声明的内容在上层。

```swift
ZStack {
    Color.blue.ignoresSafeArea()
    VStack {
        Text("Hello,World!")
        Spacer()
    }
    .frame(maxWidth: .infinity,maxHeight: .infinity)
    .background(Color.red)
}
```

示例2：修改前

```swift
ScrollView{
    Text("Hello,World!")
        .font(.largeTitle)
        .frame(maxWidth: .infinity,alignment: .leading)
    
    ForEach(0..<10){_ in
        
    RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(height: 150)
            .shadow(radius: 10)
            .padding()
    }
}
.background(Color.red)
.ignoresSafeArea()
```

示例2：修改后

```swift
ScrollView{
    Text("Hello,World!")
        .font(.largeTitle)
        .frame(maxWidth: .infinity,alignment: .leading)
    
    ForEach(0..<10){_ in
        
    RoundedRectangle(cornerRadius: 25.0)
            .fill(Color.white)
            .frame(height: 150)
            .shadow(radius: 10)
            .padding()
    }
}
.background(
    Color.red.ignoresSafeArea()
)
```

只需要修改一处，让背景色忽略安全区域。

### Button

按钮这个东西，很多地方都有，我最熟悉的就是html上面的按钮标签了，突然想知道谁是最早的声明式UI，找个时间去查查。

```swift
//创建一个按钮

Button("点我"){
//action
}
```

编写一个点击事件

```swift
@State var title :String = "我是一个大大的标题"
    
    var body: some View {
        Text(title)
            .font(.largeTitle)
        
        Button("点我"){
            self.title = "你还真的点啊"
        }
        .accentColor(.yellow)
        
        Button(action: {
            self.title = "你怎么敢点我的？"
        }, label: {
            Rectangle()
                .stroke(Color.black)
                .frame(width: 30,height: 30)
                .overlay(
                    Image(systemName: "xmark")
                )
            
        })
    }
//
```

在这里留俩比较好看的按钮以便日后~~开抄~~

```swift
Button(action: {
    self.title = "你怎么敢点我的？"
}, label: {
    Image(systemName: "xmark")
        .accentColor(.white)
        .padding()
        .padding(.horizontal,20)
        .background(
            Color.blue
                .cornerRadius(10)
                .shadow(radius: 10)
        )
})

Text("save".uppercased())
        .font(.headline)
        .fontWeight(.semibold)
        .accentColor(.white)
        .padding()
        .padding(.horizontal,20)
        .background(
            Color.blue
                .cornerRadius(10)
                .shadow(radius: 10)
        )

Button(action: {
    self.title = "你又点我！"
}, label: {
    Circle()
        .fill(Color.white)
        .frame(width: 75,height: 75)
        .shadow(radius: 10)
        .overlay(
            Image(systemName: "heart.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
        )
})

Button(action: {
    self.title = "你再点！！！"
}, label: {
    Text("点我")
        .font(.headline)
        .fontWeight(.semibold)
        .foregroundColor(.gray)
        .padding()
        .padding(.horizontal,10)
        .background(
            Capsule()
                .stroke(Color.gray,lineWidth: 2)
        )
})

Button(action: {
    self.title = "没完了是吧！"
}, label: {
    Text("press me".uppercased())
        .font(.headline)
        .foregroundColor(.white)
        .padding()
        .background(Color.black)
        .cornerRadius(10)
})
```

### @State

还记得`struct`实例一般情况下是无法被修改的吗？不记得也没关系，搜引擎上搜索一下`mutating`{{footnote:用于修改值类型或枚举类型的内部属性方法修饰符}}关键字即可。

@State{{footnote:状态属性包装器，通常用于UI的重新渲染}}

示例：

```swift
@State var backgrooundColor = Color.red
@State var count = 0
var body: some View {
    ZStack{
        backgrooundColor
            .ignoresSafeArea()
        VStack(spacing:20){
            Text("title")
                .font(.title)
            Text("Count: \(count)")
            
            HStack(spacing:20){
                Button("我会变绿"){
                    backgrooundColor = Color.green
                    count += 1
                }
                
                Button("我会变红"){
                    backgrooundColor = Color.red
                    count += 1
                }
            }
        }
    }
}
```

备注，看不懂这玩意的源码，这东西好像直接是一个底层实现，每次点进去，感觉跟写TS想查看API如何实现的却发现把你引导到了一个巨长无比的API定义文档里面，还非常消耗CPU，点错了想出来还得缓几秒的那种。

盲猜用了观察者，当值发生变化的时候观察者通知UI层面开始重新渲染。~~友人A：这压根没必要猜啊~~

按着UI的头并告诉他，被@State标注了的变量发生改变后，给我重新工作。

### Extract Functions & Views

这一章节很简单，教你如何对方法进行封装📦，将可复用的代码片段封装为一个方法，对于视图也是同理。

在不失安全性的前提下做到复用性和灵活性。友人A：这小子又在装。

```admonish
提一嘴，`#Preview`{{footnote:预览宏}}是Xcode15的全新功能，不需要写在一个结构体里面了。

[链接](https://www.appcoda.com/swiftui-preview-macro/)
```

```swift
struct ExtractFunctionBootcamp: View {
    
   @State var backgroundColor = Color.yellow
    
    var body: some View {
        ignoreSafeAreaView(color: backgroundColor,alignment: .center){
            
            contentLayout
            
        }
    }
    var contentLayout:some View{
        VStack{
            Text("Safe")
                .font(.largeTitle)
            
            Button(action: {
                buttonAction()
            }, label: {
                Text("press me".uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(10)
            })
            
        }
    }
    private func buttonAction(){
        self.backgroundColor = Color.red
    }
}

func ignoreSafeAreaView(color:Color,alignment:Alignment = .center,@ViewBuilder action:()->some View) -> some View {
    
    return ZStack(alignment:alignment){
        color.ignoresSafeArea()
        action()
    }
}



#Preview {
    ExtractFunctionBootcamp()
}
```

### Extract Subviews

刚才我们查看了如何提取方法，那么我们现在来提取视图组件吧。

```swift
struct ExtractSubviewBootcamp: View {
    var body: some View {
        ignoreSafeAreaView(color: .green, action:{
            itemLayout
        })
    }
    
    var itemLayout:some View{
        HStack{
            CardItem(title: "Apples", count: 5, backgroundColor: .red)
            CardItem(title: "Banana", count: 5, backgroundColor: .yellow)
        }
    }
}

#Preview {
    ExtractSubviewBootcamp()
}

struct CardItem: View {
    
    let title:String
    @State var count:Int
    let backgroundColor:Color
    
    var body: some View {
        
            Button(action: {
                count += 1
            }, label: {
                VStack{
                    Text("\(count)")
                    Text(title)
                }
                .padding()
                .background(backgroundColor)
                .cornerRadius(10)
            })
    }
}
```

### @Binding{{footnote:意为绑定，可以将父视图的变量传递给子视图}}

```admonish
这是一个普通的页面背景切换代码
```

```swift
@State var backgroundColor = Color.red

var body: some View {
    ignoreSafeAreaView(color: backgroundColor, action: {
        Button(action: {
            backgroundColor = .blue
        }, label: {
            Text("Button")
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(10)
        })
    })
}
```

这时候我们尝试把`Button`组件抽取出来，但是会导致`backgroundColor`无法传递。

```swift
struct ExtractedView: View {
    var body: some View {
        Button(action: {
            backgroundColor = .blue
        }, label: {
            Text("Button")
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(10)
        })
    }
}
```

```admonish
我们想要在子组件中访问并能修改父组件的实例就可以使用`@Binding`来对变量进行声明。
```

```swift
struct ButtionView: View {
    @Binding var backgroundColor:Color
    
    var body: some View {
        Button(action: {
            backgroundColor = .blue
        }, label: {
            Text("Button")
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal)
                .background(Color.blue)
                .cornerRadius(10)
        })
    }
}
```

在父视图向子视图传递绑定变量的时候需要使用`$`符号加上变量名进行传递。

```swift
@State var backgroundColor = Color.red

var body: some View {
    ignoreSafeAreaView(color: backgroundColor, action: {
        
        ButtionView(backgroundColor: $backgroundColor)
        
    })
}
```

### Conditional Statements

有`if else`和`switch`两种条件选择语句{{footnote:这两种语句在许多编程语言中都广泛存在，有的switch可能叫when或match，switch语句中也分两个派别，一个是古典的hashCode派，一个是现代的模式匹配派，不用担心什么性能问题，如果这种语句都有问题的话，要么是该语言使用难度极大，要么就是写的代码太💩了}}。

`if else` 版本：

```swift
    
@State var showCircle:Bool = false

var body: some View {
    VStack{
        Button("Circle Button:\(showCircle.description)"){
            showCircle.toggle()
        }
        if showCircle {
            Circle()
                .stroke(lineWidth: 1)
                .shadow(color: .black,radius: 10)
                .frame(width: 100,height: 100)
            
        }else{
            Rectangle()
                .stroke(lineWidth: 2)
                .shadow(radius: 10)
                .frame(width: 100,height: 100)
        }
        Spacer()
    }
    .animation(.default)
    
}
```

`switch`版本：

```swift

@State var showCircle:Bool = false

var body: some View {
    VStack{
        Button("Circle Button:\(showCircle.description)"){
            showCircle.toggle()
        }
        switch showCircle{
        case true:
            Circle()
                .stroke(lineWidth: 1)
                .shadow(color: .black,radius: 10)
                .frame(width: 100,height: 100)
        case false:
            Rectangle()
                .stroke(lineWidth: 2)
                .shadow(radius: 10)
                .frame(width: 100,height: 100)
        }
        Spacer()
    }
    .animation(.default)
    
}
```

### Ternary Operators{{footnote:三元运算符，三目运算符}}

```admonish warning
三元运算符是个好东西，但是请不要写一大坨，它通常用来设置一个默认值，或者某个变量为空后返个异常语句出去。

对于布尔值，它不需要写比较条件，如果为`true`就会返回`:`前面的结果，如果为`false`就会返回`:`后面的结果
```

还是使用刚才的`if else`来举例:
如果有许多地方都是一样的，只有一个地方刚好不同，那么我们就可以使用三元表达式来进行简化`if else`

简化前：

```swift
if showCircle{
    Circle()
        .stroke(lineWidth: 1)
        .fill(Color.blue)
        .shadow(color: .black,radius: 10)
        .frame(width: 100,height: 100)
}else{
    Circle()
        .stroke(lineWidth: 1)
        .fill(Color.red)
        .shadow(color: .black,radius: 10)
        .frame(width: 100,height: 100)
}
```

简化后：

```swift
Circle()
    .stroke(lineWidth: 1)
    .fill(showCircle ? Color.blue:Color.red)
    .shadow(color: .black,radius: 10)
    .frame(width: 100,height: 100)
```

### NavigationView & NavigationLink

>ChengCY: 这个我知道，在前端里面，基本上都有，想必这里讲的是前端里面的路由了吧。
>
>ChengCY: 也许，大概🤔，没看我也不知道。

构建一个`NavitaionView`页面

```swift
struct NavigationViewBootcamp: View {
    var body: some View {
            NavigationView(content: {
                ScrollView{
                    NavigationLink(destination: NavSecondScreen()) {
                        Text("Navigate")
                    }
                    .navigationTitle("Box")
                    .navigationBarTitleDisplayMode(.automatic)
                    
                }
            })   
        }
}
struct NavSecondScreen :View {
    var body: some View {
        ignoreSafeAreaView(color: .pink, action: {
            NavigationLink(destination: ButtonBootcamp(), label: {
                Text("点我入button")
            })
        })
        .navigationTitle("Hello")
    }
}
```

>ChengCY: 放心了，和前端没有什么差别。

~~~admonish example title="没有回退界面的目标视图"
我们将在这个视图中回退到导航视图，但是没有了回退按钮，怎么办呢？

我们可以很好的利用前面所使用的[@Environment](#sheet)里面注入的`.\presentationMode`来对没有回退的页面进行回退。

```swift
struct NavSecondScreen :View {
    var body: some View {
        ignoreSafeAreaView(color: .pink, action: {
            NavigationLink(destination: ButtonBootcamp(), label: {
                Text("点我入button")
            })
        })
        .navigationTitle("Hello")
        .navigationBarBackButtonHidden()
    }
}
```
~~~

~~~admonish example title="自定义视图的回退按钮"

```swift
struct NavSecondScreen :View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ignoreSafeAreaView(color: .pink, action: {
            VStack{
                NavigationLink(destination: ButtonBootcamp(), label: {
                    Text("点我入button")
                })
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                  Text("点我出去")
                })
            }
        })
        .navigationTitle("Hello")
        .navigationBarBackButtonHidden()
    }
}
```
~~~

接下来，我们可以自定义导航栏上的按钮

~~~admonish example title="使用`navigationBarItems`API对导航栏上的按钮自定义"

```swift
var body: some View {
        NavigationView(content: {
            ScrollView{
                NavigationLink(destination: NavSecondScreen()) {
                    Text("Navigate")
                }
                .navigationTitle("Box")
                .navigationBarTitleDisplayMode(.automatic)
                .navigationBarItems(
                    leading: Image(systemName: "person.fill"),
                                    trailing: Image(systemName: "gear")
                )
                
            }
        })
}
```
~~~

再给按钮加上一点功能

```swift
var body: some View {
        NavigationView(content: {
            ScrollView{
                NavigationLink(destination: NavSecondScreen()) {
                    Text("Navigate")
                }
                .navigationTitle("Box")
                .navigationBarTitleDisplayMode(.automatic)
                .navigationBarItems(
                    leading: NavigationLink(destination: {
                        //这里可以放入一些自己之前写的组件
                        AnimationCurves()
                    }, label: {
                        Image(systemName: "person.fill")
                    }),
                    trailing: NavigationLink(destination: {
                        ImageBootcamp()
                    }, label: {
                        Image(systemName: "gear")
                    })
                )
                
            }
        })
    }
```

### List

在swift-ui中，`List`不是那个数据集合，而是一个容器视图，它用于展示列表数据。

```swift
    @State var items :[String] = [
        "apple","orange","banana"
    ]
    var body: some View {
        List{
            Section(header:Text("Fruit")) {
                ForEach(items,id: \.self){ fruit in
                    Text(fruit)
                }
            }
        }
    }
```

可以对List的主题样式进行修改。

```swift
List{
    Section(
        header:Text("Fruit")
    ) {
        ForEach(fruits,id: \.self){ fruit in
            Text(fruit)
        }
        .onDelete(perform: delete)
        .onMove(perform: move)
    }
}
.listStyle(GroupedListStyle())
.navigationTitle("Grocery list")
.navigationBarItems(
    leading: EditButton(),
    trailing: addButton
)

```

~~~admonish info title="可进行的操作"
可以对列表数据进行Add{{footnote:添加}},edit{{footnote:编辑}},move{{footnote:移动}},delete{{footnote:删除}}操作。

这些操作通常都使用`on`开头，例如删除是`onDelete`

~~~

#### delete操作

为列表添加`delete`操作

```swift
List{
    Section(header:Text("Fruit")) {
        ForEach(items,id: \.self){ fruit in
            Text(fruit)
        }.onDelete(perform: { indexSet in
            items.remove(atOffsets: indexSet)
        })
    }
}
```

通常而言，删除逻辑不应该和页面逻辑混合在一起，那会非常的难以维护，我们将删除操作抽象为一个方法 like this

```swift
func delete(index:IndexSet)  {
        fruits.remove(atOffsets: index)
}
```

方法编写完毕该如何使用呢？很简单，根据规则，我们可以为`onDelete`传递一个方法名即可 like this

```swift
.onDelete(perform: delete)
```

```admonish info title="require"
这是关于方法引用的知识，可以看看我的关于lambda表达式的文章。~~虽然是Java版本，但是逻辑基本上在所有语言中都是共通的~~ [传送门](../../java/lambda/lambda.md)

还是不明白的话就当它是一个简化规则吧。
```

#### edit操作

为列表添加编辑按钮。

```swift
var body: some View {
    NavigationView{
        List{
            Section(header:Text("Fruit")) {
                ForEach(fruits,id: \.self){ fruit in
                    Text(fruit)
                }
                .onDelete(perform: delete)
            }
        }
        .navigationTitle("Grocery list")
        .navigationBarItems(leading: EditButton())
    }
    
}
```

#### move操作

为列表添加移动操作

```swift
func move(from:IndexSet,to:Int){
    fruits.move(fromOffsets: from, toOffset: to)
}
```

同样将该函数交给`onMove`

```swift
.onMove(perform: move)
```

#### Add操作

添加add操作

写一个button并放置在导航栏右边

```swift
.navigationBarItems(
                leading: EditButton(),
                trailing: Button("Add", action: {
                    fruits.append("Pineapple")
                })
            )
```

根据之前的方法引用规则，我们可以把逻辑提取出来。

```swift
func add(){
        fruits.append("pineapple")
}
```

并修改`navigationBarItems`

```swift
.navigationBarItems(
                leading: EditButton(),
                trailing: Button("Add", action: add)
            )
```

我们要让主页面逻辑尽可能简，就需要将其它页面逻辑抽出去。

```swift
var addButton:some View{
        Button("Add", action: add)
}
//让navigationBarItems引用这个变量
.navigationBarItems(
                leading: EditButton(),
                trailing: addButton
            )

```

#### End

~~~admonish success title="练习"
我们已经完成了一个列表的编辑、移动、添加、删除操作，现在，我们可以根据这些逻辑再重新编写一次逻辑，例如加一个电器Section之类的。
~~~

### alert

~~~admonish example title="作用"
一般用于应用程序或系统状态发生变化时提示用户，它的提示过于强烈，需要少用。
~~~

```swift
@State var showAlert = false
    var body: some View {
        Button("⚡️"){
            showAlert.toggle()
        }
        .alert(isPresented: $showAlert){
            Alert(
                title: Text("我是警报🚨"),
                message: Text("因为你用手点击闪电，所以你被警告了")
            )
        }
    }
```

做一个带选项的警告

```swift
 Alert(
    title: Text("我是警报🚨"),
    message: Text("因为你用手点击闪电，所以你被警告了"),
    primaryButton: .destructive(Text("你还敢⚡️？")),
    secondaryButton: .cancel(Text("别取消啊"))
)
```

### actionSheet()

~~~admonish example title="作用"
`actionSheet`用于在当前视图上显示一个弹出窗口，向用户显示一些选项供其选择。当你希望用户在操作的时候有两个或两个以上的选择时，可以使用`ActionSheet`。如果少于或等于两个，可以使用`Alert`
~~~

```swift
@State var showAcionSheet = false
var body: some View {
    Button("Check me"){
        showAcionSheet.toggle()
    }
    .actionSheet(isPresented: $showAcionSheet,content:getActionSheet)

}

func getActionSheet()->ActionSheet{
    return ActionSheet(title: Text("你好"))
}
```

让我们来自定义一下按钮列表

```swift
struct ActionSheetBootcamp: View {
    @State var showAcionSheet = false
    @State var message = ""
    var body: some View {
        VStack {
            Text(message)
            
            Button("Check me"){
                showAcionSheet.toggle()
            }
            .actionSheet(isPresented: $showAcionSheet,content:getActionSheet)
        }
       
    }
    
    func getActionSheet()->ActionSheet{
        let option1 :ActionSheet.Button = .default(Text("我是默认按钮1"),action: {
            message = "我是一号"
        })
        let option2 :ActionSheet.Button =
            .destructive(Text("我是危险按钮"), action: {
                message = "你在做什么？"
            })
        let option3 :ActionSheet.Button =
            .cancel(Text("取消"))
    
        return ActionSheet(
            title: Text("你好"),
            message: Text("this is a message"),
            buttons: [option1,option2,option3]
        )
    }
}

#Preview {
    ActionSheetBootcamp()
}
```

让我们再加一点新功能。

```swift
struct ActionSheetBootcamp: View {
    @State var showAcionSheet = false
    @State var changeUserConf = false
    @State var actionSheetOption:ActionSheetOptions = .isOtherPost
    
    enum ActionSheetOptions {
        case isMyPost
        case isOtherPost
    }
    
    var body: some View {
        VStack {
            HStack{
                Circle()
                    .frame(width: 30,height: 30)
                    
                Text("@ChengCY")
                Spacer()
                Button(action: {
                    showAcionSheet.toggle()
                }, label: {
                    Image(systemName: "ellipsis")
                })
                .accentColor(.primary)
                
            }
            .padding()
            Rectangle()
                .aspectRatio(1.0,contentMode: .fit)
        
            Button(changeUserConf ? "change me":"change other"){
                let userConf:ActionSheetOptions = changeUserConf ? ActionSheetOptions.isMyPost: ActionSheetOptions.isOtherPost
                actionSheetOption = userConf
                changeUserConf.toggle()
            }
            
        }
        .actionSheet(isPresented: $showAcionSheet,content:getActionSheet)
       
    }
    
    func getActionSheet()->ActionSheet{
        let option1 :ActionSheet.Button = .default(Text("共享"),action: {
            
        })
        let option2 :ActionSheet.Button = .destructive(Text("举报"), action: {
                
        })
        let option3 :ActionSheet.Button = .destructive(Text("删除"), action: {
                
        })
        let option4 :ActionSheet.Button = .cancel(Text("取消"))
        
        let options:[_] = switch actionSheetOption {
        case .isOtherPost:
            [option1,option2,option3,option4]
        case .isMyPost:
            [option1,option3,option4]
        }
    
        return ActionSheet(
            title: Text("你好"),
            message: Text("选择你的操作"),
            buttons: options
        )
    }
}

#Preview {
    ActionSheetBootcamp()
}
```

### contextMenu(){{footnote:上下文菜单}}

```admonish quote title="小剧场"
ChengCY： 👀，这东西就像电脑的右键菜单一样。

ChengCY：我的3D按压啊！！！绝版了。
```

~~~admonish info title="使用方式"
为你的view添加`.contextMenu`修饰器
~~~

```swift
var body: some View {
    VStack(alignment: .leading,spacing: 10){
        Image(systemName: "house.fill")
        Text("Home")
            .font(.headline)
        Text("this is your home")
            .font(.subheadline)
    }
    .foregroundColor(.white)
    .padding(30)
    .background(Color.blue)
    .cornerRadius(30)
    .contextMenu(menuItems: {
        Button(action: {
            
        }, label: {
            Label("🔥", systemImage: "flame.fill")
        })
        
        Button {
            
        } label: {
            Label("💦", systemImage:"shower.handheld.fill")
        }
        
        Button {
            
        } label: {
            HStack{
                Text("🌞")
                Image(systemName: "sun.max.fill")
            }
        }
    })
}
```

### TextField()

这是一个文本输入框，专门接收用户输入

~~我其实一直没想到`Color`也能使用`opacity`和`cornerRadius`~~

```swift
struct TextfieldBootcamp: View {
    @State var inputText=""
    var body: some View {
        TextField("Type some here", text: $inputText)
            //设置样式
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            .background(Color.gray.opacity(0.3).cornerRadius(10))
    }
}
```

再优化优化

```swift
@State var inputText=""
NavigationView {
    VStack{
        HStack{
            TextField("Type some here", text: $inputText)
                .padding()
                .background(Color.gray.opacity(0.3).cornerRadius(10))
                .foregroundColor(.blue)
                .font(.caption)
                
        }
        Button(action: {
            
        }, label: {
            Text("save".uppercased())
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.cornerRadius(10))
                .foregroundColor(.white)
                .font(.headline)
        })
        
        Spacer()
        Text("你好")
    }
    .padding()
    .navigationTitle("TextField Bootcamp")
}
```

让我们编写一个保存文本内容的函数和一个验证是否合法的函数

```swift
func saveText(){
    msgArray.append(inputText)
    inputText = ""
}

func textIsAppropriate()->Bool{
    if inputText.count > 3{
        return true
    }
    return false
}
```

再对Button进行改造，并对外部数据进行遍历并展示。

```admonish info
在这里我们多次调用了`textIsAppropriate`函数来判定文本内容是否合法，如果和法，便可以进行保存，按钮会变为蓝色并可用，如果不合法，按钮会变为灰色，并且不可用
```

```swift
@State var inputText=""

@State var msgArray:[String] = []

Button(action:{
    if textIsAppropriate() {
        saveText()
    }
}, label: {
    Text("save".uppercased())
        .padding()
        .frame(maxWidth: .infinity)
        .background(textIsAppropriate() ? Color.blue : Color.gray)
        .cornerRadius(10)
        .foregroundColor(.white)
        .font(.headline)
})
.disabled(!textIsAppropriate())

ForEach(msgArray,id: \.self){ msg in
    Text(msg)
}
```

### TextEditor()

```admonish quote title="废话叨叨"
刚才学习了输入框，现在又开始学习编辑框了。
```

```admonish warning
如果我们需要用户对多行文本进行编辑，就需要文本框以支持。单行就duck不必。
```

想要使用一个文本编辑器非常简单，它只需要一个参数`Binding<String>`，如果只打算展示，不让修改，那么在参数里使用`.constant`修饰符即可，就像这样。
`TextEditor(text: .constant(currentText))`

先创建一个栗子

~~~admonish example title="示例"
```swift
struct TextEditorBootcamp: View {
    @State var currentText = "我是一些默认文本内容"
    var body: some View {
        NavigationView{
            VStack{
                TextEditor(text:$currentText)
                
                Button(action: {
                    
                }, label: {
                    Text("save".uppercased())
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        
                })
                    
            }
            .padding()
            .navigationTitle("TextEditor")
        }
    }
}
```
~~~

让我们固定一下高度并添加一个`Spacer`以便在下方放置内容展示。

```swift
struct TextEditorBootcamp: View {
    @State var currentText = "我是一些默认文本内容"
    @State var showText=""
    var body: some View {
        NavigationView{
            VStack{
                TextEditor(text:$currentText)
                    .frame(height: 300)
                    .colorMultiply(.gray)
                    .cornerRadius(10)
                    .lineSpacing(5)
                
                Button(action: {
                    showText = currentText
                }, label: {
                    Text("save".uppercased())
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                       
                })
                Text(showText)
                Spacer()
            }
            .padding()
            .navigationTitle("TextEditor")
        }
    }
}
```

### Toggle()

```admonish info
这是一个开关组件，它允许用户在两个互斥的状态之间的切换，相当于用`!`给`bool`取反。
```

~~~admonish example
这是一个`Toggle`组件的实例演示，它和`TextEditor`一样，可以调用`constant`进行不可改修饰。
```swift
@State var toggleIsOn = false
var body: some View {
    Toggle(isOn: $toggleIsOn, label: {
        Text("Label")
    })
    
}
```
~~~

让我们完善一下案例：

```swift
@State var toggleIsOn = false
var body: some View {
    VStack {
        HStack{
            Text("系统状态")
            Text(toggleIsOn ? "在线" : "离线")
        }
        
        Toggle(isOn: $toggleIsOn, label: {
            Text("网络")
        })
        .toggleStyle(SwitchToggleStyle(tint: Color.blue))
        Spacer()
    }
    .padding()
    
}
```

### Picker

```admonish info
Picker是一个选择器，它允许用户从一组选项中选择一个。
```

~~~admonish example
我喜欢`WheelPickerStyle`样式，因为它选择时的滴答声非常好听。
发现一个规律，所有组件的样式基本上都是通过组件名+Style来进行设定。
```swift
@State var selection = "1"
var body: some View {
    Picker(selection: $selection) {
        ForEach(1..<99){ age in
            Text("\(age)").tag("\(age)")
        }
    } label: {
        Text("Label")
    }
    .pickerStyle(WheelPickerStyle())
}
```
~~~

~~~admonish error title="未经验证"
可能由于我的xcode版本过高，这段代码中的label始终无法显示。

Xcode版本：Xcode-15.0.0-Beta.5

Simulator：iPhone Xs iOS 17.0(21A5291g)

```swift
Picker(selection: $selection) {
        ForEach(filterOptions,id: \.self){ option in
            Text(option).tag(option)
        }
    } label: {
        HStack{
            Text("filter:")
            
            Text(selection)
        }
        .font(.largeTitle)
        .foregroundColor(.white)
        .padding()
        .padding(.horizontal)
        .background(Color.blue)
        .cornerRadius(10)
        .shadow(color: Color.blue.opacity(0.3),radius: 10,x: 0,y: 10)
    }
```
~~~

视频中说的`UISegmentedControl.appearance().selectedSegmentTintColor = UIColor.red`操作，可以将它看为对app全局配置的修改，会导致运行到这里时，更改整个app的被选择时色彩，用来自定义主题倒是无妨。

### ColorPicker

```admonish info
它是定向特化的颜色版本选择器。

专门用于渲染颜色。
```

让我们简单编写一个切换背景颜色的demo

```swift
@State var backgroundColor = Color.primary
var body: some View {
    
    ZStack {
        backgroundColor.ignoresSafeArea()
        
        ColorPicker(
            selection: $backgroundColor, supportsOpacity: true) {
                Text("选择你的背景色")
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .font(.headline)
        .padding(50)
    }
    
}

```

### DatePicker

```admonish info
这下应该能从单词中看出这是什么了吧，没错，这是{{footnote:时间选择器}}~~皮一下很开心~~
```

```swift
@State var selectionDate:Date = Date()
    var body: some View {
        VStack{
            Text("选择的时间是\(selectionDate)")
            DatePicker("Select a date", selection: $selectionDate)
        }
    }
```

经过前面三个选择器的洗礼，我们现在使用选择器将会得心应手。

和其它样式选择一样，都是控件名+Style。

```admonish hide
`.datePickerStyle(WheelDatePickerStyle())`
```

我们也可以精准控制选择日期选择和时间选择

~~~admoish example title="示例"
```swift
DatePicker("Select a date", selection: $selectionDate,displayedComponents: [.hourAndMinute])
```
~~~

也可以去限制用户的时间选择范围

~~~admoish example title="示例"
@State var selectionDate:Date = Date()

let startDate = Calendar.current.date(from: DateComponents(year: 2017)) ?? Date()

let endDate = Date()

var dateFormatter : DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}

var body: some View {
    VStack{
        HStack{
            Text("select date is:")
            Text(dateFormatter.string(from: selectionDate))
                .font(.headline)
        }
        DatePicker("Select a date",
                    selection: $selectionDate,
                    in: startDate...endDate, displayedComponents: [.date,.hourAndMinute]
                    
        )
            
    }
}
~~~

### stepper

```admonish info
步进器，可以让用户通过`+`和`-`来增加或减少值。
```

话不多说直接上demo

```swift
struct StepperBootcamp: View {
    @State var value = 1
    var body: some View {
        VStack{
            HStack{
                Text("value:")
                Text("\(value)")
            }
            Stepper("我是步进器", value: $value) { change in
                if change {
                    value += 1
                }else{
                    value -= 1
                }
            }
        }
        .padding()
    }
}
```

```admonish info
`onEditingChanged`参数传入的`bool`值为`true`代表`+`为`false`代表`-`
```

根据我们之前的抽象方法规则，应该把计算逻辑从UI声明中移开。

```swift
struct StepperBootcamp: View {
    @State var value = 1
    var body: some View {
        VStack{
            HStack{
                Text("value:")
                Text("\(value)")
            }
            Stepper("我是步进器", value: $value,onEditingChanged: changeValue)
        }
        .padding()
    }
    
    func changeValue(_ status:Bool) {
        if status {
            value += 1
        }else{
            value -= 1
        }
    }
}
```

### slider

```admonish info
滑块，通常用于视频控制，音量控制什么的。
```

废话不多说，使用了这么多组件或多或少都能又点感觉了吧，让我们直接上一个demo。

```swift
struct SliderBootcamp: View {
    @State var sliderValue = 0.0
    var body: some View {
        VStack{
            HStack{
                Text("sliderValue:")
                Text("\(sliderValue)")
            }
            Slider(value: $sliderValue,in: 0.0...1.0,step: 0.5)
            
        }
        .padding()
    }
}
```

在`in`参数中，是一个开闭范围。
在`step`参数中，需要定义一个步进值，它确定每一步`+-`多少。

### TabView & PageTabVIewStyle

~~~admonish info
通常用于选项卡的切换，例如QQ程序下面的那三个图标。
~~~

```swift
struct TabViewBootcamp: View {
    var body: some View {
        TabView {
            Text("home tab")
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            Text("browse tab")
                .tabItem {
                    Image(systemName: "globe")
                    Text("Browse")
                }
            Text("profile tab")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(.pink)
    }
}
```

可以将这些`Text`替换为你自己的`View`。

将Home tab抽出来。

```swift
struct TabViewBootcamp: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            Text("browse tab")
                .tabItem {
                    Image(systemName: "globe")
                    Text("Browse")
                }
            Text("profile tab")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(.pink)
    }
}

#Preview {
    TabViewBootcamp()
}

struct HomeView: View {
    var body: some View {
        ZStack{
            Color.red.edgesIgnoringSafeArea(.top)
            Text("home tab")
                .font(.title)
                .foregroundColor(.white)
        }
        
    }
}
```

```admonish warning
`.tabItem`修饰符必须在TableView中，不可在`HomeView`里面，如果将它写在`HomeView`中，我们就无法对其高度定制化。
```

让我们来使用一下`TabView`中的`selection`参数，它需要接收一个绑定值，这个绑定值是什么并不重要，可以是数字，可以是字符串，可以是任何可查找的内容。

只需要我们在声明完`.tabItem`后为它添加上`tag(_ tag:)`声明即可。

以下是声明完成的View

```swift
@State var selectionView = 1
var body: some View {
    TabView(selection:$selectionView) {
        HomeView()
            .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
            }
            .tag(0)
        Text("browse tab")
            .tabItem {
                Image(systemName: "globe")
                Text("Browse")
            }
            .tag(1)
        Text("profile tab")
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(2)
    }
    .accentColor(.pink)
}
```

TODO

## 动画

### .animation() & withAnimation()

动画是精髓，看看隔壁PPT，动画上去了效果都不一样😊。

没有动画，颜色切换太突兀。

```swift
@State var isAnimated:Bool = false

var body: some View {
    VStack{
        Button("check me"){
            isAnimated.toggle()
        }
        Spacer()
        RoundedRectangle(cornerRadius: 25.0)
            .fill(isAnimated ? Color.red : Color.blue)
            .frame(width: 100,height: 100)
        Spacer()
    }
}
```

现在，我们使用`withAnimation`来为我们的Rectangle加上动画。

```swift
@State var isAnimated:Bool = false

var body: some View {
    VStack{
        Button("check me"){
            withAnimation(.default){
                isAnimated.toggle()
            }
        }
        Spacer()
        RoundedRectangle(cornerRadius: 25.0)
            .fill(isAnimated ? Color.red : Color.blue)
            .frame(width: 100,height: 100)
        Spacer()
    }
}
```

```admonish
该方法将会为所有受到`isAnimated`变量影响的内容加上动画。
```

现在，我们为`cornerRadius`修改值。

```swift
@State var isAnimated:Bool = false

var body: some View {
    VStack{
        Button("check me"){
            withAnimation(.default){
                isAnimated.toggle()
            }
        }
        Spacer()
        RoundedRectangle(cornerRadius: isAnimated ? 25 : 50)
            .fill(isAnimated ? Color.red : Color.blue)
            .frame(width: 100,height: 100)
        Spacer()
    }
}
```

点击check me看看，一个圆角的框框伴随着动画变为了一个真正的圆形，`withAnimation`会为所有受到影响的ui添加动画。

这次我们修改宽高。

```swift
@State var isAnimated:Bool = false

var body: some View {
    VStack{
        Button("check me"){
            withAnimation(.default){
                isAnimated.toggle()
            }
        }
        Spacer()
        RoundedRectangle(cornerRadius: isAnimated ? 25 : 50)
            .fill(isAnimated ? Color.red : Color.blue)
            .frame(width: isAnimated ? 100 :200,height: isAnimated ? 100: 200)
        Spacer()
    }
}
```

还可以修改它的位置。

```swift
@State var isAnimated:Bool = false

var body: some View {
    VStack{
        Button("check me"){
            withAnimation(.default){
                isAnimated.toggle()
            }
        }
        Spacer()
        RoundedRectangle(cornerRadius: isAnimated ? 25 : 50)
            .fill(isAnimated ? Color.red : Color.blue)
            .frame(width: isAnimated ? 100 :200,height: isAnimated ? 100: 200)
            .offset(y:isAnimated ? 200:0)
        Spacer()
    }
}
```

还能够修改动画触发速度。

```swift
withAnimation(Animation.default.delay(0.5)){
    isAnimated.toggle()
}
```

重复动画

```admonish info
`autoreverses` 参数如果为true可能看着会跳了大约一半的动画，但是，回归动画也算一次动画。
```

```swift
VStack{
    Button("check me"){
        withAnimation(
            Animation
                .default
                .repeatCount(5, autoreverses: true)
        ){
            isAnimated.toggle()
        }
    }
    Spacer()
    RoundedRectangle(cornerRadius: isAnimated ? 25 : 50)
        .fill(isAnimated ? Color.red : Color.blue)
        .frame(width: isAnimated ? 100 :200,height: isAnimated ? 100: 200)
        .rotationEffect(Angle(degrees: isAnimated ? 360 : 0))
        .offset(y:isAnimated ? 200:0)
    Spacer()
}
```

也可以只让`Rectangle`受到动画影响，为`Rectangle`添加`.animation`修饰符即可。

其中的value参数表示需要监视哪个值，是个触发器。

```swift
RoundedRectangle(cornerRadius: isAnimated ? 25 : 50)
                .fill(isAnimated ? Color.red : Color.blue)
                .frame(width: isAnimated ? 100 :200,height: isAnimated ? 100: 200)
                .rotationEffect(Angle(degrees: isAnimated ? 360 : 0))
                .offset(y:isAnimated ? 200:0)
                .animation(Animation
                    .default
                    .repeatCount(5, autoreverses: true), value:isAnimated)
```

### Animation Curves

```admonish info
动画曲线是一个很复杂的东西，我们主要看五个动画。

- bouncy {{footnote:弹性动画}}
    - 非常有弹性
- linear {{footnote:缓性动画}}
    - 从开始到结束的时间相同
- easeIn {{footnote:缓入动画}}
    - 慢入快出
- easeInOut {{footnote:缓入缓出}}
    - 慢快慢 慢速启动，然后加速，到达终点减速
- easeOut {{footnote:缓出}}
    - 快入慢出
```

```swift
@State var isAnimation:Bool = false
    var body: some View {
        VStack{
            Button("🤔"){
                isAnimation.toggle()
            }
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.bouncy)
                .overlay(
                    Text("弹性动画")
                        .foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.linear)
                .overlay(
                    Text("线性动画")
                        .foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.easeIn)
                .overlay(
                    Text("缓入动画")
                        .foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.easeInOut)
                .overlay(
                    Text("缓入缓出动画")
                        .foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.easeOut)
                .overlay(
                    Text("缓出动画")
                        .foregroundColor(.white)
                )
        }
    }
```

他们的动画时间如果没有规定，那么都会是相同的。

为了论证这一点，我们可以使用带`duration`参数的方法来设置时间。

```swift
    @State var isAnimation:Bool = false
    let timeing = 10
    var body: some View {
        VStack{
            Button("🤔"){
                isAnimation.toggle()
            }
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.bouncy(duration: TimeInterval(timeing)))
                .overlay(
                    Text("弹性动画")
                        .foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.linear(duration: TimeInterval(timeing)))
                .overlay(
                    Text("线性动画")
                        .foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.easeIn(duration: TimeInterval(timeing)))
                .overlay(
                    Text("缓入动画")
                        .foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.easeInOut(duration: TimeInterval(timeing)))
                .overlay(
                    Text("缓入缓出动画")
                        .foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.easeOut(duration: TimeInterval(timeing)))
                .overlay(
                    Text("缓出动画")
                        .foregroundColor(.white)
                )
        }
    }
```

运行这部分代码，观察动画。

现在，我们来试试自定义动画。

```admonish info
`response`：弹簧的刚度，以秒为单位的时间。值为0则表示无限刚性的弹簧。

`dampingFraction`：动画的阻尼。

`blendDuration`：以秒为单位的时间，用于在弹簧之间插值响应值的变化。用来控制弹簧在响应变化时的过度效果。例如，如果希望在弹簧动画在响应值的时候更加平滑，就可以增加它的值。

```

```swift
RoundedRectangle(cornerRadius: 25.0)
                .frame(width: isAnimation ? 350:50, height: 100)
                .animation(.spring(
                    response: 1,
                    dampingFraction: 0.7,
                    blendDuration: 1.0
                    )
                )
                .overlay(
                    Text("自定义动画")
                        .foregroundColor(.white)
                )
```

### .transition{{footnote:过渡动画}}

```admonish info
`transition`决定了某个View怎么插入到当前页面中，或者如何从当前页面中移除。

`transition`需要和动画一起使用，通常配合`.opacity`过度视图透明度，或者使用`.slide`来控制视图的位置。

也可以使用`.astnnetruc`过度来为插入和移除操作指定不同的过渡效果，或者使用`.combined`方法来组合多个过渡效果。

|修饰符|中文|动画描述|
|:---:|:---:|:---:|
|slide|幻灯片|左进右出|
|move|移动|统一自定义移入移出动画|
|opacity|不透明度|淡入淡出|
|scale|比例尺|从中间放大|
|asymmetric|不对称|单独自定义移入移出动画|
```

我们将会为这一段代码的方形盒子添加过渡

```swift
@State var showView:Bool = false

var body: some View {
    ZStack(alignment:.bottom){
        VStack{
            Button("🤔"){
                showView.toggle()
            }
            Spacer()
        }
        RoundedRectangle(cornerRadius: 30)
            .frame(height: UIScreen.main.bounds.height * 0.5)
            .opacity(showView ? 1.0 : 0.0)
            .animation(.easeInOut)
            
    }
    .ignoresSafeArea(edges: .bottom)
    
}
```

```admonish info
由于我们之前隐藏盒子是通过不透明度来实现的。

现在我们可以切换为过渡动画。
```

```swift
var body: some View {
        ZStack(alignment:.bottom){
            VStack{
                Button("🤔"){
                    showView.toggle()
                }
                Spacer()
            }
            
            if showView{
                RoundedRectangle(cornerRadius: 30)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .transition(.slide)
                    .animation(.easeInOut)
            }
                
        }
        .ignoresSafeArea(edges: .bottom)
```

现在我们可以使用更多的过渡动画

```swift
//从下方出现消失
//这个好看🥰
RoundedRectangle(cornerRadius: 30)
                .frame(height: UIScreen.main.bounds.height * 0.5)
                .transition(.move(edge: .bottom))
                .animation(.spring)
```

~~~admonish warning title="bug"
直接使用`opactiy`并在下面添加动画选项会导致过渡动画不可用，

be like:

 ```swift   
RoundedRectangle(cornerRadius: 30)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .transition(.opacity)
                    .animation(.spring)
```


~~~

解决办法是：

```swift
RoundedRectangle(cornerRadius: 30)
                    .frame(height: UIScreen.main.bounds.height * 0.5)
                    .transition(.opacity.animation(.spring))
```

很神奇的bug，可能是因为swift-ui有点新，导致在构建动画模型的时候没有将内容构建进去，这只是个推断，因为看上去swift跟js一样，我完全不知道发生了什么。
只能猜测做到一半突然发现像下面这样写更合理吧。

```swift
.transition(.asymmetric(insertion: .slide.animation(.bouncy), removal: .scale.animation(.easeIn)))
```

### .sheet()&.fullScreenCover()

```admonish info
`.sheet`用于显示一个可向下拖动关闭的模态视图。

`.fullScreenCover`用于显示一个全屏模态视图，不能通过向下拖动关闭。主要用来显示用于全屏展示的内容，你需要手动提供一个退出方式来关闭这个模态框。
```

让我们来试试吧。

```swift

@State var showSheet:Bool = false
var body: some View {
    
    ignoreSafeAreaView(color: .green, action: {
        Button(action: {
            showSheet.toggle()
        }, label: {
            Text("Button")
                .foregroundColor(.green)
                .font(.headline)
                .padding(20)
                .background(Color.white.cornerRadius(10))
                .sheet(isPresented: _showSheet.projectedValue, content: {
                    Text("Hello")
                })
        })
        
    })
}
```

```admonish info
`ignoreSafeAreaView`是我在[ExtractFunctions](#extract-functions--views)中自定义的一个方法，它主要接收颜色，位置，还有一个能返回视图的函数。它主要返回一个忽略了安全区域的颜色背景。
```

现在，我们点击🤔试试效果吧。

在`.sheet`中定义第二个视图会非常的不方便，如果你在里面有一个表单之内的，那么就会面临一串巨长无比的代码，这很不好，这时我们就可以根据之间讲述的[Extoract SubView](#extract-subviews)里面的做法，将`.sheet`中的视图组件抽取出来。

就像这样。

~~~admonish example title="提取视图组件"

```swift
struct SecondScreen :View {
    var body: some View{
        ignoreSafeAreaView(color: .red, alignment:.topLeading,action: {
            Button(action: {
                
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(20)
                    
            })
        })
    }
}
//用于显示预览
#Preview("secondScreen", body: {SecondScreen()})
```
~~~

接下来，我们来写一个关闭功能。

~~~admonish example title="可关闭的视图"
```swift
struct SecondScreen :View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        ignoreSafeAreaView(color: .red, alignment:.topLeading,action: {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(20)
                    
            })
        })
    }
}


```
你可能注意到了这里面有一个`@Environment`的属性包装器。
它通常用于向我们提供一些系统管理的程序变量，通常可以在这些程序变量中获取到许多功能。
因为它是从环境上下文中获取的内容，环境上下文中的东西一般由系统创建。

~~~

~~~admonish warning
不要往`sheet`中添加页面控制渲染逻辑。因为那会导致出现许多异常，也不利于我们维护代码，路由的事交给路由做，不要在`sheet`中编写路由逻辑。

苹果给的手册要辩证看待，因为有些被标记为废弃的api也可以使用，api如果用得太新，那就直接放弃了低版本ios，我还是iphone 7（ios 15.7）啊，想要用也可以，上编译器宏，一大堆版本判断在那里，还不如就用废弃的api，好管理。
~~~

### .sheet() vs transition() vs .animation()

在上一章节中，我们学习了如何在一个页面中弹出一个模态框，这一章节我们将会为模态框结合`transition()`和`animation()`。

~~~admonish warning title="require"
- [Sheet](#sheetfullscreencover)
- [transition](#transitionfootnote过渡动画)
- [animation](#animation--withanimation)
~~~

#### sheet

```swift
struct PopoverBootcamp: View {
    @State var isSheet:Bool = false
    var body: some View {
        ignoreSafeAreaView(color: .red, action: {
            VStack{
                Button(action: {
                    isSheet.toggle()
                }, label: {
                    Text("Button")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                })
                Spacer()
            }
            .sheet(isPresented: $isSheet, content: {
                PopoverSheet()
            })
        })
    }
}

struct PopoverSheet:View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ignoreSafeAreaView(color: .purple, alignment: .topLeading,action: {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(20)
                }
            )}
        )
        
    }
}

#Preview {
    PopoverBootcamp()
}
#Preview("PopoverSheet()", body: {
    PopoverSheet()
})
```

#### transition

```swift
struct PopoverBootcamp: View {
    @State var isSheet:Bool = false
    var body: some View {
        ignoreSafeAreaView(color: .red, action: {
            VStack{
                Button(action: {
                    isSheet.toggle()
                }, label: {
                    Text("Button")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                })
                Spacer()
            }

            ZStack{
                if isSheet{
                    PopoverSheet(showNewScreen: $isSheet)
                        .padding(.top,100)
                        .transition(.move(edge: .bottom))
                        .animation(.spring)
                }
            }
            .zIndex(2)
            
        })
    }
}

struct PopoverSheet:View {
    @Binding var showNewScreen:Bool
    
    var body: some View {
        
        ignoreSafeAreaView(color: .purple, alignment: .topLeading,action: {
            Button(action: {
                showNewScreen.toggle()
            }, label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(20)
                }
            )}
        )
        
    }
}

#Preview {
    PopoverBootcamp()
}
```

这样，我们就通过不使用`sheet`的方式就可以完成`sheet`的效果。

```admonish info
`zIndex`用于控制视图的显示顺序，具有大的索引值在前，小的索引值在后。
```

#### animation

现在，使用动画对模态框进行控制。

*不需要对`PopoverSheet`有什么多余的修改，只需要将其构造出来，并使用三元表达式将其用`offset`隐藏起来即可*

```swift
PopoverSheet(showNewScreen: $isSheet)
                .padding(.top,100)
                .offset(y: isSheet ? 0.0 : UIScreen.main.bounds.height)
                .animation(.spring)
```

#### Summary

```admonish info title="总结"
三种方法各有优势

使用`sheet`可以方便快捷的设置模态框，但是没有更多的动画效果。

使用`transition`可以获得更多效果的同时更好的操纵控件，但是代码比较复杂。

使用`animation`看起来也非常简单，它在我们的屏幕上隐藏了，但是我们能隐藏多少？况且他们是一次性创建出来的。

综上所述，第二种最为动态，需要时刻待命的就是用第三种，第一种给哪些不想编写过渡代码的使用。
```


