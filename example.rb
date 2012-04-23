$:.unshift File.dirname(__FILE__) + '/lib'
require 'rubygems'
require 'myoack'
require 'oauth'
require 'json'
require 'pp'


cfg = Myoack::Config.require_config(:twitter)
consumer = OAuth::Consumer.new(
               cfg.consumer_key,
               cfg.consumer_secret,
               :site => cfg.site)
acs = OAuth::AccessToken.new(
               consumer,
               cfg.access_token,
               cfg.access_token_secret)
pp JSON.parse(acs.get('/statuses/mentions.json').body)