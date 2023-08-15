# swift高级

OK 现在我们走完了初级流程的笔记，现在应该是高级流程了。

说实话，过完初级就能够通过那些内容来简单构建一个App了，对于真正的初学者而言，一个模仿其它App的大致框架基本上没问题，但是我还是感觉有点无从下手。

要怎么构建一个标准的swiftApp，要怎么使用更多的API来达成我所需要的功能，要怎么划分功能模块，如何添加并使用第三方依赖等等。

所以我又找到了小哥的视频。

[SwiftUI 高级教程（中文字幕）](https://www.bilibili.com/video/BV13341117BR?p=2&vd_source=2f4c1268441b544df58c1f3f09881261)

[youtube](https://www.youtube.com/playlist?list=PLwvDm4Vfkdphc1LLLjCaEd87BEg07M97y)

建议上油管，看B站评论描述好像是少了几集来着。

## Custom ViewModifiers{{footnote:自定义修饰符}}

```admonish info title="自定义修饰符"
虽然我们之前编写了一堆修饰符，但是如果我们想要在不同的页面之间共享样式的话，就不可能使用复制粘贴，因为那太麻烦了，并且不方便我们找到，所以我们要自定义修饰符，使用这些修饰符在不同页面之中使用共同的样式，这将会带来更轻松的编码，更方便的维护性，让我们来看看吧。
```

```swift
VStack{
Text("Test")
    .font(.headline)
    .foregroundStyle(.white)
    .frame(height: 55)
    .frame(maxWidth: .infinity)
    .background(Color.blue)
    .cornerRadius(10)
    .shadow(radius: 10)
    
Text("Test")
    .font(.headline)
    .foregroundStyle(.white)
    .frame(height: 55)
    .frame(maxWidth: .infinity)
    .background(Color.blue)
    .cornerRadius(10)
    .shadow(radius: 10)
}

Text("Test")
    .font(.headline)
    .foregroundStyle(.white)
    .frame(height: 55)
    .frame(maxWidth: .infinity)
    .background(Color.blue)
    .cornerRadius(10)
    .shadow(radius: 10)
```

这种代码在某些不共享的组件来说，确实可以使用，但是如果你要对它进行共享，就不得不对它进行封装操作了。

我们先来创建一个结构体

```swift
struct DefaultButtonViewModifier:ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(radius: 10)     
    }
}
```

在这个结构体中，我们将刚刚的修饰符复制了过来，那么如何在我们的组件上使用呢？很简单，使用`.modifier`修饰符并传入这个结构体即可，就像这样。

```swift
Text("Test123")
    .modifier(DefaultButtonViewModifier())
```

再观察你的预览，是不是发现仅用一条语句就可以达到同样的效果了？

我们也可以对`ViewModifier`进行更多的自定义，为结构体添加一个构造函数，要求必须预先传递背景色和字体什么的。

```swift
struct DefaultButtonViewModifier:ViewModifier {
    
    let font:Font
    let backgroundColor:Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundStyle(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 10)      
    }
}
```

然后使用

```swift
Text("Test123")
    .modifier(DefaultButtonViewModifier(font:.headline,backgroundColor:.blue))
```

就可以达到自定义修饰符的效果了。 但是这样还不方便，因为我们看不出来`modifier`修饰器到底是要做什么，我们要观察它所传递的修饰器才行，这非常不方便。

这就可以使用扩展函数来对`View`进行扩展操作了。

```swift
extension View{
    func withDefaultButtonFormatting(font:Font = .headline,backgroundColor:Color = .blue)->some View{
        self.modifier(DefaultButtonViewModifier(font: font, backgroundColor: backgroundColor))
    }
}
```

添加了该扩展函数后，我们就可以直接在需要被修饰的地方调用该方法即可。

```swift
Text("Test1")
    .withDefaultButtonFormatting(font: .largeTitle)
```

这样，就完成了一个自定义修饰符，我们可以用它来完成许多组件之间样式共享，而不用担心遇到需要修改样式的时候疯狂使用搜索功能。

## Custom ButtonStyle{{footnote:自定义按钮样式}}

自定义完了修饰符，现在我们可以自定义Style了。

和自定义修饰符的方法一样，我们新定义一个结构体，让它继承`ButtonStyle`协议并重写里面的`makeBody`方法。

```swift
struct PressableButtonStyle:ButtonStyle {
    
    let scaleAnmount:CGFloat
    
    init(scaleAnmount: CGFloat = 0.9) {
        self.scaleAnmount = scaleAnmount
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? scaleAnmount : 1.0)
            .scaleEffect(configuration.isPressed ? 0.8 : 1.0)
            
    }
}
```

用法也非常简单，在`buttonStyle`修饰器中创建出这个结构体即可。

也可以自定义一个扩展函数来让我们少写一点代码。

```swift
//MARK: Style
extension View{
    /// 这是一个可按压的按钮
    /// 
    /// 
    /// - Parameter scaleAnmount: 缩小比例 0-1
    /// - Returns: Button
    func withPressableButtonStyle(scaleAnmount:CGFloat = 0.9)->some View{
        self.buttonStyle(PressableButtonStyle(scaleAnmount: scaleAnmount))
    }
}
```

编写一个Button试试吧。

```swift
Button(action: {
    
}, label: {
    Text("Click Me")
        .withBlankAndWhiteButton()
})
.withPressableButtonStyle()
.padding(40)
```

## custom Transitions{{footnote:自定义过渡}}

自定义过渡的定义方法和前两个相似，但是它继承的协议是`ViewModifier`，和自定义修饰符一样，倒不如说可以通过自定义修饰符来创建自定义过渡。

```swift
struct RotateViewModifier: ViewModifier {
    
    let degress:Double

    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(degress))
            .offset(
                x:degress != 0.0 ? UIScreen.main.bounds.height : 0,
                y:degress != 0.0 ? UIScreen.main.bounds.width : 0
            )
    }
}

extension AnyTransition{
    //创建一个180度旋转至0的过渡
    static var rotating:AnyTransition{
        AnyTransition.modifier(
            active: RotateViewModifier(degress: 180), 
            identity: RotateViewModifier(degress: 0)
            )
    }
    //创建一个从？度旋转至0的过渡
    static func rotating(rotation:Double)->AnyTransition{
        AnyTransition.modifier(
            active: RotateViewModifier(degress: rotation),
            identity: RotateViewModifier(degress: 0)
            )
    }
    //创建一个旋转着进入的过渡，然后从指定方向退出
    static func rotaOn(_ removalEdge:Edge)->AnyTransition{
        AnyTransition.asymmetric(
            insertion: .rotating,
            removal: .move(edge: removalEdge))
    }
    //创建一个旋转着进入的过渡，然后从左边退出
    static var rotaOn:AnyTransition{
        AnyTransition.asymmetric(
            insertion: .rotating,
            removal: .move(edge: .leading))
    }
}
```

使用这些过渡的方法和我们往常使用过渡的方法一样，只是该如何有一个好的过渡思路倒是个问题~~抄隔壁PPT的特效~~。

## MathchedGeometryEffect

这个修饰符可以用来关联两个视图，我们可以在顶部和底部创建两个正方形，然后使用它将正方形关联起来，辅佐一些逻辑判断，即可实现上升和下降的动画效果。

```swift
struct MathchedGeometryEffectBootcamp: View {
    @State private var isClicked:Bool = false
    @Namespace private var namespace
    
    var body: some View {
        VStack{
            if !isClicked{
                RoundedRectangle(cornerRadius: 25.0)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .frame(width: 100,height: 100)
                    
                
            }
            
            Spacer()
            
            if isClicked{
                RoundedRectangle(cornerRadius: 25.0)
                    .matchedGeometryEffect(id: "rectangle", in: namespace)
                    .frame(width: 100,height: 100)
            }
            
        }
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color.red)
        .onTapGesture {
            withAnimation(.spring) {
                isClicked.toggle()
            }
        }
    }
}
```

一个demo

```swift
let categories:[String] = ["apple","banana","pear"]
    
    @State private var selected:String = ""
    
    @Namespace private var namespace1
    
    var body: some View{
        VStack{
            HStack{
                ForEach(categories,id: \.self){ categorie in
                    ZStack{
                        if selected == categorie{
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.pink.opacity(0.3))
                                .matchedGeometryEffect(id: "category_background", in: namespace1)
                        }
                            
                        Text(categorie)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .onTapGesture {
                        withAnimation(.spring) {
                            selected = categorie
                        }
                        
                    }
                    
                }
            }
            .padding()
        }
    }

```

## Custom Shapes

如果说我们平常使用的Shape是积木，那么Custom Shapes就是用画笔手动制作积木。

总有使用通用组件无法满足要求的时候，这时候我们就需要自定义形状了。

我们来创建一个三角形。

```swift
struct Triangle: Shape{
    func path(in rect: CGRect) -> Path {
        //CGRect是从左上到右下的坐标表示
        //横向为X 纵向为Y
        //   0 0 0 0 0 | 0
        //   0 0 0 0 0 | 1
        //   0 0 0 0 0 | 2
        //   0 0 0 0 0 | 3
        //   --------- 
        //   0 1 2 3 4
        Path{ path in
            //将画笔移动到 x:2 y:0
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            //为 x:4 y:3 的坐标添加一条线
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            //为 x:0 y:3添加一条线
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            //为 x:2 y:0添加一条线
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
    //图形学都这样，你只管标点，线由系统来连。
    //你标点的时候就已经把线的信息写进去了。
}
```

让我们再绘制一个菱形试试。

```swift
struct Diamond:Shape{
    func path(in rect: CGRect) -> Path {
        Path{ path in
            let horizontalOffset = rect.width*0.2
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.maxX - horizontalOffset, y: rect.midY))
            
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            
            path.addLine(to: CGPoint(x: rect.minX + horizontalOffset, y: rect.midY))
            
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        }
    }
}
```

我们再绘制一个梯形

~~~admonish example collapsible=true title="不要偷看哦，先自己试试"
```swift
struct Trapezoid:Shape{
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: CGPoint(x: rect.minX + rect.width*0.2, y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.maxX - rect.width*0.2, y: rect.minY))
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}
```
~~~

## Custom shapes with Ares and Quad Curves

### Arc

前面我们学习了关于直线的操作，现在我们开始学习关于曲线的操作。

让我们先来创建第一个示例，绘制一个圆形。

```swift
struct ArcSample:Shape{
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            //移动到中心
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            path.addArc(
                //弧线的中心就是我们设定的画笔中心
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.height / 2,
                //开始角度
                startAngle: Angle(degrees: 0),
                //结束角度
                endAngle: Angle(degrees: 360),
                //指示是否是顺时针方向，对于一个圆来说，这点无所谓。
                clockwise: false
            )
        }
    }
    
}
```

或许可以拿来做一个饼状图。

将开始角度和结束角度调整为20和-20，你就能够得到一个吃豆人。

我们来画一个子弹头。

```swift
struct ShapWithArc:Shape{
    func path(in rect: CGRect) -> Path {
        Path{ path in
            //top left
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            //top right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            //mid right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            //bottom
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            //mid left
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            
        }
    }
}
```

我不想要子弹的下面那么尖，子弹头圆点就好。

添加一条弧线。

提示：

- center就使用该形状的中点即可。
- 将bottom替换。

~~~admonish example collapsible=true title="先试试嘛"
```swift
struct ShapWithArc:Shape{
    func path(in rect: CGRect) -> Path {
        Path{ path in
            //top left
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            //top right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            //mid right
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            //bottom            
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.width/2,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
            //mid left
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            
        }
    }
}
```
~~~

我们也可以让弧线的y减少一点，让这个形状看起来更圆滑，你可以随意加减乘除，来试试吧。

### QuadCurve

```admonish info
绘制一个二次贝塞尔曲线。在swift中，它需要一个曲线的终点和曲线的控制点。

[wiki百科](https://zh.wikipedia.org/wiki/%E8%B2%9D%E8%8C%B2%E6%9B%B2%E7%B7%9A)

[知乎](https://zhuanlan.zhihu.com/p/144399638)
```

```swift
struct QuatSample: Shape{
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: .zero)
            
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.maxY),
                control: CGPoint(x: rect.minX, y: rect.maxY)
            )
            path.move(to: .zero)
            
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.maxY),
                control: CGPoint(x: rect.maxX, y: rect.minY)
            )
        }
    }
}
```

让我们来尝试画一滴💧。

~~~admonish example collapsible=true title="🤔🔫"
```swift
struct WatherShape:Shape{
    //💧
    func path(in rect: CGRect) -> Path {
        Path{ path in
            //top central
            path.move(to: CGPoint(x: rect.midX,y:rect.minY))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.maxY),
                control: CGPoint(x: rect.minX, y: rect.maxY))
            
            path.move(to: CGPoint(x: rect.midX,y:rect.minY))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.maxY),
                control: CGPoint(x: rect.maxX, y: rect.maxY))
            
        }
    }
}
```
~~~

再来尝试一个波浪，像圆润的曲线图一样。

```swift
struct WatherShape:Shape{
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
            
            path.addQuadCurve(
                to: CGPoint(x: rect.midX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.25, y: rect.height * 0.25)
            )
            
            path.addQuadCurve(
                to: CGPoint(x: rect.maxX, y: rect.midY),
                control: CGPoint(x: rect.width * 0.75, y: rect.height * 0.75)
            )
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        }
    }
}
```

## Custom shapes with AnimateableData

先创建一个小demo

```swift
struct AnimateableDataBootcamp: View {
    @State private var animate:Bool = false
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: animate ? 0:25)
                .frame(width: 250,height: 250)
                
            
        }
        .onAppear(perform: {
            withAnimation(.linear(duration: TimeInterval(2)).repeatForever()) {
                animate.toggle()
            }
        })
    }
}

#Preview {
    AnimateableDataBootcamp()
}
```

这是一个永远播放下去的动画，但是我们只想要一个角拥有这个动画，这时候就需要用到自定义动画数据了。

```swift
struct RectangleWithSingleCornerAnimation:Shape{
    var cornRadius:CGFloat
    //试试注释掉这段代码，然后观察动画
    //俺寻思可能是因为这里不是视图层，用不了那一堆状态检查并重构的标注，所以使用属性来代替标注。
    var animatableData: CGFloat{
        get{
            cornRadius
        }
        set{
            cornRadius = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: .zero)
            
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornRadius))
            
            path.addArc(
                center: CGPoint(x: rect.maxX - cornRadius, y: rect.maxY - cornRadius),
                radius: cornRadius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 360),
                clockwise: false
            )
            
            path.addLine(to: CGPoint(x: rect.maxX - cornRadius, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            
        }
    }
}
```

来尝试制作吃豆人吧。

提示，动画数据应该使用数字

~~~admonish example collapsible=true title="先试试"
```swift
struct PacMam:Shape{
    var offsetAnimation:CGFloat
    var animatableData: CGFloat{
        get{
            offsetAnimation
        }
        set{
            offsetAnimation = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        Path{ path in
            path.move(to: CGPoint(x: rect.midX, y: rect.midY))
            
            path.addArc(
                center: CGPoint(x: rect.midX, y: rect.midY),
                radius: rect.width / 2,
                startAngle: Angle(degrees: offsetAnimation),
                endAngle: Angle(degrees: 360 - offsetAnimation),
                clockwise: false
            )
            
        }
    }
}
```
~~~

## Generics{{footnote:泛型}}

🤔，这个东西可以去看看swift语法的基础知识。

比较让我高兴的事swift有关联类型，它可以让我们在协议中写一个类型占位符，用着和泛型是没什么区别的。

## @ViewBuilder

```admonish info
到处对组件的内容进行复制粘贴事，条件判断事麻烦的一件事。

所以我们将一些组件的内容交给调用者来自定义，我们负责我们自己的那一块就好。

@ViewBuilder允许闭包进行视图的构建，在构造方法，方法，属性前使用它。
```

```swift
struct HeaderViewGeneric<Content:View>:View {
    let headerConetnt: Content
    
    init(@ViewBuilder headerConetnt: ()->Content) {
        self.headerConetnt = headerConetnt()
    }
    
    var body: some View {
        VStack{
            VStack(alignment:.leading){
                headerConetnt
                
                RoundedRectangle(cornerRadius: 5.0)
                    .frame(height: 2)
                
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding()
            
            Spacer()
        }
    }
}

struct ViewBuilderBootcamp: View {
    var body: some View {
        HeaderViewGeneric {
            Text("Title")
                .font(.largeTitle)
            Text("Description")
        }
       
    }
}


#Preview {
    ViewBuilderBootcamp()
}

```

计算属性和方法上使用它。

```swift
func ignoreSafeArea(color:Color,@ViewBuilder content:()->some View)-> some View{
        ZStack{
            color.ignoresSafeArea()
            content()
        }
}

@ViewBuilder private var headerSection : some View{
    switch type{
    case .type1:
        view1
    case .type2:
        view2
    case .type3:
        view3
    }
}
```

## PreferenceKey

```admonish info
它允许子视图向父视图通信，虽然`@Binding`也可以做到这一点，但是他们用途不同。

`@Binding`用于在父子视图中共享数据。如果你想子视图能够读取并修改父视图中的某个值，就可以使用`@Binding`。

而`PrefernceKey`则用于在子视图和父视图之间传递值。当你希望子视图能够将某些消息传递给父视图的时候，就可以使用`PrefernceKey`。

一个用于对值的共享，一个用于子视图单向写入，父视图单向读取。
```

一个演示demo

```swift
struct PreferenceKeyBootcamp: View {
    @State private var text:String = "Hello,world"
    
    var body: some View {
        NavigationView{
            VStack{
                SecondaryScreen(text:text)
                    .navigationTitle("Navigation Title")
                    
            }
            //在选定的key发生改变的时候父视图执行的操作。
            .onPreferenceChange(CustomPreferenceKey.self,perform: { value in
                text = value
            })
        }
    }
}

struct SecondaryScreen:View {
    let text:String
    var body: some View {
        Text(text)
            //在子视图中，通过key，向父视图进行传递参数。
            .preference(key: CustomPreferenceKey.self, value: "NEW VALUE")
    }
}
//这是子视图向父视图通知的一个key
struct CustomPreferenceKey:PreferenceKey{
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

#Preview {
    PreferenceKeyBootcamp()
}
```

我们可以像之前使用扩展函数那样对方法进行拓展，每次在子视图中写preference不方便我们对于代码功能的理解。

```swift
extension View{
    func customTitle(title:String)->some View{
        preference(key: CustomPreferenceKey.self, value: title)
    }
}
```

并在子视图中修改。

```swift
struct SecondaryScreen:View {
    let text:String
    var body: some View {
        Text(text)
            .customTitle(title: "New value")

    }
}
```

这样我们就能够一眼看出这个方法要做什么，而不是去看`CustomPreferenceKey`的定义。

让我们假装从数据库获取数据。

```swift
struct SecondaryScreen:View {
    let text:String
    @State private var newValue = ""
    var body: some View {
        Text(text)
            .onAppear(perform: getTitle)
            .customTitle(title: newValue)

    }
    
    func getTitle(){
        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
            self.newValue = "NEW VALUE!!!!!!!"
        })
    }
}
```

让我们再编写一个demo

我们使用了`GeometryReader`从`Hstack`中获取子视图的大小信息。

通过`RectangleGeometrySizePreferenceKey`将其传递给父视图，父视图接收到信息后将给`rectSize`赋值。

由于`rectSize`是被监听着的，它的变动会导致视图的局部重更新，也就会给我们的`Hello, World!`赋予宽高。

```swift
struct GeometryPreferenceKeyBootcamp: View {
    
    @State private var rectSize:CGSize = .zero
    
    var body: some View {
        VStack{
            Text("Hello, World!")
                .frame(width: rectSize.width,height: rectSize.height)
                .background(Color.blue)
                            
            Spacer()
            
            HStack{
                //这是一个容器阅读器，它可以返回视图的一些信息，例如大小
                GeometryReader{ geo in
                    Rectangle()
                        .updateRectangleGeoSize(geo.size)
                }
                Rectangle()
                Rectangle()
            }
            .frame(height: 55)
        }
        .padding()
        .onPreferenceChange(RectangleGeometrySizePreferenceKey.self, perform: { value in
            rectSize = value
        })
    }
}

#Preview {
    GeometryPreferenceKeyBootcamp()
}

extension View{
    func updateRectangleGeoSize(_ size:CGSize)->some View{
        preference(key: RectangleGeometrySizePreferenceKey.self, value: size)
    }
}

struct RectangleGeometrySizePreferenceKey:PreferenceKey{
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
```

demo2

在这个demo中，我们使用ScrollViewOffsetPreferenceKey来向父视图传递坐标数据。

并且展示`GeometryReader`的用途之一

```swift
struct ScrollViewOffsetPreferenceKey:PreferenceKey{
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
```

```swift
struct ScrollViewOffsetPreferenceKeyBootcamp: View {
    let title:String = "New title here"
    @State private var scrollViewOffset:CGFloat = 0
    var body: some View {
        
        ScrollView {
            VStack{
                titleLayer
                    //在这里让坐标慢慢变透明，因为我的模拟器的启动坐标就为60
                    //看各位自己展示出来的scrollViewOffset数据。
                    //也可以写一个bool标识，将第一次获取的坐标存储在另一个变量中
                    //我就不写了
                    .opacity(Double(scrollViewOffset) / 60)
                    .background(
                        //在这里获取该Text位于titleLayer中的坐标
                        //会在titleLayer的零点坐标生成这个标签，我们需要全局相对于它的y坐标数据
                        GeometryReader{ geo in
                            Text("")
                                .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                        }
                    )                    
                contentLayer
            }
            .padding()
        }
        .overlay(content: {
            //调试用
            Text("\(scrollViewOffset)")
        })
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self, perform: { value in
            scrollViewOffset = value
        })
        .overlay (
                navBarLayer
                    .padding(.vertical)
                    .opacity(scrollViewOffset < 40 ? 1.0 : 0.0)
                  ,alignment: .top
        )
    }
}
```

这个版本还是太麻烦，我们可以通过`extension`方法来对坐标获取进行封装。

```swift
extension View{
    func onScrollViewOffsetChanged(action:@escaping (_ offset:CGFloat)->Void)->some View{
        self
            .background(
                GeometryReader{ geo in
                    Text("")
                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self, perform: { value in
                action(value)
            })
    }
}
```

通过一个扩展函数直接完成发送和接收，闭包用于获取内部坐标值。

将刚才的demo优化一下。

```swift
struct ScrollViewOffsetPreferenceKeyBootcamp: View {
    let title:String = "New title here"
    @State private var scrollViewOffset:CGFloat = 0
    var body: some View {
        
        ScrollView {
            VStack{
                titleLayer
                    .opacity(Double(scrollViewOffset) / 60)
                    .onScrollViewOffsetChanged{ value in
                        scrollViewOffset = value
                    }
                    
                contentLayer
            }
            .padding()
        }
        .overlay(content: {
            Text("\(scrollViewOffset)")
        })
        .overlay (
                navBarLayer
                    .padding(.vertical)
                    .opacity(scrollViewOffset < 40 ? 1.0 : 0.0)
                  ,alignment: .top
        )
    }
}
```

至此，PreferenceKey完成。

## Custom TabView

系统中自带的`TabView`并不是总能满足我们的要求，我们有时候需要构建一个更符合我们业务的TabBar。

这一节有一点长，我就直接在代码中解释。

在这里，我们使用到了之前定义的泛型，@ViewBuilder，PreferenceKey，MathedGeometryEffect。

~~~admonish example title="AppTabBarView.swift" collapsible=true
```swift
import SwiftUI

struct AppTabBarView: View {
    //这是用于切换系统自带的tab，相关代码可以在扩展方法中的defaultTabView中找到。
    @State private var selection:String = "home"
    //这是我们自定义的一个tab枚举里面存储着tab的信息，将可能性收束起来，因为我们的app并不是通用代码。
    @State private var tabSelection:TabBarItem = .message
    
    var body: some View {
        customTabView1
    }
}
#Preview {
    AppTabBarView()
}

extension AppTabBarView{
    private var defaultTabView:some View{
        TabView(selection: $selection){
            Color.red
                .ignoresSafeArea(.all,edges: .top)
                .tabItem {
                    Image(systemName: "message")
                    Text("消息")
                }
            
            Color.yellow
                .ignoresSafeArea(.all,edges: .top)
                .tabItem {
                    Image(systemName: "person")
                    Text("联系人")
                }
            
            Color.blue
                .ignoresSafeArea(.all,edges: .top)
                .tabItem {
                    Image(systemName: "circle.square")
                    Text("动态")
                }
        }
    }
    
    private var customTabView1:some View{
        CustomTabBarContainerView(selection: $tabSelection) {
            Color.blue
                .tabBarItem(tab: .message,selection: $tabSelection)
            Color.red
                .tabBarItem(tab: .home,selection: $tabSelection)
            Color.green
                .tabBarItem(tab:.circle,selection: $tabSelection)
        }
    }
}
```
~~~

~~~admonish example title="TabBarItem.swift" collapsible=true
```swift
enum TabBarItem:Hashable {
case home,message,circle
    //返回系统图标
    var icon:String{
        switch self{
        case .circle:
            return "circle.dashed"
        case .home:
            return "house"
        case .message:
            return "message"
        }
    }
    //返回tab标题
    var titleName:String{
        switch self{
        case .circle:
            return "Circle"
        case .home:
            return "home"
        case .message:
            return "message"
        }
    }
    //返回tab配色
    var color:Color{
        switch self{
        case .circle:
            return .green
        case .home:
            return .blue
        case .message:
            return .red
        }
    }
}
```
~~~

~~~admonish example title="CustomTabBarContainerView.swift" collapsible=true
在这里，我们让三个视图叠加在一起，并且从CustomTabBarView中接收一个TabItemPrefernceKey，它会携带一个tabs数组返回给父页面，返回给父页面后，父页面开始对tab进行渲染
```swift
struct CustomTabBarContainerView<Content>: View
where
    Content:View
{
    let content:Content
    //被选择的Tab
    @Binding var selection:TabBarItem
    //所有的tab
    @State private var tabs:[TabBarItem] = []
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content){
        self.content = content()
        self._selection = selection
    }
    
    
    var body: some View {
        ZStack(alignment:.bottom){
            content
                .ignoresSafeArea()
            CustomTabBarView(tabItems: tabs, selection: $selection)
        }
        
        .onPreferenceChange(TabItemPrefernceKey.self, perform: { value in
            tabs = value
        })
    }
}
//测试用的数据
fileprivate let tabItems:[TabBarItem] = [
    .message,.home,.circle
]
#Preview {
    
    CustomTabBarContainerView(selection: .constant(tabItems.first!)) {
        Color.red
    }
}
```
~~~

~~~admonish example title="CustomTabBarView.swift" collapsible=true
```swift
struct CustomTabBarView: View {
    let tabItems:[TabBarItem]
    
    @Binding var selection:TabBarItem
    //用于动画
    @Namespace private var namespace
    
    var body: some View {
       tabBar2
    }
}

extension CustomTabBarView{
    private var tabBar1:some View{
        HStack{
            ForEach(tabItems,id: \.self){ tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges:.bottom))
    }
    private func tabView(tab:TabBarItem)->some View{
        VStack{
            Image(systemName: tab.icon)
                .font(.subheadline)
            
            Text(tab.titleName)
                .font(.system(size: 10,weight: .semibold,design: .rounded))
        }
        //设置被选中后的前景色
        .foregroundColor(selection == tab ? tab.color :Color.gray)
        .padding(.vertical,8)
        .frame(maxWidth: .infinity)
        //设置被选中后的渲染的背景色
        .background(selection == tab ? tab.color.opacity(0.2) : Color.clear)
        .cornerRadius(10)
    }
    
    
    private func switchToTab(tab:TabBarItem){
        withAnimation(.easeInOut) {
            selection = tab
        }
    }
}

extension CustomTabBarView{
    
    private var tabBar2:some View{
        HStack{
            ForEach(tabItems,id: \.self){ tab in
                tabView1(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .padding(6)
        .background(Color.white.ignoresSafeArea(edges:.bottom))
        .cornerRadius(10)
        //设置阴影，让它有一种立体感
        .shadow(color: .black.opacity(0.3), radius: 10,x: 0,y: 5)
        .padding(.horizontal)
    }
    private func tabView1(tab:TabBarItem)->some View{
        VStack{
            Image(systemName: tab.icon)
                .font(.subheadline)
            
            Text(tab.titleName)
                .font(.system(size: 10,weight: .semibold,design: .rounded))
        }
        //设置前景色
        .foregroundColor(selection == tab ? tab.color :Color.gray)
        .padding(.vertical,8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack{
                //用于设置动画关联
                if selection == tab{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_reteangle", in: namespace)
                }
            }
        )
        .cornerRadius(10)
    }
}

fileprivate let tabItems:[TabBarItem] = [
    .message,.home,.circle
]

#Preview {
    VStack{
        Spacer()
        CustomTabBarView(tabItems: tabItems,selection: .constant(tabItems.first!))
    }
    
}
```
~~~

~~~admonish example title="TabItemPrefernceKey.swift" collapsible=true
```swift
import Foundation
import SwiftUI
/// 对数据的底层存储
struct TabItemPrefernceKey:PreferenceKey{
    //用于存储TabBarItem数据，该数据将会在CustomTabBarContainerView中使用
    static var defaultValue: [TabBarItem] = []
    
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}
/// 对视图的修饰器
/// 通过对比当前tabBar和当前选中的tabBar是否为同一实例来使用透明度实现视图的切换
struct TabItemViewModifier:ViewModifier{
    /// 当前显示的TabBarItem
    let tab:TabBarItem
    /// 当前选中的TabBarItem
    @Binding var selection: TabBarItem
    
    func body(content: Content) -> some View {
        content
            //控制是否显示
            .opacity(tab == selection ? 1.0:0.0)
            //控制是否能够被点击
            .disabled(!(tab==selection))
            .preference(key: TabItemPrefernceKey.self, value: [tab])
    }
}

extension View{
    /// 一个TabItemViewModifier的便携方法，由子页面向父页面CustomTabBarContainerView发出preferenceKey请求，CustomTabBarContainerView接收到该请求后就会将tabs数组替换为它
    func tabBarItem(tab:TabBarItem,selection:Binding<TabBarItem>)->some View{
        modifier(TabItemViewModifier(tab: tab,selection: selection))
    }
}
```
~~~

## Custom NavigationView

~~~admonish example title="AppNavBarView.swift" collapsible=true
这个视图用来演示我们的自定义导航
```swift
struct AppNavBarView: View {
    var body: some View {
        //自定义的导航视图容器
        CustomNavView {
            ZStack{
                Color.green.ignoresSafeArea()
                VStack{
                    //自定义的导航链接
                    CustomNavLink(
                        destination: Text("我是目标")
                        //自定义链接目标视图中的标题
                            .customNavigationBarTitle("我是第二个")
                    ) {
                        Text("Hello")
                        //自定义该视图中的标题
                            .customNavigation(title: "title",subTitle: "subTitle",hidden: true)
                    }
                    
                }
            }//ZStack
            
        }//CustomNavView
    }
}

#Preview {
    AppNavBarView()
}

extension AppNavBarView{
    private var defaultNavView:some View{
        NavigationView{
            ZStack{
                Color.red.ignoresSafeArea()
                
                NavigationLink {

                    Text("view2")
                        .navigationTitle("title2")
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Navigate")
                }

            }
            .navigationTitle("nav title here")
        }
    }
}
```
~~~

~~~admonish example title="CustomNavView.swift" collapsible=true
将我们定义的内容，放置在CustomNavBarContainerView视图中，以添加导航栏。
```swift
struct CustomNavView<Content:View>: View {
    
    let content:Content
    
    init(@ViewBuilder content:()-> Content) {
        self.content = content()
    }
    
    
    var body: some View {
        NavigationView{
            //容器视图，在容器中放置自定义视图
            CustomNavBarContainerView{
                content
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    CustomNavView(){
        Color.red.ignoresSafeArea()
    }
}
//因为禁用掉导航按键会导致拖拽返回不可用，使用虾米哪方法进行重写即可重新使拖拽返回可用。
extension UINavigationController{
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
```
~~~

~~~admonish example title="CustomNavBarContainerView.swift" collapsible=true
我们对三个PreferencKey进行监听，一旦发现有对应事件发出，就修改该组件的导航栏对应内容。
对导航栏和内容进行初始化
```swift
struct CustomNavBarContainerView<Content:View>: View {
    
    let content:Content
    
    @State private var showBackButtom:Bool = true
    @State private var title:String = ""
    @State private var subTitle:String? = nil
    
    init(@ViewBuilder contentScope:()->Content) {
        self.content = contentScope()
    }
    
    var body: some View {
        VStack(spacing:0){
            //我是导航栏
            CustomNavBarView(showBackButtom: showBackButtom, title: title, subTitle: subTitle)
            //我是内容
            content
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .onPreferenceChange(CustomNavBarTitlePreferenceKey.self, perform: { value in
            title = value
        })
        .onPreferenceChange(CustomNavBarSubTitlePreferenceKey.self, perform: { value in
            subTitle = value
        })
        .onPreferenceChange(CustomNavBarBackButtonHiddenPreferenceKey.self, perform: { value in
            showBackButtom = !value
        })
    }
}

#Preview {
    CustomNavBarContainerView(){
        ZStack{
            Color.green.ignoresSafeArea()
            Text("Hello")
                .foregroundColor(.white)
        }
        .customNavigationBarTitle("title")
    }
}
```
~~~

~~~admonish example title="CustomNavBarPreferenceKeys.swift" collapsible=true
三个key的定义和它对应的使用方法
```swift

struct CustomNavBarTitlePreferenceKey:PreferenceKey{
    static var defaultValue: String = ""
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct CustomNavBarSubTitlePreferenceKey:PreferenceKey{
    static var defaultValue: String? = nil
    
    static func reduce(value: inout String?, nextValue: () -> String?) {
        value = nextValue()
    }
}

struct CustomNavBarBackButtonHiddenPreferenceKey:PreferenceKey{
    static var defaultValue: Bool = false
    
    static func reduce(value: inout Bool, nextValue: () -> Bool) {
        value = nextValue()
    }
}

extension View{
    
    func customNavigationBarTitle(_ title:String)->some View{
        self.preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
    }
    
    func customNavigationBarSubTitle(_ title:String?)->some View{
        self.preference(key: CustomNavBarSubTitlePreferenceKey.self, value: title)
    }
    
    func customNavigationBarBackButtonHidden(_ hidden:Bool)->some View{
        self.preference(key: CustomNavBarBackButtonHiddenPreferenceKey.self, value: hidden)
    }
    
    func customNavigation(title:String = "",subTitle:String? = nil, hidden:Bool = false) ->some View{
        self
            .customNavigationBarTitle(title)
            .customNavigationBarSubTitle(subTitle)
            .customNavigationBarBackButtonHidden(hidden)
    }
    
}
```
~~~

~~~admonish example title="CustomNavBarView.swift" collapsible=true
这里主要定义了导航栏的样式，如果有更多想要定义的，可以在这里添加。
```swift
struct CustomNavBarView: View {
    
    let showBackButtom:Bool
    
    let title:String
    
    let subTitle:String?
    
    @Environment(\.presentationMode) private var  presentationMode
    var body: some View {
        HStack{
            if showBackButtom{
                backButtom
            }
            Spacer()
            
            titleSection
            
            Spacer()
            if showBackButtom{
                backButtom
                    .opacity(0)
            }
        }
        .padding()
        .font(.headline)
        .foregroundColor(.white)
        .accentColor(.white)
        .background(Color.blue)
    }
}

#Preview {
    VStack{
        CustomNavBarView(showBackButtom: true, title: "title", subTitle: "subTitle")
        Spacer()
    }
}

extension CustomNavBarView{
    private var backButtom:some View{
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.left")
        }
    }
    
    private var titleSection:some View{
        VStack(spacing:4){
            Text(title)
                .font(.title)
                .fontWeight(.semibold)
            if let subTitle{
                Text(subTitle)
            }
        }
    }
}
```
~~~

~~~admonish example title="CustomNavLink.swift" collapsible=true
```swift
struct CustomNavLink<Label:View,Destination:View>: View {
    let destination:Destination
    let label:Label
    
    init(destination:Destination,@ViewBuilder label:()->Label){
        self.destination = destination
        self.label = label()
    }
    
    var body: some View {
        NavigationLink {
            //将destination也放入容器视图中
            CustomNavBarContainerView {
                destination
            }
            .navigationBarHidden(true)
        } label: {
            label
        }//navigationLink
        
    }
}

#Preview {
    CustomNavView {
        CustomNavLink(destination: Text("destination")) {
            Text("customNavLink")
        }
    }
}
```
~~~

## Use UIViewRepresentable to convert UIKit views to SwiftUI

```admonish info
由于SwiftUI是一个新东西，所以它里面有一些视图可能还未成熟，所以我们可以使用以前的UIKit视图。

`UIViewRepresentable`就是帮助在SwiftUI中使用UIKit的一个协议。
```

例如我们平常使用的`TextField`的提示字体颜色就无法更改，这就可以请出我们的UIKit来自定义了，因为它的可以修改。

```swift
struct UIViewRepresetableBootcamp: View {
    @State private var text:String = ""
    var body: some View {
        VStack{
            Text("test...")
            TextField("please input", text: $text)
                .frame(height: 55)
                .background(Color.gray)
            UITextFieldViewRepresentable()
                .frame(height: 55)
                .background(Color.gray)
        }
    }
}

#Preview {
    UIViewRepresetableBootcamp()
}

struct UITextFieldViewRepresentable:UIViewRepresentable{
    func makeUIView(context: Context) -> some UIView {
        let textField =  UITextField(frame: .zero)
        let placeholder = NSAttributedString(
            string: "please input...",
            attributes: [
                .foregroundColor : UIColor.red
            ]
        )
        textField.attributedPlaceholder = placeholder
        return textField
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct BasicUIViewRepresentable:UIViewRepresentable{
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
```

现在，我们需要将UIKit的输入框的结果值取出即可。

不太明白为什么无法拿到外部结构体的变量，难道因为一个是结构体一个是class？

```swift
struct UITextFieldViewRepresentable:UIViewRepresentable{
    let prompt:String
    
    let foregroundColor:UIColor
    //需要将传进来的Binding交给Coordinator
    @Binding var text:String
    
    init(prompt: String, foregroundColor: UIColor = .gray,text:Binding<String>) {
        self.prompt = prompt
        self.foregroundColor = foregroundColor
        self._text = text
    }
    
    func makeUIView(context: Context) -> some UIView {
        let textField = getTextField()
        textField.delegate = context.coordinator
        return textField
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    private func getTextField() ->UITextField{
        let textField =  UITextField(frame: .zero)
        let placeholder = NSAttributedString(
            string: prompt,
            attributes: [
                .foregroundColor : foregroundColor,
            ]
        )
        textField.attributedPlaceholder = placeholder
        return textField
    }
    
    func makeCoordinator() -> Coordinator {
        //将绑定传递给协调器
        return Coordinator(text: $text)
    }
    //定义了UITextField里遇到一些事件后的操作。
    //将数据发送给SwiftUI
    class Coordinator:NSObject,UITextFieldDelegate{
        @Binding var text:String
        
        init(text:Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
}
```

这时候我们测试就会发现一些问题。

我们在UIKit中的输入可以正确发送给SwiftUI，但是我们在SwiftUI中的更新不会被传递给UIKit，这是怎么回事呢？

哦，因为我没有配置`updateUIView`方法，这个方法将数据从SwiftUI发送给UIKit。

让我们添加上数据更新方法

注意:makeUIView的返回值需要更改为UITextField，不需要返回不透明类型了，因为我们编写的组件很确定类型。

```swift
func updateUIView(_ uiView: UITextField, context: Context) {
    uiView.text = self.text
}
```

这样数据就能够进行双向发送/接收了。

我们还可以以新增一个修改提示符的功能。

先将`prompt`的变量修改为`var`，然后写入下面方法。

```swift
func changePrompt(_ text:String)->UITextFieldViewRepresentable{
    var textFieldViewRepresentable = self
    textFieldViewRepresentable.prompt = text
    return textFieldViewRepresentable
}
```

为什么不直接使用self进行修改呢？因为这是结构体，除了突变方法是不允许结构体内变量修改的。
所以我们把实例复制了一份出来，修改后返回。

## UIViewControllerRepresentable

```admonish info
它允许在SwiftUI中使用UIKit的视图控制器。
```

示例代码

```swift
struct UIViewControllerRepresentableBootcamp: View {
    @State private var showScreen:Bool = false
    var body: some View {
        VStack{
            Text("hi")
            
            Button {
                showScreen.toggle()
            } label: {
                Text("Click me")
            }
            .sheet(isPresented: $showScreen, content: {
                BasicUIViewControllerRepresentable(labelText: "你好")
            })

        }
    }
}

#Preview {
    UIViewControllerRepresentableBootcamp()
}

struct BasicUIViewControllerRepresentable:UIViewControllerRepresentable {
    let labelText:String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = MyFirstViewController()
        
        vc.labelText = labelText
        
        return vc
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
}

class MyFirstViewController:UIViewController{
    var labelText:String = "starting value"
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
        
        let label = UILabel()
        label.text = labelText
        label.textColor = .white
        
        view.addSubview(label)
        
        label.frame = view.frame
    }
}
```

由我看来，这应该是由`UIViewController`定义某一组件的控制器，`UIViewControllerRepresentable`定义的是将控制器进一步组合起来的一个具体逻辑，就像我们在`View`中一直重写的`body`一样。

```admonish info title="注意"
`updateUIViewController`方法从SwiftUI获取数据并传递给UIKit的方法。

`makeCoordinator`里的`coordinator`负责将UIKit的数据回传给SwiftUI。
```

让我们使用`UIImagePickerController`来编写一个案例。

这里的逻辑是，当我们点击一下按钮，就弹出一个图像选择器，选择完成后将图像显示在屏幕上。

```swift
@State private var showScreen:Bool = false
@State private var image:UIImage? = nil

var body: some View {
    VStack{
        Text("hi")
        
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 250,height: 250)
        }
        
        Button {
            showScreen.toggle()
        } label: {
            Text("Click me")
        }
        .sheet(isPresented: $showScreen, content: {
            UIImagePickerControllerRepresentable(image: $image,showScreen: $showScreen)
        })
        
        
    }
}
```

这是`UIImagePickerControllerRepresentable`，我们在`makeUIViewController`里对视图进行组装。

我们将`UIImagePickerController`的一系列动作委托给我们自己的`Coordinator`。

在我们自己的`Coordinator`中，就可以对它的一系列事件进行定义。

我们在这里重写了`imagePickerController`方法，两个参数的那个，第二个它回携带一个字典进来，我们需要的是那个字典。

在`Coordinator`中，我们完成了图像的回传。

这样，我们就可以在SwiftUI中进行图片的展示了。

```swift
struct UIImagePickerControllerRepresentable:UIViewControllerRepresentable{
    @Binding var image:UIImage?
    @Binding var showScreen:Bool
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let vc = UIImagePickerController()
        
        vc.allowsEditing = false
        vc.delegate = context.coordinator
        
        return vc
    }
    
    // from SwiftUI to UIKit
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    // from UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(image:$image,showScreen: $showScreen)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
        
        @Binding var image:UIImage?
        @Binding var showShreen:Bool
        
        init(image: Binding<UIImage?>,showScreen:Binding<Bool>) {
            self._image = image
            self._showShreen = showScreen
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else{return}
            self.image = image
            showShreen = false
        }
    }
}
```

## Protocols

```admonish info
可以看作kotlin的interface，可以对属性和方法进行约束（Java也可以约束属性，只是没有和方法区分开来，kt就做到了这一点）。
可以使用类型别名来对协议进行组合。
`typealias newProtocols = Protocols1 & Protocols2`
```

让我们来看一个情景demo

```swift
struct DefaultColorTheme{
    let primary:Color = .blue
    let secondary:Color = .white
    let tertiary:Color = .gray
}

struct ProtocolsBootcamp: View {
    let colorTheme:DefaultColorTheme = DefaultColorTheme()
    var body: some View {
        ZStack{
            colorTheme.tertiary
                .ignoresSafeArea()
            
            Text("Protocols are awsome!")
                .font(.headline)
                .foregroundColor(colorTheme.secondary)
                .padding()
                .background(colorTheme.primary)
                .cornerRadius(10)
        }
    }
}

#Preview {
    ProtocolsBootcamp()
}
```

我们在这里构建了一个App页面，如果我们想要切换这个页面的主题色，我们可以简单的将`DefaultColorTheme`结构体中的颜色进行修改，但是如果我们想要对
不同的用户展示不同的颜色呢？

你可能会想到将修饰符修改为`var`，然后将不同颜色的配置存储在其它地方。

我们不可能真的将修饰符修改为var，因为这会意味着颜色在运行时会被其它地方修改，你可以相信你自己的代码，但是你不能相信别人的代码，你永远都想不到你的同事会想出什么奇葩的办法。

那么把颜色存储在其它地方，我们可以创建一个结构体。

```swift
struct AlternativeColorTheme{
    let primary:Color = .red
    let secondary:Color = .green
    let tertiary:Color = .blue
}
```

这样做的话，我们就需要将`colorTheme`变量的类型和赋值修改为我们刚刚创建的`AlternativeColorTheme`结构体。

这非常不方便，这时候就需要使用到我们所提到的`protocols`了。

我们声明以下协议

```swift
protocol ColorThemeProtocol {
    var primary:Color { get }
    var secondary:Color { get }
    var tertiary:Color { get }
}
```

在这里我们只能使用`var`进行修饰，只添加`get`方法，因为`let`常量在协议中无法使用。

我们在结构体声明后添加上我们刚刚编写的协议。

```swift
struct DefaultColorTheme :ColorThemeProtocol{
    let primary:Color = .blue
    let secondary:Color = .white
    let tertiary:Color = .gray
}

struct AlternativeColorTheme : ColorThemeProtocol{
    let primary:Color = .red
    let secondary:Color = .green
    let tertiary:Color = .blue
}

protocol ColorThemeProtocol {
    var primary:Color { get }
    var secondary:Color { get }
    var tertiary:Color { get }
}
```

再将`colorTheme`变量的类型修改为`ColorThemeProtocol`。

这样就能将赋值修改为所有实现了`ColorThemeProtocol`协议的结构体或者类。

也可以让`init`来初始化`colorTheme`变量。
