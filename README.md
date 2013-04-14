# tweebo

自动同步 Twitter 到新浪微博的服务，用了 Twitter Stream API，一发推就试着同步到微博。
参考了前同事的 [t2w](https://github.com/xream/t2w)。
不过我这个 Ruby 的实现不用自己查 Twitter UserID，而且链接用 goo.gl 缩短即使被墙也可以成功发到新浪上，比他的好用一点点 ^___^


### 安装

```
$ git clone https://github.com/lexrus/tweebo.git
$ cd tweebo
$ bundle install
```


### 使用方法

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


### 服务
#### Heroku
先 ```heroku create``` 创建 Heroku 项目。
然后增加配置：
```
heroku config:add TWITTER_SCREEN_NAME= TWITTER_CONSUMER_KEY= TWITTER_CONSUMER_SECRET= TWITTER_OAUTH_TOKEN= TWITTER_OAUTH_TOKEN_SECRET= WEIBO_USERNAME= WEIBO_PASSWORD=
```


#### Mac OS
Mac 上建议用 [lunchy](https://github.com/mperham/lunchy)，配置见 com.lextang.tweebo.plist，注意先修改其中的安装地址。
```
$ lunchy install com.lextang.tweebo.plist
$ lunchy start tweebo
```
#### Linux
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


### LICENSE
Copyright (C) 2013 LexTang.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.