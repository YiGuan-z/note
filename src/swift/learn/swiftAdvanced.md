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
