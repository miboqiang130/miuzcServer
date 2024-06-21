# miuzcServer

miuzc 的服务端

## 安装

1. 服务基于 **nginx** + **openresty**的[lua_nginx_module](https://github.com/openresty/lua-nginx-module)，请先安装
2. 准备好音乐目录和歌词目录
3. 将项目拉到服务器，并在 nginx 配置中引入本项目内的 nginx.conf

```
http {
  ...
  default_type application/octet-stream;

  include /home/project/path/nginx.conf;
}
```

4. 修改项目 nginx.conf 文件中 lua 文件的路径（）以及 nginx 变量
5. 启动 nginx

## 相关链接

- [miuzcPC](https://github.com/miboqiang130/miuzcPC): PC 端音乐播放器
