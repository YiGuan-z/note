# vim

## vim的三种模式

有命令模式（Command mode），插入模式（Insert mode），与底线命令模式（Last line mode）

### 命令模式

用户启动vim的第一个模式就是命令模式。

该状态下的vim会将用户敲击键盘的动作视为vim命令，而非输入字符。例如我们按一个j，并不会输入一个j进去，j被当成了一个移动光标的指令。

| 命令 ^表示大小写通用 |         命令效果         |
| :------------------: | :----------------------: |
|          $           |           行末           |
|          0           |           行首           |
|          v           |         选择模式         |
|          V           |        行选择模式        |
|          y           |     拷贝被选择的内容     |
|          Y           |          拷贝行          |
|          p           |        在后面粘贴        |
|          P           |        在前面粘贴        |
|          {           |           段首           |
|          }           |           段尾           |
|          f           |       行内字符查找       |
|          F           |     行内字符反向查找     |
|          s           | 删除当前字符并在这里插入 |
|          S           |  删除当前行并在这里插入  |
|          w^          |        下一个单词        |
|          b^          |        上一个单词        |
|          e           |           词尾           |
|          a           |   在当前后一个位置插入   |
|          A           |        在行末插入        |
|          o           |         分段(后)         |
|          O           |         分段(前)         |
|          i           |         插入模式         |
|          I           |        在行首插入        |
|          u           |         撤销命令         |
|          U           |       撤销行内命令       |
|          `           |            `             | 行首 |
|          J           |         合并两行         |
|          K           |         帮助文档         |
|          /           |         查找字符         |
|          n           |        查找下一处        |
|          N           |        查找上一处        |
|          x           |         删除字符         |
|          X           |           退格           |

### 输入模式

在命令模式中按下i即可进入输入模式。

在输入模式中按下esc即可退出输入模式。

### 底线命令模式

在命令模式中按下「:」即可进入底线命令模式。
在底线命令模式可以输入控制命令，例如：

| 命令  |                  命令效果                  |
| :---: | :----------------------------------------: |
|   q   |             不保存，直接退出。             |
|  q!   |            不保存，并强制退出。            |
|  e!   | 放弃所有更改，并从上次保存的文件再开始编辑 |
|   w   |             保存文件，但不退出             |
|  w!   |              强制保存，不退出              |
| wq或x |                 保存并退出                 |
|  wq!  |              强制保存，并退出              |
| %!xxd |          以十六进制的方式解析文件          |
---

## 移动光标

使用 h、j、k、l来完成左、下、上、右四个方向的光标控制，方向键也可以完成操作。

在