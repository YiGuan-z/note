# 模拟开发一个用户注册

这时候为了和以前的代码区分开来，我们就需要使用`Group`这个新功能为我们的用户注册页面分包。

像平常创建新文件一样，只不过这次不再点击`New File`，而是点击`New Group`进行代码分组。

我们为这个组命名为`OnboardingViews`，代表这里面的页面都是和注册页面相关联的页面。

## IntroView

让我们先编写以第一个页面，它可以用于在注册登陆状态和已登陆状态之间转换。

~~~admonish example title="IntroView.swift"
```swift
struct IntroView: View {
    //132, 89, 240
    let color1 = Color(red: 132/255, green: 89/255, blue: 240/255)
    //99, 39, 238
    let color2 = Color(red: 99/255, green: 39/255, blue: 238/255)
    
    @AppStorage("signed_in") var currentUsesrSignedIn:Bool = false
    
    var body: some View {
        ZStack{
            RadialGradient(
                colors: [color1,color2],
                center: .topLeading,
                startRadius: 5,
                endRadius: UIScreen.main.bounds.height
            )
            .ignoresSafeArea()
            // MARK: 用户是否登陆的路由判断
            
            if currentUsesrSignedIn{
                Text("ProfileView")
            }else{
                Text("OnboardingView")
            }
            
        }
    }
}

#Preview {
    VStack{
        IntroView()
    }
}

```
~~~

我们使用一个好看的渐变来对制作一个背景。

同时使用`@AppStorage`在程序中存储一个登陆标记，通过这个标记，我们在两个页面之间进行切换。

## OnboardingView

我们先对`OnboardingView`页面进行开发，我们需要对当前输入流程进行控制。

我们的用户注册暂拟三项，用户名，年纪，性别。给予了这三项信息的用户即可进入到我们的ProfileView页面中。

让我们先把这大致框架编写出来。

```swift
struct OnboardingView: View {
    //Onboarding states:
    /*
     0 - Welcome Screen
     1 - Add name
     2 - Add age
     3 - Add gender
     */
    @State var onboardingState:Int = 0
    //onboarding inputs
    @State var name:String = ""
    
    @State var age:Double = 18
    
    @State var gender:String = ""
    // for the alert
    @State var alertTitle:String = ""
    
    @State var showAlert:Bool = false
    // app storage
    
    @AppStorage("name") var currentUserName:String?
    @AppStorage("age") var currentUserAge:Int?
    @AppStorage("gender") var currentUserGender:String?
    @AppStorage("signed_in") var currentUserSignedIn:Bool = false
    
    let transition:AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal:.move(edge: .leading)
    )
    
    var body: some View {
        ZStack{ //Zstark start
            // MARK: Content
            switch onboardingState{
            
            case 0:
                //MARK: WelCome Screen
                welcomeSection
                    .transition(transition)
            case 1:
                //MARK: Add name
                addNameSection
                    .transition(transition)
            case 2:
                //MARK: Add age
                addAgeSection
                    .transition(transition)
            case 3:
                //MARK: Add gender
                addGender
                    .transition(transition)
            default:
                //MARK: ERROR
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.green)
            }
                
            
            // MARK: Button
            
            VStack{
                Spacer()
                
                buttomButton
                    
            }
            .padding(30)
        }//Zstack end
        .alert(isPresented: $showAlert, content: {
            return Alert(title: Text(alertTitle))
        })
        
    }   
}

#Preview{
    OnboardingView()
    //让我们的背景界面为紫色，因为我们的字体是白色的。
            .backgoround(Color.purple)
}


```

### 组件逻辑编写

我们完成了大致框架的编写，接下来应该对里面的`welcomeSection`、`addNameSection`、`addAgeSection`、`addGender`、`buttomButton`

我们现在开始进行组件内容编写，因为这些组件的内容太多，我们选择使用扩展写法，避免写出一个巨大的`OnboardingView`

