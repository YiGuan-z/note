# 使用ktor+graalvm进行二进制编译

⚠️：graalvm编译ktor仅限于使用CIO engine，如果不是CIO，大概率会进行回退，没有原生效果。

## 添加构建资源

*在resource中新建如下目录：*

![META-INF/native-image/reflect-config.json](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307281359699.jpg)

进行反射资源的配置

[资源链接](https://github.com/ktorio/ktor-samples/blob/main/graalvm/src/main/resources/META-INF/native-image/reflect-config.json)

## 配置build.gradle.kts

直接给上官方链接

[链接](https://github.com/ktorio/ktor-samples/blob/main/graalvm/build.gradle.kts)
