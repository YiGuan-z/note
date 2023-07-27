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

我们还可以在`Assets.xcassets`中自定义自己的颜色，由于视频里面的代码中使用的拾色器在这个版本中找不到（根据弹幕内容，这个功能好像无了。），所以只能在`Assets.xcassets`中设置颜色。

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

ZStacks -> zIndex (back to front){{堆叠}}

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

苹果给的手册要辩证看待，因为有些被标记为废弃的api也可以使用，api如果想用得太新，那就直接放弃了低版本ios，我还是iphone 7（ios 15.7）啊，想要用也可以，上编译器宏，一大堆版本判断在那里，还不如就用废弃的api，好管理。
~~~
