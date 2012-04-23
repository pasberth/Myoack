require 'tumblife'
require 'myoack'
require 'oauth'
require 'json'
require 'pp'

cfg = Myoack::Config.require_config(:tumblr)
consumer = OAuth::Consumer.new(
               cfg.consumer_key,
               cfg.consumer_secret,
               :site => cfg.site)
acs = OAuth::AccessToken.new(
               consumer,
               cfg.access_token,
               cfg.access_token_secret)

tumb = Tumblife.new acs
pp tumb.dashboard.posts