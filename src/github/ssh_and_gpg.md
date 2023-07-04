# ssh key 和 gpg keys

## ssh key

ssh是一种加密的远程连接协议，该协议可以实现远程登陆，使用密码对ssh是一种极不安全的行为，更推荐使用公私钥的方式进行连接，github的用户认证也是通过公私钥来进行的。

### How create ssh key

- 打开你的终端
- 输入以下内容

```shell
ssh-keygen -t ed25519 -C "你的GitHub邮件地址"
```

- 根据提示操作即可。

- 给你的Github账户设置公钥
  - 找到你的ssh目录，它一般在`~/.ssh`中
  - 找到公钥文件，一般是以.pub结尾
  - 打开GitHub的账户设置，找到SSH and GPG keys，点击 New SSH key，标题自己随便取一个，key的内容就将公钥的内容复制过去。![ssh Option](./image/findGitHubSSH.jpg)
  - 最后点击保存![github save ssh](./image/save-ssh.jpg)




## gpg key

gpg密钥是用来保证这个代码时经过你同意的一个签名，它需要和github的提交邮箱保持一致，许多开源代码提交的时候都需要gpg验证后才能进行提交。
