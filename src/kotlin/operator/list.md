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
