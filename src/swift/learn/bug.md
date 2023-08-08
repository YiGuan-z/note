# 编码中遇到的问题

## [x] Beta版Xcode

我就不该为了Game Porting Toolkit这个东西升级Sonnoma。
使用新版的代价就是，你创建一个代码文件它就崩溃，你敢创建它就敢崩溃。

我就这样写了一周，想着新版本的Xcode（beta5）应该能解决这个问题，结果新版本Xcode问题更多，无奈，回滚了低版本的测试版。你问我为什么不回滚为14.3.1，因为测试版系统安装了14.3.1也会提示无法使用，需要更新。

最后倒是通过`New Bing`解决了这个问题，它让我使用`defaults`命令对程序进行重置配置。命令如下：

`defaults delete com.apple.dt.Xcode`

虽然重置完确实好多了，但是我又要重新配置Xcode了，这可真是个悲伤的故事。

## [x] Picker的label不显示

这个问题好像是苹果的一个bug来着，不是bug的话我无法理解为什么有label参数但是label中的内容不渲染。

解决方式如下：<https://stackoverflow.com/questions/70835085/picker-label-changing-to-selected-value-swiftui>

使用Menu包裹住Picker，并将label写到Menu中。

## [] Text中使用background移动到屏幕边缘会导致朝向边缘的背景色超出框架

这问题我只有一点点猜测，可能是移动到边缘有吸附效果什么的，因为一旦我添加了`padding`，或者是使用`offset`让其不靠近边缘，它都不会超出，也可以使用不带参数的`frame`，反正我没啥头绪。

好神奇啊。

```admonish info
xcode 15.beta5(15A5209g)
Simulators iOS 17.0(21A5291g)
Model: iPhone Xs
```

~~~admonish bug
```swift
struct FrameText:View {
    var body: some View {
        VStack{
                Text("Hello, World!")
                    .frame(width: 150,height: 50)
                    .background(Color.blue)
                Spacer()
        }
    }
}
```
~~~
