require 'sinatra/base'
require 'oauth'

module Myoack
  
class LocalAuthorization < Sinatra::Base
  enable :sessions
  HOST = "localhost"
  PORT = 13480

  get '/oauth/authorize' do
    cfg = Config.require_config(params[:id])
    consumer_key = cfg.consumer_key
    consumer_secret = cfg.consumer_secret
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, :site => cfg.site)
    req = consumer.get_request_token :oauth_callback => "http://#{HOST}:#{PORT}/oauth/callback"
    session['config_id'] = params[:id]
    session['request_token'] = req.token
    session['request_token_secret'] = req.secret
    redirect req.authorize_url
  end

  get '/oauth/callback' do
    cfg = Config.require_config(session['config_id'])
    consumer_key = cfg.consumer_key
    consumer_secret = cfg.consumer_secret
    consumer = OAuth::Consumer.new(consumer_key, consumer_secret, :site => cfg.site)
    req = OAuth::RequestToken.new consumer, session['request_token'], session['request_token_secret']
    acs = req.get_access_token :oauth_token => params[:oauth_token], :oauth_verifier => params[:oauth_verifier]
    cfg.access_token = acs.token
    cfg.access_token_secret = acs.secret
    cfg.save!
    "Configured successful!"
  end
end
end