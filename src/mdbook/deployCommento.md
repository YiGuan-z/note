# Commento评论系统部署

Commento是一个开源的评论系统，它可以让用户很方便地将评论集成到一个静态站点。

分为自托管和托管两种方式。这里我就选择自托管，因为托管需要每月10USD（主要是没钱）。

Commento提供了三种自托管逻辑，分别为使用二进制文件、Docker或者从源码进行编译。

## 安装

### 使用二进制文件

### Docker

#### 编写docker-compose

### 源码编译

## END

由于我本人没有进行备案（麻烦）所以只在本地跑通了。因为我的评论服务在`http`工作，而我的网页在`https`，是由`GitHubPage`进行的静态托管。

`https`从`http`服务器加载资源的时候，浏览器通常会直接拦截，因为从`http`加载的内容更容易遭到篡改。

*真想要评论的话，可以clone这个仓库:*

```shell
git clone https://github.com/YiGuan-z/note
cd shell
make dependence
make server
```

在浏览器中访问`http://localhost:3000`即可看到评论
