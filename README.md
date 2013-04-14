# tweebo

同步 Twitter 到新浪微博...
参考了前同事的 [t2w](https://github.com/xream/t2w)。
不过我这个 Ruby 的实现不用自己查 Twitter UserID，而且链接用 goo.gl 缩短即使被墙也可以成功发到新浪上，比他的好用一点 ^___^

### 安装

```
$ git clone https://github.com/lexrus/tweebo.git
$ cd tweebo
$ bundle install
```

新建一个 config.yml 文件，内容如下：

``` yaml
twitter:
  screen_name:        twitter_screen_name # 比如 @lexrus 就用 lexrus
  consumer_key:       YOUR_CONSUMER_KEY # 在这儿申请: https://dev.twitter.com
  consumer_secret:    YOUR_CONSUMER_SECRET
  oauth_token:        YOUR_OAUTH_TOKEN
  oauth_token_secret: YOUR_OAUTH_TOKEN_SECRET

weibo:
  app_key:      211160679
  app_secret:   63b64d531b98c2dbff2443816f274dd3
  username:     微博用户名
  password:     微博密码
  callback_url: http://weibo.com/
```

建议用 supervisor 启动 ```ruby tweebo.rb```

### LICENSE
Copyright (C) 2013 LexTang.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.