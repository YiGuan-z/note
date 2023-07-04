# 你不得不使用的on-my-zsh

[on-my-zsh](https://ohmyz.sh)以下简称omz，作为一款高颜值的shell框架，可使用命令补全，命令高亮等等……

![配置完成的omz](./image/omz.jpg)

tips：建议在.zshrc中添加以下插件

```configure
plugins=(git zsh-syntax-highlighting zsh-autosuggestions cp z command-not-found macos)
```

macos是一组macos系统上特有的命令，linux可不必添加。

## 1. omz实用命令手册

### 1.1 plugin命令

|命令|参数|效果|
|:---:|:---:|:---:|
|disable|插件名|关闭这个插件|
|enable|插件名|开启这个插件|
|info|插件名|这个插件的信息|
|list|无|显示所有可用的omz插件|
|load|插件名|加载插件|

### 1.2 theme命令

|命令|参数|效果|
|:---:|:---:|:---:|
|set|主题名|设置该主题到你的.zshrc文件中|
|use|主题名|加载这个主题|
|list|无|显示所有主题|

不过，我的主题使用的是 [powerlevel10k](https://github.com/romkatv/powerlevel10k),这个主题非常棒🎉。根据教程安装完毕后可以运行p10k configure来对主题进行一些自定义配置。
