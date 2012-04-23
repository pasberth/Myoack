require 'myoack'
require 'oauth2'
require 'json'
require 'pp'

cfg = Myoack::Config.require_config(:github)
client = OAuth2::Client.new( cfg.client_id,
                             cfg.client_secret,
                            :site => cfg.site,
                            :authorize_url => cfg.authorize_url,
                            :token_url => cfg.access_token_url )
acs = OAuth2::AccessToken.new( client, cfg.access_token )
pp JSON.parse(acs.get('/gists').body)
