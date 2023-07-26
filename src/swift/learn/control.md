# 布局与控件

## Text

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

## Creating Shapes

`.fill`和`.foregroundColor`的区别是前者为指定的形状填充颜色，后者会改变文本和模版渲染元素的颜色。

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

## Color

`Color.primary`会自动根据设备的显示模式(深色模式&浅色模式)来切换黑白。

我们还可以在`Assets.xcassets`中自定义自己的颜色，由于视频里面的代码中使用的拾色器在这个版本中找不到（根据弹幕内容，这个功能好像无了。），所以只能在`Assets.xcassets`中设置颜色。

在`Assets.xcassets`中设置完颜色后，就可以在代码中使用这个颜色了，在构造Color的时候传入在`Assets.xcassets`中自定义颜色的名称即可使用。

## Gradients

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

## System Icon

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

## Image

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

## Farme

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

## Backgrounds and Overlays

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

## VStack,Hstack, and ZStack

VStacks -> Vertical

Hstacks -> Horizontal

ZStacks -> zIndex (back to front)

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

## padding

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

## Spacer

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

## inits and enums

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

## ForEach and loops

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

## ScrollView

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

## LazyVGrid

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

## safeArea

`.ignoresSafeArea()`和`.edgeslgnoringSafeArea()`

保持在安全区域内编码，以及了解如何使用不安全区域进行编码。

参考[Apple人机交互指南](https://developer.apple.com/cn/design/human-interface-guidelines/layout)中的内容布局章节。

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

## Button

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
```

## @State

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

## Extract Functions & Views

这一章节很简单，教你如何对方法进行封装📦，将可复用的代码片段封装为一个方法，对于视图也是同理。

在不失安全性的前提下做到复用性和灵活性。友人A：这小子又在装。

提一嘴，`#Preview`{{footnote:预览宏}}是Xcode15的全新功能，不需要写在一个结构体里面了。

[链接](https://www.appcoda.com/swiftui-preview-macro/)

```swift
struct ExtractFunctionBootcamp: View {
    var body: some View {
        ignoreSafeAreaView(color: Color.red,alignment: .top){
            Text("Safe")
                
        }
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
