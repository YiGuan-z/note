# action使用笔记

Github的action存放于<code>./github/workflow</code> 目录中,workflow都采用yml格式，名字随意。

## run-name

从工作流文件中生成的运行名称，并在Action中显示，如果不写，则运行名称就会自动设置为工作流运行的时间信息。例如，对于由or事件触发的工作流，将其设置为提交消息。

**示例**:

``` yml
 run-name: Deploy to ${{inputs.deploy_target}} by @${{github.actor}}
```

## 使用on对事件进行监听

- 监听单个事件，当被推送到存储库的任何分支后运行。
  
    ``` yml
    on: push
    ```

- 监听多个事件，当被推送存储库或存储库被分叉的时候运行。

    ``` yml
    on: [push,fork]
    ```

- 也可以写为

    ```yml
    on:
        push:
            branches: ["master"]
        pull_request:
            branches: ["master"]
    ```

    以添加更多条件

## 对go语言进行构建的文件模版

可以参考 [这个配置文件](https://github.com/YiGuan-z/port-scanner/blob/master/.github/workflows/makefile.yml)

里面的重点在于jobs的编写

```yml
jobs:
    build:
        name: build
        # 这是选择指定的操作系统运行
        runs-on: ubuntu-latest
        #它也可以是一个数组
        # runs-on: [linux,64,Ubuntu]
        steps:
            #这个步骤用于签出当前分支。
            - name: check out
                uses: actions/checkout@v3.5.3
            # 用于设置go环境，with里面用于详细设置
            - name: Set go Env
                uses: actions/setup-go@v4.0.1
                with:
                    go-version: 1.20.5
                    cache: true
                    architecture: x64
            # 开始运行构建主流程
            - name: Build
                run: make
            # 上传工件
            - name: Upload a Build
                uses: actions/upload-artifact@v3.1.2
                with:
                    path: build
                    name: port-scanner
```

有关更多的runs-on选项，可以参考[Github官方文档](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#choosing-github-hosted-runners)