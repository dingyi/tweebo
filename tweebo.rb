#!/usr/bin/env ruby
# encoding: utf-8

require 'tweetstream'
require 'twitter'
require 'yaml'
require 'weibo_2'
require 'googl'
require 'uri'
require 'net/http'


def url_expand(url)
  begin
    uri = URI(url)
    location = Net::HTTP.new(uri.host, 80).get(uri.path).header['location']
    location.empty??url:url_expand(location)
  rescue Exception => e
    url
  end
end

def googl(url)
  begin
    Googl.shorten(url).short_url
  rescue Exception => e
    url
  end
end

def institutionalizedWeibo(text, textMode=false)
  newText = text
  newText = newText.gsub(/https?\:\/\/[^\s]+/) do |match|
    googl(url_expand(match))
  end
  newText = newText.gsub(/https?\:\/\/([^\s]+)/, '🈲\1') if textMode
  newText = newText.gsub(/@([^\s]+)/, '👼\1')
  puts newText
  newText
end


configs = YAML.load(File.read('config.yml'))


Twitter.configure do |config|
  config.consumer_key = ENV['TWITTER_CONSUMER_KEY'] || configs['twitter']['consumer_key']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET'] || configs['twitter']['consumer_secret']
  config.oauth_token  = ENV['TWITTER_OAUTH_TOKEN'] || configs['twitter']['oauth_token']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN_SECRET'] || configs['twitter']['oauth_token_secret']
end

twitter_user_id = Twitter.user(ENV['TWITTER_SCREEN_NAME'] || configs['twitter']['screen_name']).id
puts 'Twitter UserID: %s' % twitter_user_id


TweetStream.configure do |config|
  config.consumer_key  = ENV['TWITTER_CONSUMER_KEY'] || configs['twitter']['consumer_key']
  config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET'] || configs['twitter']['consumer_secret']
  config.oauth_token  = ENV['TWITTER_OAUTH_TOKEN'] || configs['twitter']['oauth_token']
  config.oauth_token_secret = ENV['TWITTER_OAUTH_TOKEN'] || configs['twitter']['oauth_token_secret']
  config.auth_method = :oauth
end
twitterClient = TweetStream::Client.new


WeiboOAuth2::Config.api_key = '211160679'
WeiboOAuth2::Config.api_secret = '63b64d531b98c2dbff2443816f274dd3'
WeiboOAuth2::Config.redirect_uri = 'http://weibo.com/'

weiboClient = WeiboOAuth2::Client.new
weiboToken = weiboClient.password.get_token(
    ENV['WEIBO_USERNAME'] || configs['weibo']['username'],
    ENV['WEIBO_PASSWORD'] || configs['weibo']['password'])
weiboClient.get_token_from_hash({:access_token => weiboToken.token,
                                 :expires_at => weiboToken.expires_at})


twitterClient.on_error do |message|
  puts message
end

twitterClient.on_timeline_status do |status|
  return if status.reply?
  return if status.user.id != twitter_user_id

  if weiboClient.authorized?
    weiboToken = weiboClient.password.get_token(configs['weibo']['username'], configs['weibo']['password'])
    weiboClient.get_token_from_hash({:access_token => weiboToken.token, :expires_at => weiboToken.expires_at})
  end

  return if weiboClient.statuses.nil?
  begin
    weiboText = institutionalizedWeibo(status.text) || DateTime.now().to_s
    weiboClient.statuses.update(weiboText)
  rescue OAuth2::Error => e
    if e.response and e.response.parsed['error_code'] == 20018
      weiboText = institutionalizedWeibo(status.text, true) || DateTime.now().to_s
      sleep(60)
      weiboClient.statuses.update(weiboText)
    end
  end
  puts '[Sent] %s - %s' % [status.text, DateTime.now().to_s]
end


twitterClient.filter('follow' => twitter_user_id)
