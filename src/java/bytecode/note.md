# Java 笔记

## 速查表

## Java 简介

Java 是一门历史悠久的编程语言，它解决了 C 语言在使用中需要手动管理内存痛点，并且由于 Java 字节码的动态性，使得可以动态生成新的类或者动态修改类结构（添加、删除、修改新的属性和方法），但是语法上几乎就没有怎么变过，如果想要使用现代语言，可以试试[kotlin](https://www.kotlincn.net)。

## 优点

- 简单
- 强 OOP
- 跨平台兼容
- 丰富的依赖库
- 强大的内存管理，不用手动管理指针。

## 缺点

- 过于 OOP。
- 语法从不更新。
- 容易变成 spring 程序员而不是 Java 程序员。
- 巨大的内存占用，高 jdk 版本有明显改善。

## Java 关键字速查表

|      关键字类型      |    关键字    |                          作用                           |
| :------------------: | :----------: | :-----------------------------------------------------: |
|    控制访问修饰符    |   private    |                        私有权限                         |
|                      |    public    |                         公开的                          |
|                      |  protected   |                        受保护的                         |
| 类、方法、变量修饰符 |   abstract   |                   抽象类 抽象方法声明                   |
|                      |    class     |                      类声明关键字                       |
|                      |   extends    |                          继承                           |
|                      |    final     |           最终的，不可变(建议在变量上都添加)            |
|                      |  implements  |                          实现                           |
|                      |    native    |               本地方法，非 Java 语言实现                |
|                      |     new      |                 在堆中创建一个新的对象                  |
|                      |    static    |                          静态                           |
|                      |   strictfp   |                    精准的浮点数运算                     |
|                      | synchronized |                          同步                           |
|                      |  transient   |                      序列化时忽略                       |
|                      |   volatile   |                      强制访问内存                       |
|     程序控制语句     |    break     |                        跳出循环                         |
|                      |     case     |                  switch 中的待匹配选项                  |
|                      |   continue   |                      跳过当前循环                       |
|                      |   default    |                          默认                           |
|                      |   do while   |                   先执行后判断的循环                    |
|                      |     else     |                   用于 if 的分支语句                    |
|                      |      if      |                          判断                           |
|                      |     for      |                        循环语句                         |
|                      |  instanceof  |                  判断两个实例是否相同                   |
|                      |    return    |                   返回值或者结束方法                    |
|                      |    switch    |                     可能性选择语句                      |
|                      |    while     |                          循环                           |
|       错误处理       |    assert    |                 判断一个表达式是否为真                  |
|                      |    catch     |                        捕获异常                         |
|                      |   finally    | 在 try catch 中是否运行成功都执行，参考 go 语言的 defer |
|                      |    throw     |                      跑出一个异常                       |
|                      |    throws    |                 声明一个可能的异常抛出                  |
|                      |     try      |                        捕获异常                         |
|        包相关        |    import    |                       倒入一个类                        |
|                      |   package    |                           包                            |
|       基本类型       |   boolean    |                         布尔值                          |
|                      |     byte     |                          字节                           |
|                      |     char     |                          字符                           |
|                      |    double    |                      双精度浮点数                       |
|                      |    float     |                      单精度浮点数                       |
|                      |     int      |                         整数值                          |
|                      |     long     |                         长整数                          |
|                      |    short     |                         短整数                          |
|                      |     null     |                           空                            |
|       变量引用       |    super     |                          父类                           |
|                      |     this     |                          本类                           |
|                      |     void     |                          无值                           |
|      保留关键字      |     goto     |              表示无条件跳转，但是不能使用               |
|                      |    const     |            是定义常量的关键字，但是不能使用             |

tips:goto 在 Java 中不能使用，但是在 jvm 中可以使用，这是实现流程控制的关键字段。
