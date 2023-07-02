<!-- toc -->

# mdbook

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
