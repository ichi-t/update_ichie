# coding: utf-8
require 'rubygems'
require 'twitter'
require 'tweetstream'
require './keys.rb'


# -- Twitter ---

TweetStream.configure do |config|
    config.consumer_key       = CONSUMER_KEY
    config.consumer_secret    = CONSUMER_SECRET
    config.oauth_token        = ACCESS_TOKEN
    config.oauth_token_secret = ACCESS_SECRET
end

restclient = Twitter::REST::Client.new do |config|
    config.consumer_key        = CONSUMER_KEY 
    config.consumer_secret     = CONSUMER_SECRET
    config.access_token        = ACCESS_TOKEN
    config.access_token_secret = ACCESS_SECRET
end

# client = TweetStream::Client.new.follow('185792744') do |status|
client = TweetStream::Client.new.userstream do |status|
  puts status.text
  text = status.text

  if text.start_with? "RT","@","＠"
    p "avoid"
    next
  elsif text =~ /[@＠]/
    p "avoid"
    next

  elsif text.end_with? "!"
    p "next"
    next
  elsif text.end_with? "っちー"
    p "match"
    # newname = text.gsub(/っちー/)

    if text.length > 12 || status.user.screen_name == "Thunder_Pudding"
      p "!nagai"
      tweet = "@#{status.user.screen_name} お、そうだな"
      restclient.update(tweet, :in_reply_to_status_id => status.id)
      next
    else
      tweet = "@#{status.user.screen_name} #{text}ダヨ!"
      restclient.update_profile({:name => text})
      restclient.update(tweet, :in_reply_to_status_id => status.id)
      next
      # restclient.update(text + "ダヨ!")
    end
      
  end
end



