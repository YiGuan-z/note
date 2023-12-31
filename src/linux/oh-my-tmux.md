# 高效率（装逼）使用tmux

tmux是一个终端复用程序，它可以让你在一个窗口中，同时执行多个会话，对于在目标机器中跑长任务是一个福音。它还支持窗口的水平拆分和垂直拆分。

没有安装tmux的机器可以使用以下代码进行安装。

centos/fedora

```shell
sudo yum install tmux
```

ubuntu/debian

```shell
sudo apt install tmux
```

macos

```shell
brew install tmux
```

安装完毕后输入tmux进行体验吧。

## 在多个终端上同步显示窗口

tmux是用来分离会话使用的程序，要退出当前会话使用`control + b d`将会话转入后台运行，同样，也支持多个终端连接到同一个会话，这时我们可以多开几个终端，并在每个终端上输入`tmux a`即可在每个终端中同步显示会话。

![tmux](https://raw.githubusercontent.com/YiGuan-z/images/master/1/202307281324215.jpg)

## 使用oh-my-tmux进行增强体验

[oh-my-tmux](https://github.com/gpakosz/.tmux)
是一款tmux的增强，尤其是增强了主题（这个是重点），根据作者的文档提示进行操作即可完成安装。

## tmux速查表

- 会话相关命令：
  - s：列出所有会话
  - d：离开当前会话
  - $：重命名当前会话
- 窗口相关命令：
  - c：创建一个新窗口
  - n：切换到下一个窗口
  - w：从列表中选择窗口
  - <0~9>：切换到指定编号的窗口，编号显示在状态栏
  - ,：窗口重命名
- 窗格相关命令：
  - %：分成左右两个窗格
  - "：分成上下两个窗格
  - z：当前窗格全屏显示，再按一次恢复
  - q：显示窗格编号
  - t：在当前窗格显示时间
  - 方向键：光标切换到其他窗格
  - o：光标切换到下一个窗格
  - {：左移当前窗格
  - }：右移当前窗格
  - Ctrl+o：上移当前窗格
  - Alt+o：下移当前窗格
  - space：切换窗格布局
