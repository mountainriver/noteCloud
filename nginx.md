## 自行颁发不受浏览器信任的SSL证书
1. 生成一个RSA密钥  
`$ openssl genrsa -des3 -out 33iq.key 1024`
2. 拷贝一个不需要输入密码的密钥文件  
`$ openssl rsa -in 33iq.key -out 33iq_nopass.key`
3. 生成一个证书请求  
`$ openssl req -new -key 33iq.key -out 33iq.csr`
4. 自己签发证书  
`$ openssl x509 -req -days 365 -in 33iq.csr -signkey 33iq.key -out 33iq.crt`
> 第3个命令是生成证书请求，会提示输入省份、城市、域名信息等，重要的是，email一定要是你的域名后缀的。这样就有一个 csr 文件了，提交给 ssl 提供商的时候就是这个 csr 文件。当然我这里并没有向证书提供商申请，而是在第4步自己签发了证书。
## 编辑配置文件nginx.conf，给站点加上HTTPS协议
```
server {
    server_name YOUR_DOMAINNAME_HERE;
	listen 443;
	ssl on;
	ssl_certificate /usr/local/nginx/conf/33iq.crt;
	ssl_certificate_key /usr/local/nginx/conf/33iq_nopass.key;
	# 若ssl_certificate_key使用33iq.key，则每次启动Nginx服务器都要求输入key的密码。
}
```
重启Nginx后即可通过https访问网站了。
自行颁发的SSL证书能够实现加密传输功能，但浏览器并不信任，
## 只针对注册、登陆进行https加密处理
既然HTTPS能保证安全，为什么全世界大部分网站都仍旧在使用HTTP呢？使用HTTPS协议，对服务器来说是很大的负载开销。从性能上考虑，我 们无法做到对于每个用户的每个访问请求都进行安全加密（当然，Google这种大神除外）。作为一个普通网站，我们所追求的只是在进行交易、密码登陆等操 作时的安全。通过配置Nginx服务器，可以使用rewrite来做到这一点。
```
在https server下加入如下配置：
if ($uri !~* "/logging.php$")
{
    rewrite ^/(.*)$ http://$host/$1 redirect;
}
在http server下加入如下配置：
if ($uri ~* "/logging.php$")
{
  rewrite ^/(.*)$ https://$host/$1 redirect;
}
这样一来，用户会且只会在访问logging.php的情况下，才会通过https访问。
		  
更新：有一些开发框架会根据 $_SERVER['HTTPS'] 这个 PHP 变量是否为 on 来判断当前的访问请求是否是使用 https。为此我们需要在 Nginx 配置文件中添加一句来设置这个变量。遇到 https 链接重定向后会自动跳到 http 问题的同学可以参考一下。
server {
	...
    listen 443;
    location \.php$ {
	...
    include fastcgi_params;
    fastcgi_param HTTPS on; # 多加这一句
    }
}
server {
	...
    listen 80;
    location \.php$ {
    ...
    include fastcgi_params;
    }
}
```