```swift
// MARK: components
extension OnboardingView{
    private var buttomButton: some View{
        //不要学习视频中的三元表达式写法，到处写的话，之后看代码能痛死你。
        let showText = switch onboardingState{
        case 0: "SING UP"
        case 3: "FINISH"
        default: "NEXT"
        }
        
        return Text(showText)
            .font(.headline)
            .bold()
            .foregroundColor(.purple)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .onTapGesture {
                handleNextButtonPressed()
            }
    }

    private var welcomeSection:some View{
        VStack(spacing:40){
            Spacer()
            Image(systemName: "heart.text.square.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150,height: 150)
            Text("Hello, and welcome")
                .font(.title)
                .fontWeight(.semibold)
                .overlay (
                    Capsule(style: .continuous)
                        .frame(height: 3)
                        .offset(y: 10.0)
                    ,alignment: .bottom
                )
            
            Text("这是年轻人的第一款app，你所热爱的，是你的生活")
                .fontWeight(.semibold)
            Spacer()
            Spacer()
        }
        .multilineTextAlignment(.center)
        .foregroundColor(.white)
        .padding(30)
    }
    
    private var addNameSection: some View{
        VStack(spacing:30){
            Spacer()
            Text("What's your name?.")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            TextField("Your name here...", text: $name)
                .font(.headline)
                .frame(width: UIScreen.main.bounds.width/1.8,height: 50)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(.black)
            Spacer()
            Spacer()
        }
        
        .padding(30)
    }
    
    private var addAgeSection: some View{
        VStack(spacing:30){
            Spacer()
            Text("What's your age?.")
                .font(.title)
                .fontWeight(.semibold)
            
            let age = String(format: "%.0f", age)
            Text("\(age)")
                .font(.largeTitle)
                .fontWeight(.semibold)
                
            Slider(value: $age,in: 18...100,step: 1)
                .accentColor(.white)
            Spacer()
            Spacer()
        }
        .foregroundColor(.white)
        .padding(30)
    }
    
    private var addGender:some View{
        VStack(spacing:30){
            Spacer()
            Text("What's your gender?.")
                .font(.title)
                .fontWeight(.semibold)
                .font(.headline)
            //如果Picker的label无法展示，那么就查看下面链接的解决方案。👇
            //https://stackoverflow.com/questions/70835085/picker-label-changing-to-selected-value-swiftui
            Menu{
                Picker("Selection a gender",selection: $gender) {
                    Text("Male").tag("male")
                    Text("Female").tag("female")
                    Text("Non-Binary").tag("non-binary")
                }
                .accentColor(.white)
            } label: {
                Text(gender.count > 1 ? gender : "Select a gender")
                            .font(.headline)
                            .foregroundColor(.purple)
                            .frame(height: 50)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(10)
            }
            Spacer()
            Spacer()
        }
        .foregroundColor(.white)
        .padding(30)
    }

}
```

### 方法逻辑

组件完成后，我们开始对方法进行扩展{{footnote:组件逻辑和方法逻辑是很有必要分开的，如果混在一起，将会变得不幸}}

还需要单独编写一个扩展区域对组件方法进行扩展。

```swift
// MARK: Functions
extension OnboardingView {
    func handleNextButtonPressed(){
        //check
        switch onboardingState{
        case 1:
            guard name.count >= 3 else {
                showAlert("用户名不得少于3个字符😭")
                return
            }
        case 3:
            guard gender.count >= 3 else{
                showAlert("请选择性别🥹")
                return
            }
        default:
            break
        }
        
        //next section
        //流程到3的时候就已经结束了
        if onboardingState == 3{
            signIn()
        }else{
            withAnimation(.spring) {
                onboardingState += 1
            }
        }
    }
    
    func signIn(){
        currentUserName = name
        currentUserAge = Int(age)
        currentUserGender = gender
        onboardingState = 0
        withAnimation(.spring){
            currentUserSignedIn = true
        }
    }
    
    
    func showAlert(_ message:String){
        alertTitle = message
        showAlert.toggle()
    }
}
```

## ProfileView

由于`ProfileView`中的是一些用户信息展示，你可以随意发挥对UI进行构建。

```swift
struct ProfileView: View {
    @AppStorage("name") var currentUserName:String?
    @AppStorage("age") var currentUserAge:Int?
    @AppStorage("gender") var currentUserGender:String?
    @AppStorage("signed_in") var currentUserSignedIn:Bool = false
    
    var body: some View {
        VStack(spacing:20){
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150,height: 150)
            Text(currentUserName ?? "Your name is here")
            Text("This user is \(currentUserAge ?? 0) years old")
            Text("Their gender is \(currentUserGender ?? "unknown")")

            Text("sign out".uppercased())
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.semibold)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .cornerRadius(10)
                .padding()
                .onTapGesture {
                    signOut()
                }
        }
        .font(.title)
        .padding()
        .padding(.vertical,40)
        .background(Color.white)
        .cornerRadius(10)
        
        .shadow(radius: 10)
    }
    
    func signOut(){
        currentUserName = nil
        currentUserAge = nil
        currentUserGender = nil
        withAnimation(.spring) {
            currentUserSignedIn = false
        }
        
    }
}

#Preview {
    ProfileView()
}
```

## END

现在可以对`IntroView`进行修改，将我们编写的两个UI控件使用上去。

```swift
if currentUsesrSignedIn{
   ProfileView()
        .foregroundColor(.purple)
        .transition(
            .asymmetric(insertion: .move(edge: .bottom),removal: .move(edge: .top)))
        .animation(.spring)
}else{
    OnboardingView()
        .transition(.asymmetric(insertion: .move(edge: .top),removal: .move(edge: .bottom)))
        .animation(.spring)
}

```
