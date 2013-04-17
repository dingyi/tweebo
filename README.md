# tweebo

自动同步 Twitter 到新浪微博的服务，用了 Twitter Stream API，一发推就试着同步到微博。
参考了前同事的 [t2w](https://github.com/xream/t2w)，重写成 Ruby 的，并做了一些改进。


## 特点
* 提供 supervisord 和 launchdaemon 的配置
* 不用自己查 Twitter User ID，只要提供 Screen Name
* 缩链接先展开，再用 goo.gl 缩短，防止新浪微博过滤，被墙的地址也能成功发到新浪上
* 可以部署到 Heroku，但是 Heroku 连接新浪很不稳定，不推荐这种方式


## 基本要求
* Ruby 1.9.3 建议用 [rbenv](https://github.com/sstephenson/rbenv/) 安装
* bundler 用 ```gem install bundler``` 安装
* 在 [dev.twitter.com](https://dev.twitter.com) 上建一个 App，然后拿到 consumer key/secret 和 oauth token/secret 一共四条字符串
* 新浪微博帐号


## 下载和更新
```
git clone https://github.com/lexrus/tweebo.git
cd tweebo
bundle install
```
更新
```
git fetch
```


---------


## Mac 和 Linux 部署方法

新建一个 config.yml 文件，内容如下：

``` yaml
twitter:
  screen_name:        twitter_screen_name # 比如 @lexrus 就用 lexrus
  consumer_key:       YOUR_CONSUMER_KEY # 在这儿申请: https://dev.twitter.com
  consumer_secret:    YOUR_CONSUMER_SECRET
  oauth_token:        YOUR_OAUTH_TOKEN
  oauth_token_secret: YOUR_OAUTH_TOKEN_SECRET

weibo:
  username:     微博用户名
  password:     微博密码
```


### Mac
Mac 上建议用 [lunchy](https://github.com/mperham/lunchy)，配置见 com.lextang.tweebo.plist，注意先修改其中的安装地址。
```
$ lunchy install com.lextang.tweebo.plist
$ lunchy start tweebo
```


### Linux
Linux 上建议用 [supervisor](http://supervisord.org)，假设装在 /usr/local/tweebo 目录下，配置是：
```
[program:tweebo]
command=/usr/bin/env ruby /usr/local/tweebo/tweebo.rb
numprocs=1
directory=/usr/local/tweebo
autostart=true
autorestart=unexpected
startretries=3
startsecs=3
stdout_logfile=/tmp/tweebo.log
stdout_logfile_maxbytes=1MB
stderr_logfile=/tmp/tweebo.error.log
stderr_logfile_maxbytes=1MB
```


---------

## Heroku 部署方法

进入 tweebo 目录后先 ```heroku create``` 创建 Heroku 项目。
然后增加配置(注意替换单引号里的值)：
```
heroku config:add TWITTER_SCREEN_NAME='...' TWITTER_CONSUMER_KEY='...' TWITTER_CONSUMER_SECRET='...' TWITTER_OAUTH_TOKEN='...' TWITTER_OAUTH_TOKEN_SECRET='...' WEIBO_USERNAME='...' WEIBO_PASSWORD='...'
```
然后用 ```heroku config``` 检查一下，没有错的话提交上去 ```git push -v heroku master:master``` 就部署好了。
发个推检查一下有没有同步到微博吧。

另外，觉得这样配置不够优雅的话可以移步 [heroku-config](https://github.com/ddollar/heroku-config) 用 .env 来配置 。


### LICENSE
Copyright (C) 2013 LexTang.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.