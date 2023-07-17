# Commento评论系统部署

Commento是一个开源的评论系统，它可以让用户很方便地将评论集成到一个静态站点。

分为自托管和托管两种方式。这里我就选择自托管，因为托管需要每月10USD（主要是没钱）。

Commento提供了三种自托管逻辑，分别为使用二进制文件、Docker或者从源码进行编译。

## 安装

### 使用二进制文件

虽然官方让你去包管理器查找，但是他们好像有点懒得发布。只有`arch`的AUR和`Fedora/centos`这两个才有包。

所以我们直接下载二进制

```shell
wget https://commento-release.s3.amazonaws.com/commento-linux-amd64-v1.4.0.tar.gz

tar xvf commento-linux-amd64-v1.4.0.tar.gz -C /path/to/installation/
```

#### 参数

在启动程序之前，我们还需要配置环境变量，一下是环境变量的KEY和它的作用

|KEY|示例|作用|
|:---:|:---:|:---:|
|COMMENTO_ORIGIN|设置本服务器的访问路径|`http://example.com:8080`|
|COMMENTO_PORT|设置端口号|`8080`|
|COMMENTO_POSTGRES|`postgres://username:password@postgres.example:5432/commento`|数据库链接|
|COMMENTO_CDN_PREFIX|`http://example.com:8080`|如果设置了CDN，请填入CDN的链接，否则与COMMENTO_ORIGIN相同|

#### 通过脚本运行

我们可以写一个脚本来专门启动这个程序

```shell
export COMMENTO_ORIGIN=http://example.com:8080
export COMMENTO_PORT=8080
export COMMENTO_POSTGRES=postgres://username:password@postgres.example:5432/commento
./commento
```

### Docker

这里使用docker-compose进行容器编排

#### 编写docker-compose

```yml
version: '3'

services:
  server:
    image: registry.gitlab.com/commento/commento:latest
    networks:
      - my_commento
    ports:
      - 8080:8080
    environment:
      COMMENTO_ORIGIN: http://49.232.150.194:8080
      COMMENTO_PORT: 8080
      COMMENTO_POSTGRES: postgres://u1:1231231@db:5432/commento?sslmode=disable
    depends_on:
      - db
  db:
    image: postgres
    restart: always
    networks:
      - my_commento
    environment:
      POSTGRES_DB: commento
      POSTGRES_USER: u1
      POSTGRES_PASSWORD: 1231231
    volumes:
      - postgres_data_volume:/var/lib/postgresql/data

networks:
  my_commento:
    
volumes:
  postgres_data_volume:

```

#### 通过docker-compose运行

将这个yml文件上传到你的docker服务器。

*并执行：*

```shell
docker-compose -f /you/path/to/file up 
```

>建议放入tmux或者screen，方便随时查看日志。

### 源码编译

#### 编译

```shell
git clone https://gitlab.com/commento/commento.git
cd commento
make prod
```

将会自动进行项目的构建，命令结束后构建输出将会存放在`./build/prod/`。

运行方式和使用官方的二进制方式一样。[传送门](#使用二进制文件)

## END

由于我本人没有进行备案（麻烦）所以只在本地跑通了。因为我的评论服务在`http`工作，而我的网页在`https`，是由`GitHubPage`进行的静态托管。

`https`从`http`服务器加载资源的时候，浏览器通常会直接拦截，因为从`http`加载的内容更容易遭到篡改。

*真想要评论的话，可以clone这个仓库:*

```shell
git clone https://github.com/YiGuan-z/note
cd shell
make prod
make serve
```

在浏览器中访问`http://localhost:3000`即可看到评论

## 参考链接

[commento官方文档](https://docs.commento.io)
[docker从入门到实践-docker-compose命令解释篇](https://docker-practice.github.io/zh-cn/compose/commands.html)
