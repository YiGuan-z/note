# 可重载运算符列表

## 一元运算符

|运算符|重载方法|
|:---:|:---:|
|++|a.inc()|
|--|a.dec()|

## 二元运算符

|运算符|重载方法|
|:---:|:---:|
|a+b|a.plus(b)|
|a-b|a.minus(b)|
|a*b|a.times(b)|
|a/b|a.div(b)|
|a%b|a.rem(b)|
|a..b|a.rangeTo(b)|

## 关键字

|运算符|重载方法|
|:---:|:---:|
|a in b|b.contains(b)|
|a !in b|!b.contains(b)|

> 只有contains一个方法

## 索引运算符

|运算符|重载方法|
|:---:|:---:|
|a[i]|a.get(i)|
|a[i,j]|a.get(i,j)|
|a[i_1,...,i_n]|a.get(vararg i)|
|a[i]=b|a.set(i,b)|
|a[i,j]=b|a.set(i,j,b)|
|a[i,...,i_n]=b|a.set(i,...,i_n)|

> 方括号里的参数将会被转化为适当数量的参数来调用 `get`和`set`

## 执行运算符

|表达式|重载方法|
|:---:|:---:|
|a()|a.invoke()|
|a(i)|a.invoke(i)|
|a(i,j)|a.invoke(i,j)|
|a(i_1,...,i_n)|a.invoke(i_1,...i_n)|

> 与索引运算符的规则相同，会转化为参数适量的`invoke`方法进行调用

## 附加任务

|表达式|重载方法|
|:---:|:---:|
|a+=b|a.plusAssign(b)|
|a-=b|a.minusAssign(b)|
|a*=b|a.timesAssign(b)|
|a/=b|a.divAssign(b)|
|a%=b|a.remAssign(b)|

## 比较运算符

|表达式|重载方法|
|:---:|:---:|
|a>b|a.compareto(b)>0|
|a<\b|a.compareTo(b)<0|
|a>=b|a.compareTo(b)>=0|
|a<=b|a.compareTo(b)<=0|

## 委托运算符

|表达式|重载方法|
|:---:|:---:|
|val a by X|x.getValue(thisRef:Any?,propety:Kpropety<*?>)|