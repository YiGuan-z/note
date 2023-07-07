# makefile编写手记

<strong>tips：只会记录一些我遇到的问题</strong>

## go语言在交叉编译时设置的环境变量不生效

``` makefile
build-mac-arm:
    export $(call env,darwin,arm64) 
    go build main.go
build-mac-amd:
    export $(call env,darwin,amd64)
    go build main.go

    env = CGO_ENABLED=0 GOOS=$(1) GOARCH=$(2)
```

这是我的失误，不应将其分为两行，两行会分为两个shell进行执行，所以就导致明明设置了环境但是环境不生效。

```makefile
    build-mac-arm:
        export $(call env,darwin,arm64) && go build main.go
    build-mac-amd:
        export $(call env,darwin,amd64) && go build main.go
```

修改为一行后成功编译

## 关于数组

   这里面的数组直接写字符，每个元素使用空格隔开即可，例如:

```shell
files = a.txt b.txt c.txt
```

使用方式很简单，for循环即可，不需要过多处理：

```shell
@for f in (files); do \
    echo $$f; \
done; \
```

## 关于 **@**

   这里面的 **@** 是用于控制命令的回显，对于有些过程命令则可以添加上 **@** 防止输出过多无关内容

   ```makefile
    echo:
        for i in 1 2 3 4; do\
            echo $$i; \
        done
   ```

   ```makefile
    echo:
        @for i in 1 2 3 4; do\
            echo $$i; \
        done
   ```

## 关于\$和\$\$的区别

在这里的一个\$代表的是makefile变量，两个\$代表的是shell变量调用makefile变量的时候需要$(变量名)才能调用到变量。
<br>

### 关于方法

方法在里面直接声明即可,并使用call关键字进行调用，例如:

``` makefile
reverse = $(1) | rev
test:
    @echo $(call reverse,Hello)
```

将会输出olleH，这是Hello的反转版本。

## 外部链接

[go语言makefile的示例](https://github.com/YiGuan-z/port-scanner/blob/master/makefile)