# mdbook

## 导入其他md

使用`{{#include ./your.md}}`来导入其他md。

还有一个`{{#playpen ***}}`也能导入，但这是个什么意思呢？

## mdbook-toc

这是一个大md文件中显示目录的插件

### How install mdbook-toc

```shell
cargo install mdbook-toc
```

### How configure mdbook-toc

```toml
[preprocessor.toc]
command = "mdbook-toc"
renderer = ["html"]
```

### How use mdbook-toc

- Open a md file
- Add the following
  
```md
<!-- toc -->
```

## mdbook-mermaid

这是一个在mdbook中绘制思维导图的插件

### How install mdbook-mermaid

```shell
cargo install mdbook-mermaid
```

### How Configure mdbook-mermaid

#### Add configuration to your book

```shell
mdbook-mermaid install {path to your book}
```

#### Add the following to the book.toml

```toml
[preprocessor.mermaid]
command = "mdbook-mermaid"

[output.html]
additional-js = ["mermaid.min.js", "mermaid-init.js"]
```

### How use mermaid

Add it in your md file.

```md
    ```mermaid
        graph TD;
            A-->B;
            A-->C;
            B-->D;
            C-->D;
    ```
```

Run the mdbook and veiw the result

tips:

[graph TD;] is a directive in Mermaid syntax used to define the direction of the graphgraph indicates that this is a graph, 
and TD stands for Top Down.
Mermaid is a tool that allows you to generate diagrams and flowcharts using a syntax similar to Markdown.

In addition to TD, there are several other directions to choose from:

graph TB or graph TD: Top to Bottom
graph BT: Bottom to Top
graph LR: Left to Right
graph RL: Right to Left

## mdBook-pagetoc

[mdbook-pagetoc](https://github.com/JorelAli/mdBook-pagetoc)

用于给一篇文章添加右侧导航栏。

## 代码执行

[mdbook-cmdrun](https://github.com/FauconFan/mdbook-cmdrun)

可以在浏览器中执行代码。

## 更漂亮的消息块

好看的消息块

[mdbook-admoish](https://github.com/tommilligan/mdbook-admonish.git){{footnote:https://tommilligan.github.io/mdbook-admonish/reference.html}}

```admonish
Test
```

```admonish quote
Test
```

```admonish success
Test
```

```admonish faq
Test
```

```admonish info
Test
```

```admonish warning
Test
```

```admonish danger
Test
```

```admonish example
Test
```

## 将book转化为知识库

将book转化为知识库
[gooseberry](https://github.com/out-of-cheese-error/gooseberry)

## PPT

据说是ppt🤔，不过我现在暂时没有用它的打算。
[mdbook-presentation-preprocessor](https://github.com/FreeMasen/mdbook-presentation-preprocessor)
